//
//  NetworkUtil.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/5/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import Foundation

func request(jsonObject :[String: AnyObject]) -> String{
    let addr = "127.0.0.1"
    let port = 1234
    
    var inp :NSInputStream?
    var out :NSOutputStream?
    
    NSStream.getStreamsToHostWithName(addr, port: port, inputStream: &inp, outputStream: &out)
    
    let inputStream = inp!
    let outputStream = out!
    inputStream.open()
    outputStream.open()
    
    do{ // Try to convert jsonObject into String
        let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonObject, options: NSJSONWritingOptions())
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        
        NSLog("@NetworkUtil.swift: JSON String: " + jsonString)
        
        // Add "\n" to the end for socketServer(java)
        outputStream.write(jsonString+"\n", maxLength: jsonString.characters.count + 1)
        
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
        
        NSLog("@NetworkUtil.swift: Done: "+res)
        
        return res
    }
    catch{
        return "Failed"
    }
}


// Not useful, just explore
func test(){
//    let myJSON = [
//        "name": "bob"
//    ]
//    let socket = SocketIOClient(socketURL: "localhost:1234")
//    NSLog("Initialized the client")
//    socket.connect()
//    NSLog("Estabelished the connection")
//    socket.emit("jsonTest", myJSON)
//    socket.close()
}
