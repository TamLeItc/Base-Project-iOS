//
//  FileUtils.swift
//  BaseProject
//
//  Created by Tam Le on 8/19/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import Foundation

class FileHelper {
    static let shared = FileHelper()
    
    private init() {}
    
    func getItemDataLocal<T: Codable> (_ path: String) -> T? {
        do {
            let jsonData = readLocalFile(path)
            if jsonData == nil {
                Logger.error("Read data failed \(path)")
                return nil
            }
            else {
                return try JSONDecoder().decode(T.self, from: jsonData!)
            }
        } catch let error {
            Logger.error("Parse data failed: \(error.localizedDescription) - \(path)")
            return nil
        }
    }
    
    func getItemDataLocal<T: Codable> (fileName: String, fileType: String) -> T? {
        do {
            let jsonData = try readLocalFile(forName: fileName, fileType: fileType)
            if jsonData == nil {
                Logger.error("Read data failed \(fileName)")
                return nil
            }
            else {
                return try JSONDecoder().decode(T.self, from: jsonData!)
            }
        } catch {
            Logger.error("Parse data failed \(error.localizedDescription) - \(fileName)")
            return nil
        }
    }
    
    func getListDataLoca<T: Codable>(_ path: String) -> [T]? {
        do {
            let jsonData = readLocalFile(path)
            if jsonData == nil {
                Logger.error("Read data failed \(path)")
                return nil
            }
            else {
                return try JSONDecoder().decode([T].self, from: jsonData!)
            }
        } catch let error {
            Logger.error("Parse data failed: \(error.localizedDescription) - \(path)")
            return nil
        }
    }
    
    func getListDataLocal<T: Codable>(fileName: String, fileType: String) -> [T]? {
        do {
            let jsonData = try readLocalFile(forName: fileName, fileType: fileType)
            if jsonData == nil {
                Logger.error("Read data failed \(fileName)")
                return nil
            }
            else {
                return try JSONDecoder().decode([T].self, from: jsonData!)
            }
        } catch {
            Logger.error("Parse data failed \(error.localizedDescription) - \(fileName)")
            return nil
        }
    }
    
    func readLocalFile(_ path: String) -> Data? {
        do {
            if let jsonData = try String(contentsOfFile: path).data(using: .utf8) {
                return jsonData
            }
        } catch let error {
            Logger.error("Read data failed \(error)")
        }
        return nil
    }
    
    func readLocalFile(forName name: String, fileType: String) throws -> Data? {
        if let bundlePath = Bundle.main.path(forResource: name, ofType: fileType),
            let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
            return jsonData
        }
        return nil
    }
}
