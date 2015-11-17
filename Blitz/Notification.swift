//
//  Notification.swift
//  Blitz
//
//  Created by ccccccc on 15/11/17.
//  Copyright © 2015年 cs490. All rights reserved.
//

import Foundation

func notificaitonCreate(){ // need to set the text, notification_id,

    var notification = UILocalNotification()
    notification.alertBody = " Notificaiton-test" // text that will be displayed in the notification
    notification.alertAction = "open" // text that is displayed after "slide to..." on the lock screen - defaults to "slide to view"
    notification.fireDate = NSDate(timeIntervalSinceNow: 10)
    notification.timeZone = NSTimeZone.defaultTimeZone()
    notification.soundName = UILocalNotificationDefaultSoundName // play default sound
    notification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1

    
    UIApplication.sharedApplication().scheduleLocalNotification(notification)
    NSLog("@\(getFileName(__FILE__)) - \(__FUNCTION__): input = "+"notificaiton is created ")

}