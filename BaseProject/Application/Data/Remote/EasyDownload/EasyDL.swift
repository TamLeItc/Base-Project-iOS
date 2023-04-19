//
//  Downloader.swift
//  BaseProject
//
//  Created by Tam Le on 9/17/21.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

internal typealias IsCached = Bool

public enum Strategy {
    case always, ifUpdated, ifNotCached
}

public final class Downloader {
    public let downloadItems: [DownloadItem]
    public let needsPreciseProgress: Bool
    public let commonStrategy: Strategy
    public let commonRequestHeaders: [String: String]?
    
    private var progressHandlers: [(Int64, Int64?, Int, Int64, Int64?) -> ()] = []
    private var completionHandlers: [(Result) -> ()] = []

    private var bytesDownloaded: Int64! = nil
    private var bytesExpectedToDownload: Int64? = nil
    private var bytesDownloadedForItem: Int64! = nil
    private var bytesExpectedToDownloadForItem: Int64? = nil
    private var result: Result? = nil
    
    private var session: DLSession
    private var zelf: Downloader? // To prevent releasing this instance during downloading

    private var currentItemIndex: Int = 0
    private var currentItem: DownloadItem! = nil
    private var currentCallback: ((Result) -> ())? = nil
    private var currentTask: URLSessionTask? = nil
    
    private var isCancelled: Bool = false
    
    public convenience init(
        downloadItems: [DownloadItem],
        needsPreciseProgress: Bool = true,
        commonStrategy: Strategy = .ifUpdated,
        commonRequestHeaders: [String: String]? = nil
    ) {
        self.init(session: FoundationURLSession(), downloadItems: downloadItems, needsPreciseProgress: needsPreciseProgress, commonStrategy: commonStrategy, commonRequestHeaders: commonRequestHeaders)
    }

    internal init(
        session: DLSession,
        downloadItems: [DownloadItem],
        needsPreciseProgress: Bool,
        commonStrategy: Strategy,
        commonRequestHeaders: [String: String]?
    ) {
        self.session = session
        self.downloadItems = downloadItems
        self.needsPreciseProgress = needsPreciseProgress
        self.commonStrategy = commonStrategy
        self.commonRequestHeaders = commonRequestHeaders
        
        zelf = self
        
        func download(_ isCached: [IsCached]) {
            assert(downloadItems.count == isCached.count) // Always true for `Downloader` without bugs
            self.download(ArraySlice(zip(downloadItems, isCached)), self.complete(with:))
        }

        if needsPreciseProgress {
            contentLength(of: downloadItems[...]) { result in
                switch result {
                case .cancel:
                    self.complete(with: .cancel)
                case let .failure(error):
                    self.complete(with: .failure(error))
                case let .success(length, isCached):
                    self.bytesExpectedToDownload = length
                    download(isCached)
                }
            }
        } else {
            download([IsCached](repeating: false, count: downloadItems.count))
        }
    }
    
    private func contentLength(of downloadItems: ArraySlice<DownloadItem>, _ callback: @escaping (ContentLengthResult) -> ()) {
        guard let first = downloadItems.first else {
            DispatchQueue.main.async {
                callback(.success(0, []))
            }
            return
        }
        
        contentLength(of: first) { result in
            switch result {
            case .cancel, .failure:
                callback(result)
            case let .success(headLength, headCached):
                let tail = downloadItems[(downloadItems.startIndex + 1)...]
                guard let headLength = headLength else {
                    callback(.success(nil, headCached + [IsCached](repeating: false, count: downloadItems.count - 1)))
                    break
                }
                
                self.contentLength(of: tail) { result in
                    switch result {
                    case .cancel, .failure:
                        callback(result)
                    case let .success(tailLength, tailCached):
                        guard let tailLength = tailLength else {
                            callback(.success(nil, headCached + tailCached))
                            break
                        }
                        
                        callback(.success(headLength + tailLength, headCached + tailCached))
                    }
                }
            }
        }
    }
    
    private func contentLength(of item: DownloadItem, _ callback: @escaping (ContentLengthResult) -> ()) {
        if isCancelled {
            callback(.cancel)
            return
        }
        
        var modificationDate: Date?
        var headerFields: [String: String] = [:]
        commonRequestHeaders?.forEach {
            headerFields[$0.0] = $0.1
        }
        switch item.strategy ?? commonStrategy {
        case .always:
            break
        case .ifUpdated:
            modificationDate = item.modificationDate
        case .ifNotCached:
            if item.fileExists {
                callback(.success(0, [true]))
                return
            }
        }
        let request = DLSession.Request(url: item.url, modificationDate: modificationDate, headerFields: headerFields)
        session.contentLengthWith(request, callback)
    }
    
    private func download(_ downloadItems: ArraySlice<(DownloadItem, IsCached)>, _ callback: @escaping (Result) -> ()) {
        currentItemIndex = downloadItems.startIndex
        
        guard let first = downloadItems.first else {
            callback(.success)
            return
        }
        
        let (item, isCached) = first
        download(item, isCached) { result in
            switch result {
            case .cancel, .failure:
                callback(result)
            case .success:
                self.download(downloadItems[(downloadItems.startIndex + 1)...], callback)
            }
        }
    }
    
    private func download(_ item: DownloadItem, _ isCached: IsCached, _ callback: @escaping (Result) -> ()) {
        if isCancelled {
            callback(.cancel)
            return
        }
        
        if isCached {
            callback(.success)
            return
        }
        
        currentItem = item
        currentCallback = callback
        
        var modificationDate: Date?
        var headerFields: [String: String] = [:]
        commonRequestHeaders?.forEach {
            headerFields[$0.0] = $0.1
        }
        switch item.strategy ?? commonStrategy {
        case .always:
            break
        case .ifUpdated:
            modificationDate = item.modificationDate
        case .ifNotCached:
            break
        }

        let request = DLSession.Request(url: item.url, modificationDate: modificationDate, headerFields: headerFields)
        session.downloadWith(request, progressHandler: { [weak self] progress in
            guard let self = self else { return }
            
            self.bytesDownloadedForItem = progress.totalBytesDownloaded
            self.bytesExpectedToDownloadForItem = progress.totalBytesExpectedToDownload
            self.makeProgress(
                bytesDownloaded: progress.bytesDownloaded,
                totalBytesDownloadedForItem: progress.totalBytesDownloaded,
                totalBytesExpectedToDownloadForItem: progress.totalBytesExpectedToDownload
            )
        }, resultHandler: { result in
            switch result {
            case .success((location: let location, modificationDate: let modificationDate)?):
                let fileManager = FileManager.default
                try? fileManager.removeItem(atPath: item.destination) // OK though it fails if the file does not exists
                do {
                    try fileManager.moveItem(at: location, to: URL(fileURLWithPath: item.destination))
                    if let modificationDate = modificationDate {
                        try fileManager.setAttributes([.modificationDate: modificationDate], ofItemAtPath: item.destination)
                    }
                    callback(.success)
                } catch let error {
                    callback(.failure(error))
                }
            case .success(.none):
                callback(.success)
            case .cancel:
                callback(.cancel)
            case .failure(let error):
                callback(.failure(error))
            }
        })
    }
    
    private func makeProgress(bytesDownloaded: Int64, totalBytesDownloadedForItem: Int64, totalBytesExpectedToDownloadForItem: Int64?) {
        if let _ = self.bytesDownloaded {
            self.bytesDownloaded! += bytesDownloaded
        } else {
            self.bytesDownloaded = bytesDownloaded
        }
        progressHandlers.forEach {
            $0(
                self.bytesDownloaded,
                self.bytesExpectedToDownload,
                self.currentItemIndex,
                totalBytesDownloadedForItem,
                totalBytesExpectedToDownloadForItem
            )
        }
    }
    
    private func complete(with result: Result) {
        completionHandlers.forEach {
            $0(result)
        }
        
        self.result = result
        
        progressHandlers.removeAll()
        completionHandlers.removeAll()
        
        session.complete()
        zelf = nil
    }
    
    public func cancel() {
        DispatchQueue.main.async {
            if self.isCancelled { return }
            
            self.isCancelled = true
            self.currentTask?.cancel()
        }
    }
    
    public func progress(
        _ handler: @escaping (
            _ bytesDownloaded: Int64,
            _ bytesExpectedToDownload: Int64?,
            _ itemIndex: Int,
            _ bytesDownloadedForItem: Int64,
            _ bytesExpectedToDownloadForItem: Int64?
        ) -> ()
    ) {
        DispatchQueue.main.async { [weak self] in
            if let self = self, let bytesDownloaded = self.bytesDownloaded {
                handler(
                    bytesDownloaded,
                    self.bytesExpectedToDownload,
                    self.downloadItems.count,
                    self.bytesDownloadedForItem,
                    self.bytesExpectedToDownloadForItem
                )
            }
            guard let zelf = self, zelf.result == nil else {
                return
            }
            
            self?.progressHandlers.append(handler)
        }
    }
    
    public func completion(_ handler: @escaping (Result) -> ()) {
        DispatchQueue.main.async {
            if let result = self.result {
                handler(result)
                return
            }
            
            self.completionHandlers.append(handler)
        }
    }
}

extension Downloader {
    public struct DownloadItem {
        public var url: URL
        public var destination: String
        public var strategy: Strategy?
        
        public init(url: URL, destination: String, strategy: Strategy? = nil) {
            self.url = url
            self.destination = destination
            self.strategy = strategy
        }
        
        internal var modificationDate: Date? {
            return (try? FileManager.default.attributesOfItem(atPath: destination))?[FileAttributeKey.modificationDate] as? Date
        }
        
        internal var fileExists: Bool {
            return FileManager.default.fileExists(atPath: destination)
        }
    }

    public enum Result {
        case success
        case cancel
        case failure(Error)
    }

    public struct ResponseError: Error {
        public let response: URLResponse
    }

    internal enum ContentLengthResult {
        case success(Int64?, [IsCached])
        case cancel
        case failure(Error)
    }
}
