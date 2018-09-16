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

// Input Directory: Folders with images are expected in this folder
let movie1 = "/Users/manishsingh/Desktop/Extract/Manish.MOV"
let movie2 = "/Users/manishsingh/Desktop/Extract/Person2.MOV"

// Pass all the parameters in the command line and handle folder creation and deletion

func main() {
    guard let appArgument = AppArgument(processInfo: ProcessInfo().arguments) else {
        print("Unexpected number of arguments")
        print("Valid example")
        print("programName inputDirectory outputDirectory")
        return
    }
    
    let scriptOutputFolder = appArgument.tempPath.append(filePath: "SplitImagesFromVideos")
    scriptOutputFolder.delete()
    scriptOutputFolder.makeDirectory()

    // Split movie into images
    let scriptPath = appArgument.appPath._cd__() + "/split.sh"
    startImageSplit(scriptPath: scriptPath, outputFolder: scriptOutputFolder, inputMovies: appArgument.moviePath)
    
    let faceCropOutputFolder = appArgument.tempPath.append(filePath: "FaceCroppedFromImages")
    // Extract face out of images
    startExtractImageProcess(inputDir: scriptOutputFolder, outputDir: faceCropOutputFolder)
    
    // Now delete the images which we got from the movies
    scriptOutputFolder.delete()
    
    // Perform cleanup after running ML
}

main()
