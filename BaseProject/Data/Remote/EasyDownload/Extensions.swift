//
//  Downloader.swift
//  BaseProject
//
//  Created by Tam Le on 9/17/21.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

extension Downloader {
    public convenience init(
        downloadItems: [(URL, String)],
        needsPreciseProgress: Bool = true,
        commonStrategy: Strategy = .ifUpdated,
        commonRequestHeaders: [String: String]? = nil
    ) {
        self.init(
            downloadItems: downloadItems.map { Downloader.DownloadItem(url: $0.0, destination: $0.1) },
            needsPreciseProgress: needsPreciseProgress,
            commonStrategy: commonStrategy,
            commonRequestHeaders: commonRequestHeaders
        )
    }

    public func progress(
        _ handler: @escaping (
            _ bytesDownloaded: Int64,
            _ bytesExpectedToDownload: Int64?
        ) -> ()
    ) {
        progress { done, whole, _, _, _ in
            handler(done, whole)
        }
    }
    
    public func progress(_ handler: @escaping (Float?) -> ()) {
        if needsPreciseProgress {
            progress { done, whole in
                handler(whole.map { whole in Float(Double(done) / Double(whole)) })
            }
        } else {
            progress { _, _, itemIndex, done, whole in
                handler(whole.map { whole in (Float(itemIndex) + Float(Double(done) / Double(whole))) / Float(self.downloadItems.count) })
            }
        }
    }
}
