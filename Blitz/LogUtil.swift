//
//  LogUtil.swift
//  Blitz
//
//  Created by Tianyang Yu on 11/11/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import Foundation

func getFileName(path: String) -> String {
    var parts =  path.componentsSeparatedByString("/")
    return parts[parts.count-1]
}