
//  Copyright © 2018 Jon. All rights reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UISplitViewControllerDelegate {

    var window: UIWindow?
    var locationData = [CityLocation]()
    var fetchInProgress: Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        return true
    }

    func fecthLocationData() {
        // On inital launch we want to start retreiving data right away
        if locationData.isEmpty && !fetchInProgress {
            DispatchQueue.global(qos:.userInteractive).async {
                SessionManager.shared.dataManager.executeTask(completion: { [weak self] (data, status, fetchError) in
                    guard let strongSelf = self, let locationData = data, fetchError == nil else {
                        self?.showErrorAlert()
                        return
                    }
                    strongSelf.locationData = locationData
                    self?.fetchInProgress = false
                })
            }
        }
    }

    func showErrorAlert() {
        let alertController = UIAlertController(
            title: "It looks like we got something wrong. Please contact us for assistance.",
            message: nil,
            preferredStyle: .alert
        )
        window?.rootViewController?.present(alertController, animated: true)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

