//
//  AppArgument.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/16/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//

import Foundation

struct AppArgument {
    let appPath: String
    let tempPath: String // This can be the temp directory for the system. Need to store temp files
    let moviePath: [String] // Have the movie files here
    let outputPath: String
    
    init?(processInfo: [String]) {
        guard processInfo.count >= 4 else {
            return nil
        }
        var arguments = processInfo
        appPath = arguments.removeFirst()
        tempPath = arguments.removeFirst()
        outputPath = arguments.removeLast()
        
        // Now the rest all are movie paths. So lets get to it
        moviePath = arguments
    }
}
