//
//  StringExtension+Directory.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/15/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//

import Foundation
import AppKit

// MARK: Extension on String which deals with file handling
extension String {
    var url: URL {
        get {
            return URL(string: self)!
        }
    }
    
    var canBeUrl: Bool {
        get {
            let url = URL(string: self)
            return url != nil
        }
    }
    
    var nameFromPath: String { // Gives directory name or file name from the path
        get {
            let newUrl = url.deletingPathExtension()
            return newUrl.lastPathComponent
        }
    }
    
    func _cd__() -> String {
        var path = components(separatedBy: "/")
        path.removeLast()
        return path.joined(separator: "/")
    }
    
    func append(filePath: String) -> String {
        var path = self
        if self[count - 1] != "/" {
            path += "/"
        }
        return path + filePath
    }
    
    // get file name from path
    func getContents(fileType: FileType) -> [String]? {
        let fileManager = FileManager.default
        let contents = try? fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsSubdirectoryDescendants)
        switch fileType {
        case .directory:
            return (contents?.filter { file in
                return file.hasDirectoryPath
                }.map { url in
                    url.absoluteString
                })
        case .file(let fileExtension):
            return (contents?.filter { url in
                return !url.hasDirectoryPath && url.pathExtension == fileExtension
                }.map { url in
                    return url.absoluteString
                })
        }
    }
    
    func makeDirectory(directoryName: String) {
        var path = self
        if self[count - 1] != "/" {
            path += "/"
        }
        path += directoryName
        let url = URL(fileURLWithPath: path, isDirectory: true)
        try? FileManager().createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    
    func delete() {
        let fileManager = FileManager.default
        try? fileManager.removeItem(atPath: self)
    }
    
    func makeDirectory() {
        try? FileManager.default.createDirectory(atPath: self, withIntermediateDirectories: true, attributes: nil)
    }
    
    func saveImage(image: NSImage, named: String) {
        let savePath = append(filePath: named)
        try? FileManager.default.createFile(atPath: savePath, contents: image.tiffRepresentation, attributes: nil)
    }
    
    func getObject<T>() -> T? where T: NSImage {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return T(data: data)
    }
}

enum FileType {
    case directory
    case file(String)
}
