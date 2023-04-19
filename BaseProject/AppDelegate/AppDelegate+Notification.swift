//
//  AppDelegate+ConfigNoti.swift
//  BaseProject
//
//  Created by Tam Le on 9/21/20.
//  Copyright © 2020 Tam Le. All rights reserved.
//

import UIKit

extension AppDelegate {
    
    func notificationConfig() {
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        
        if !Configs.NotificationLocal.enableLocalNotification {
            return
        }
        
        let time = UserDefaultHelper.shared.hourToPushLocalNoti
        //Time to push local notificatoin in the range 8:00 AM to 20:00 PM
        if time < 8 || time > 20 {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UserDefaultHelper.shared.hourToPushLocalNoti = Calendar.current.component(.hour, from: Date())
        } else {
            return
        }
        
        let itemContent = Configs.NotificationLocal.contentTrigger.randomElement()
        
        if itemContent == nil {
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = itemContent!.title
        content.body = itemContent!.body
        content.sound = UNNotificationSound.default
        
        if let path = Bundle.main.path(forResource: "AppIcon", ofType: "jpg") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "AppIcon", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                Logger.error("NotiConfig Error: Failed to load The attachment.")
            }
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(Configs.NotificationLocal.timeTriggerNoti), repeats: true)
        let request = UNNotificationRequest(identifier: itemContent!.title, content: content, trigger: trigger)
        
        let notiCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notiCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        notiCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                Logger.error("NotiConfig Error: User has declined notifications")
            }
        }
        
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error {
                Logger.error("NotiConfig Error: error : \(error)")
            } else {
                print("NotiConfig success")
            }
        }
    }
}
