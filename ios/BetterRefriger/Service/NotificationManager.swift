//
//  NotificationManager.swift
//  BetterRefriger
//
//  Created by Myungji Choi on 15/12/2018.
//  Copyright © 2018 maengji.com. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject {
  private let notificationType = "expireNotification"
  var foods: [FoodModel] = []
//  var name: String?
//  var expireDate: Date?

  static let getInstance = NotificationManager()
  private override init() {
    super.init()
  }

  func message(type: String = "expireNotification") -> String {
    return ""
  }

  func requestNotification() {
    guard foods.count > 0 else { return }

    let expireDate = foods[0].expireDate
    let center = UNUserNotificationCenter.current()
    let options: UNAuthorizationOptions = [.alert, .sound]

    center.requestAuthorization(options: options) { (granted, error) in
      guard granted else { return }
      guard let content = self.makeNotificationContent() else { return }

      let calendar = Calendar.current
      var components = calendar.dateComponents([.hour, .minute, .second], from: expireDate)

      components.hour = 21
      components.minute = 12

      let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
      let request = UNNotificationRequest(identifier: self.notificationType, content: content, trigger: trigger)
      let center = UNUserNotificationCenter.current()
      center.add(request) { (error) in
        print(error?.localizedDescription ?? "")
      }
    }
  }

  private func makeNotificationContent() -> UNMutableNotificationContent? {
    guard foods.count > 0 else { return nil }
    let name = foods[0].foodName

    let content = UNMutableNotificationContent()
    content.categoryIdentifier = notificationType
    content.body = "\(name)의 유통기한이 다 되어갑니다."

    return content
  }
}
