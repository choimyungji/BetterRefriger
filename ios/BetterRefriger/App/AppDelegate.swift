//
//  AppDelegate.swift
//  BetterRefriger
//
//  Created by Myungji on 2017. 2. 12..
//  Copyright © 2017년 maengji.com. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    return true
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  func applicationWillTerminate(_ application: UIApplication) {
    self.saveContext()
  }

  func application(_ application: UIApplication,
                   continue userActivity: NSUserActivity,
                   restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { dynamiclink, error in
      guard error != nil else { return }
      print(dynamiclink?.description ?? "")
      Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
        AnalyticsParameterItemID: "id-url",
        AnalyticsParameterItemName: userActivity.webpageURL?.absoluteString ?? "",
        AnalyticsParameterContentType: "cont"
        ])
    }

    return handled
  }

  open func application(_ app: UIApplication, open url: URL,
                        options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
    return application(app, open: url,
                       sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                       annotation: "")
  }

  func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
    if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
      print(dynamicLink.description)
      return true
    }
    return false
  }

  // MARK: - Core Data stack
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "BetterRefriger")
    container.loadPersistentStores(completionHandler: { (_, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    
  }
  // MARK: - Core Data Saving support
  func saveContext () {
    let context = persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
}

extension AppDelegate: MessagingDelegate {
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("Firebase registration token: \(String(describing: fcmToken))")
  }
}
