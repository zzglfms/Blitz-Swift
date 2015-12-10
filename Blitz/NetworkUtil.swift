//
//  NetworkUtil.swift
//  Blitz
//
//  Created by Tianyang Yu on 10/5/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import Foundation

let operationToPortMap = [
    "Login": 9066,
    "Signup": 9066,
    "ForgetPassword": 9066,
    "GetProfile":9066,
    "ModifyProfile": 9066,
    "Query": 9067,
    "CreatePost": 9068,
    "GetPostDetail": 9069,
    "OfferPrice": 9069,
    "DeleteOffer": 9069,
    "AcceptOffer": 9069,
    "UploadPicture": 9071,
    "GetPicture": 9071,
    "GetNotifications": 9072,
    "PostNotifications": 9072
]


func getResultFromServerAsJSONObject(inputJSON: [String: AnyObject]) -> [String: AnyObject] {
    let JSONString = getJSONStringFromServer(inputJSON)
    if let data = JSONString.dataUsingEncoding(NSUTF8StringEncoding){
        do {
            let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? Dictionary<String, AnyObject>
            if let _ = parsedObject{
                return parsedObject!
            }
            else {
                return [:]
            }
        }
        catch {
            NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Error when use NSJSONSerialization.JSONObjectWithData")
            return [ "error": true, "success": false, "msg": "Error when use NSJSONSerialization.JSONObjectWithData" ]
        }
    }
    NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Error when use String.dataUsingEncoding")
    return [ "Error": true, "success": false, "msg": "Error when use String.dataUsingEncoding" ]
}


func getResultFromServerAsJSONArray(inputJSON: [String: AnyObject]) -> [[String: AnyObject]] {
    let JSONString = getJSONStringFromServer(inputJSON)
    if let data = JSONString.dataUsingEncoding(NSUTF8StringEncoding){
        do {
            let parsedObject = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves) as? [Dictionary<String, AnyObject>]
            return parsedObject!
        }
        catch {
            NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Error when use NSJSONSerialization.JSONObjectWithData")
            return [[ "error": true, "success": false, "msg": "Error when use NSJSONSerialization.JSONObjectWithData"]]
        }
    }
    NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Error when use String.dataUsingEncoding")
    return [[ "error": true, "success": false, "msg": "Error when use String.dataUsingEncoding" ]]
}


func getJSONStringFromServer(inputJSON: [String: AnyObject]) -> String {
    let addr = "blitzproject.cs.purdue.edu"
    let port = operationToPortMap[inputJSON["operation"] as! String]
    
    var inp :NSInputStream?
    var out :NSOutputStream?
    
    NSStream.getStreamsToHostWithName(addr, port: port!, inputStream: &inp, outputStream: &out)
    
    let inputStream = inp!
    let outputStream = out!
    inputStream.open()
    outputStream.open()
    
    do{ // Try to convert jsonObject into String
        let jsonData = try NSJSONSerialization.dataWithJSONObject(inputJSON, options: NSJSONWritingOptions())
        let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
        
        //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): input JSON String = " + jsonString)
        
        // Add "\n" to the end for socketServer(java)
        outputStream.write(jsonString+"\n", maxLength: jsonString.characters.count + 1)
        
        var buffer = [UInt8](count: 8, repeatedValue: 0)
        var res = ""
        var isWait :Bool = true
        while true {
            let result :Int = inputStream.read(&buffer, maxLength: buffer.count)
            let char = String(bytes: buffer, encoding: NSUTF8StringEncoding)!
            //print((char, result))
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
        
        //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result JSON String = " + res)
        return res
    }
    catch{
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Error when use 'NSJSONSerialization.dataWithJSONObject")
        return String([ "error": true, "success": false,"msg": "Error when use 'NSJSONSerialization.dataWithJSONObject'"])
    }
    
}