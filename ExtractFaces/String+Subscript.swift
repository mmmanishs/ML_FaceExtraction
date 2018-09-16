//
//  String+Subscript.swift
//  ExtractFaces
//
//  Created by Manish Singh on 9/15/18.
//  Copyright © 2018 Manish Singh. All rights reserved.
//

import Foundation

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    func getSubstring(start: Int, end: Int) -> String {
        let start = index(startIndex, offsetBy: start)
        let end = index(startIndex, offsetBy: end)
        let range = start...end
        return String(self[range])
    }
}
