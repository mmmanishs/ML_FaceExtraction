//
//  AppStart.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/15/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//

import Foundation
import AppKit

func startEvents(inputDir: String, outputDir: String) {
    print(ProcessInfo().arguments)
    guard let inputImagesDirectories = inputDir.getContents(fileType: .directory) else {
        return
    }
    inputImagesDirectories.forEach { directory in
        guard let imagesPath = directory.getContents(fileType: .file("png")) else {
            return
        }
        
        // Extracted face images.
        var extractedImages = [NSImage]()
        imagesPath.forEach { imagePath in
            guard let image = imagePath.getObject() else {
                return
            }
            image.extractFace { faceImages in
                if faceImages.count > 0 {
                    extractedImages.append(faceImages[0])
                }
            }
        }
        
        // Now save extracted face images
        let dirName = directory.nameFromPath
        let outputDir = outputDir.append(filePath: dirName)
        outputDir.makeDirectory()
        var imageNameCounter = 1
        
        extractedImages.forEach { image in
            outputDir.saveImage(image: image, named: "\(imageNameCounter).png")
            imageNameCounter += 1
        }
        
    }
}
