//
//  AppDelegate.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import MMDrawerController
import MagicalRecord
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var drawerVC: MMDrawerController?
    lazy var statusView = {
        
        return ToolsWays.createView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20), backgroundCollor: UIColor.white)
    }()
    var bgTaskId: UIBackgroundTaskIdentifier = 0
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        
        window?.backgroundColor = UIColor.white
        
        createRootViewController()
        
        window?.makeKeyAndVisible()
        
        createGuidePageView()
        
        MagicalRecord.setupCoreDataStack()
        
        bgTaskId = AppDelegate.backgroudPlayID(backTaskID: bgTaskId)
        
        return true
    }
    
    func createRootViewController() -> Void {
        
        let leftVC = MenuViewController()
        
        drawerVC = MMDrawerController(center: navViewLayoutConstraint(vc: SingleVCs.mainVC), leftDrawerViewController: leftVC)
        drawerVC?.view.backgroundColor = UIColor.white
        drawerVC?.maximumLeftDrawerWidth = 300
        drawerVC?.openDrawerGestureModeMask = .all
        drawerVC?.closeDrawerGestureModeMask = .all
        
        window?.rootViewController = drawerVC
    }
    
    class func backgroudPlayID(backTaskID: UIBackgroundTaskIdentifier) -> UIBackgroundTaskIdentifier {
        
        //支持后台播放
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        
        try! AVAudioSession.sharedInstance().setActive(true)
        
        let newTaskID: UIBackgroundTaskIdentifier!
        
        newTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        if newTaskID != UIBackgroundTaskInvalid && backTaskID != UIBackgroundTaskInvalid {
            
            UIApplication.shared.endBackgroundTask(backTaskID)
        }
        
        return newTaskID
    }
    
    func navViewLayoutConstraint(vc: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: vc)
        
        nav.view.addSubview(statusView)
        
        return nav
    }
    
    func createGuidePageView() -> Void {
        
        if UserDefaults.standard.object(forKey: "FirstStart") == nil {
            
            let image = [#imageLiteral(resourceName: "introPage1"), #imageLiteral(resourceName: "introPage2"), #imageLiteral(resourceName: "introPage3"), #imageLiteral(resourceName: "introPage4"), #imageLiteral(resourceName: "introPage5")]
            
            let guidePageView = GuidePageView.init(frame: UIScreen.main.bounds, imageArr: image)
            
            self.window?.addSubview(guidePageView)
            
            UserDefaults.standard.set(true, forKey: "FirstStart")
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        UIApplication.shared.endReceivingRemoteControlEvents()
        
        let imageView = UIImageView(frame: (self.window?.bounds)!)
        
        imageView.image = UIImage(named: String.init(format: "introPage%d", arc4random_uniform(5) + 1))
        
        self.window?.addSubview(imageView)
        
        UIView.animate(withDuration: 2, delay: 2, options: .layoutSubviews, animations: { 
            
            imageView.alpha = 0

            }) { (true) in
                
                imageView.removeFromSuperview()
        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        MagicalRecord.cleanUp()
    }


}

