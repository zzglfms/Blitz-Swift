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
    "Rate": 9066,
    "ForgetPassword": 9066,
    "GetProfile":9066,
    "ModifyProfile": 9066,
    "Query": 9067,
    "CreatePost": 9068,
    "DeletePost": 9068,
    "GetPostDetail": 9069,
    "OfferPrice": 9069,
    "DeleteOffer": 9069,
    "AcceptOffer": 9069,
    "UploadPicture": 9071,
    "GetPicture": 9071,
    "GetNotifications": 9072,
    "PostNotifications": 9072,
    "upload": 9071,
    "getpic": 9071,
    "getpic2": 9071
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
    return [ "error": true, "success": false, "msg": "Error when use String.dataUsingEncoding" ]
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
        
        var buffer = [UInt8](count: 1000, repeatedValue: 0)
        var res = ""
        var isWait :Bool = true
        while true {
            let result :Int = inputStream.read(&buffer, maxLength: buffer.count)
            let char = String(bytes: buffer, encoding: NSUTF8StringEncoding)!
            //print((char, result, res.characters.count))
            if result == -1{
                // Connection fail
                break
            }
            if result == 0 && !isWait{
                break
            }
            if result > 0 {
                let index1 = char.endIndex.advancedBy(result-1000)
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



func getPicture(inputJSON: [String: AnyObject]) -> [String: AnyObject] {
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
        
        var buffer = [UInt8](count: 1000, repeatedValue: 0)
        var res = ""
        var isWait :Bool = true
        while true {
            let result :Int = inputStream.read(&buffer, maxLength: buffer.count)
            let char = String(bytes: buffer, encoding: NSUTF8StringEncoding)!
            //print((char, result, res.characters.count))
            if result == -1{
                // Connection fail
                break
            }
            if result == 0 && !isWait{
                break
            }
            if result > 0 {
                let index1 = char.endIndex.advancedBy(result-1000)
                res += char.substringToIndex(index1)
                if res.rangeOfString("}") != nil{
                   break
                }
                isWait = false;
            }
        }
        
        //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result JSON String = " + res)
        if let data = res.dataUsingEncoding(NSUTF8StringEncoding){
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
        return [ "error": true, "success": false, "msg": "Error when use String.dataUsingEncoding" ]
    }
    catch{
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Error when use 'NSJSONSerialization.dataWithJSONObject")
        return [ "error": true, "success": false,"msg": "Error when use 'NSJSONSerialization.dataWithJSONObject'"]
    }
    
}




func postImage(image : UIImage){
    /*let url: NSURL = NSURL(string: "http://blitzproject.cs.purdue.edu:9075/UploadFileServer/upload")!
    let request = NSMutableURLRequest(URL: url)
    request.HTTPMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let imageData = UIImageJPEGRepresentation(image, 0.9)
    let base64String = imageData!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0)) // encode the image
    let params = ["image":[ "content_type": "image/jpeg", "filename":"test.jpg", "file_data": base64String]]
    do{
        request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: NSJSONWritingOptions(rawValue: 0))
    } catch _ {
    
    }
    let session = NSURLSession.sharedSession()
    let task = session.dataTaskWithRequest(request.mutableURl , completionHandler: { data, response, error -> Void in
        _ = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let _: NSError?
        
        // process the response
    })
    
    task.resume()*/
    
    let imageData = UIImagePNGRepresentation(image)
    if imageData != nil{
        let request = NSMutableURLRequest(URL: NSURL(string:"blitzproject.cs.purdue.edu:9075/UploadFileServer/upload")!)
        request.HTTPMethod = "POST"
        request.HTTPBody = NSData(data: imageData!)

        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): sending the image to server")
        do{
            let returnData =  try NSURLConnection.sendSynchronousRequest(request, returningResponse: nil)
            let returnString = NSString(data: returnData, encoding: NSUTF8StringEncoding)
            print("returnString \(returnString)")
        } catch {
            NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): Catch An error")

        }
        NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): done")
    }
}

func getImage(url : NSURL){
    
    
}