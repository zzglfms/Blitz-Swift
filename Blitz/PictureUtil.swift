//
//  PictureUtil.swift
//  Blitz
//
//  Created by Tianyang Yu on 12/10/15.
//  Copyright © 2015 cs490. All rights reserved.
//

import Foundation
import UIKit

func picture_upload(imageData: NSData) -> [String] {
    let base64String = imageData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 1))
    let myNSString = base64String as NSString
    var id_array: [String] = []
    
    var i = 0
    while i < myNSString.length{
        var dataString = ""
        if (i+1000) < myNSString.length{
            dataString = myNSString.substringWithRange(NSRange(location: i, length: 1000))
            i = i + 1000
        }else{
            dataString = myNSString.substringWithRange(NSRange(location: i, length: (myNSString.length - i)))
            i = i + 1000
        }
        let json:[String: AnyObject] = [
            "operation": "upload",
            "data": dataString
        ]
        let result = JSON(getResultFromServerAsJSONObject(json))
        if result["success"].bool!{
            id_array.append(result["id"].string!)
        }
    }
    NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__):  Upload picuture Done ")
    
    return id_array
}

func picture_download(id_array: [String]) -> UIImage {
    var myNSString = ""
    
    for id in id_array {
        //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): id = %@", id)
        let json:[String: AnyObject] = [
            "operation": "getpic",
            "id": id
        ]
        let result = JSON(getPicture(json))
        //NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): result = ")
        if result["success"].bool! {
            myNSString = myNSString + result["data"].string! 
        }
    }

    let decodedData = NSData(base64EncodedString: myNSString as String, options: NSDataBase64DecodingOptions(rawValue: 1))
    let image = UIImage.init(data: decodedData!)
    
    return image!
}
