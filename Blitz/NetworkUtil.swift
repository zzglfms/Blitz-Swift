//
//  NetworkUtil.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/5/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import Foundation

func request(data :String) -> String{
    let addr = "127.0.0.1"
    let port = 1234
    
    var inp :NSInputStream?
    var out :NSOutputStream?
    
    NSStream.getStreamsToHostWithName(addr, port: port, inputStream: &inp, outputStream: &out)
    
    let inputStream = inp!
    let outputStream = out!
    inputStream.open()
    outputStream.open()
    
    // buffer is a UInt8 array containing bytes of the string "Jonathan Yaniv.".
    outputStream.write(data+"\n", maxLength: data.characters.count + 1)
    
    var buffer = [UInt8](count: 8, repeatedValue: 0)
    var res = ""
    var isWait :Bool = true
    while true {
        let result :Int = inputStream.read(&buffer, maxLength: buffer.count)
        let char = String(bytes: buffer, encoding: NSUTF8StringEncoding)!
        print((char, result))
        if result == -1{
            // Connection fail
            break
        }
        if result == 0 && !isWait{
            break
        }
        if result > 0 {
            let index1 = char.endIndex.advancedBy(result-8)
            res += char.substringToIndex(index1)
            isWait = false;
        }
    }
    NSLog("Done: "+res)
    
    return res
}
