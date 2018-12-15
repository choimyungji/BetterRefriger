//
//  NotificationManager.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 15/12/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
  private let requestId = "expireNotification"

  var name: String?
  var expireDate: Date?

  func requestNotification() {
    guard let name = self.name, let expireDate = self.expireDate else { return }

    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]

    center.requestAuthorization(options: options) { (granted, error) in
      if granted {
        let content = UNMutableNotificationContent()
        content.categoryIdentifier = self.requestId
        content.body = "\(name)의 유통기한이 다 되어갑니다."
        let calendar = Calendar.current

        var components = calendar.dateComponents([.hour, .minute, .second], from: expireDate)

        components.hour = 21
        components.minute = 12

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(identifier: self.requestId, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
          print(error?.localizedDescription ?? "")
        }
      }
    }
  }
}
