//
//  main.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/13/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//

import Foundation
import Vision
import AppKit

// Main Directory
var mainDirectory = "/Users/manishsingh/Desktop/Extract"

// Input Directory: Folders with images are expected in this folder
var inputDirectory = "/Users/manishsingh/Desktop/Extract/Input"

// Output Directory: Cropped face images will be put here, in the folders from which they were extracted from (Folders in the Input directory)
let outputDirectoryHomePath = "/Users/manishsingh/Desktop/Extract/Output"

func main() {
    guard let inputImagesDirectories = inputDirectory.getContents(fileType: .directory) else {
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
        let outputDir = outputDirectoryHomePath.append(filePath: dirName)
        outputDir.makeDirectory()
        var imageNameCounter = 1
        
        extractedImages.forEach { image in
            outputDir.saveImage(image: image, named: "\(imageNameCounter).png")
            imageNameCounter += 1
        }
        
    }
}

main()
