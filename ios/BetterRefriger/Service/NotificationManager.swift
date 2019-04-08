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

  private let center = UNUserNotificationCenter.current()
  var foods: [FoodModel] = []

  static let getInstance = NotificationManager()
  private override init() {
    super.init()
  }

  func message(type: String = "expireNotification",
               completion: @escaping (String) -> Void) {
    center.getPendingNotificationRequests(completionHandler: { req in
      completion(req[0].content.body)
    })
  }

  func requestNotification() {
    guard foods.count > 0 else { return }

    let expireDate = foods[0].expireDate
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
      self.center.add(request) { (error) in
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
