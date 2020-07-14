//
//  AppDelegate.swift
//  StageProgram
//
//  Created by Rohit Sharma on 10/06/20.
//  Copyright © 2020 MedRec Technologies. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 10)!, NSAttributedString.Key.foregroundColor : UIColor(red: 209/255, green: 156/255, blue: 165/255, alpha: 1.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Montserrat-SemiBold", size: 10)!, NSAttributedString.Key.foregroundColor : UIColor.white], for: .selected)
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func createHomeController() {
        let window = UIApplication.shared.windows.first
        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let initialViewController : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        initialViewController.modalPresentationStyle = .fullScreen
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if let _ = UIApplication.getTopViewController() as? SPVideoDetailViewController {
            return .allButUpsideDown
        } else if let _ = UIApplication.getTopViewController() as? YoutubePlayerViewController {
            return .landscapeRight
        }
        return .portrait
    }
}


extension UIApplication {

    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {

        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
