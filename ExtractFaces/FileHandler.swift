//
//  FileHandler.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/13/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//

import Foundation
import AppKit

class FileHandler {
    static func saveImage(image: NSImage, named: String, toDirectory directory: String) {
        let url = URL(fileURLWithPath: directory + named, isDirectory: false)
        image.writePNG(toURL: url)
    }
    
    static func getDirectories(at path: String) -> [String]? {
        if let contents = try? FileManager().contentsOfDirectory(atPath: path) {
            return contents.filter { file in
                return file != ".DS_Store"
            }
        }
        return nil
    }
    
    static func createDirectory(withName name: String, atPath directory: String) {
        let path = directory + name
        let url = URL(fileURLWithPath: path, isDirectory: true)
        try? FileManager().createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
    }
    
    static func createSubDirectories(directoriesPath: [String], atPath: String) {
        directoriesPath.forEach { directory in
            FileHandler.createDirectory(withName: directory, atPath: atPath)
        }
    }
    
    static func getImages(atPath path: String) -> [NSImage]? {
        var images = [NSImage]()
        if let contents = try? FileManager().contentsOfDirectory(atPath: path) {
            _  = contents.filter { file in
                return file != ".DS_Store"
                }.forEach { file in
                    let filepath = path + file
                    let url = URL(fileURLWithPath: filepath, relativeTo: nil)
                    if !url.isDirectory {
                        let image = NSImage(contentsOf: url)
                        images.append(image!)
                    }
            }
            return images
        }
        return nil
    }
}

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    var subDirectories: [URL] {
        guard isDirectory else { return [] }
        return (try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter{ $0.isDirectory }) ?? []
    }
}

public extension NSImage {
    public func writePNG(toURL url: URL) {
        
        guard let data = tiffRepresentation,
            let rep = NSBitmapImageRep(data: data),
            let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {
                
                Swift.print("\(self.self) Error Function '\(#function)' Line: \(#line) No tiff rep found for image writing to \(url)")
                return
        }
        
        do {
            try imgData.write(to: url)
        }catch let error {
            Swift.print("\(self.self) Error Function '\(#function)' Line: \(#line) \(error.localizedDescription)")
        }
    }
}
