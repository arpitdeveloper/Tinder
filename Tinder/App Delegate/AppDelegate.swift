//
//  AppDelegate.swift
//  Tinder
//
//  Created by Apple on 05/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import FirebaseFirestore
import FBSDKCoreKit
//https://tinder-45f6d.firebaseapp.com/__/auth/handler

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let locationManager = CLLocationManager()
    var clCord = CLLocationCoordinate2D()
    var currentLocation: CLLocation!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        let db = Firestore.firestore()

        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        // [END default_firestore]
        print(db) // silence warning
        SwitchController.updateRootVC()
        
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handled = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        // Add any custom logic here.
        return handled;
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
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locationManager.location
            
            print(".................\(currentLocation.coordinate.longitude)")
        }
        if Auth.auth().currentUser?.uid != nil {
            let ref2:DatabaseReference = Database.database().reference(fromURL: "https://tinder-45f6d.firebaseio.com/")
            let userRef2 = ref2.child("location").child((Auth.auth().currentUser?.uid)!)
            let lat = self.currentLocation.coordinate.latitude
            let lon = self.currentLocation.coordinate.longitude
            let latStr = String(lat)
            let lonStr = String(lon)
            let values = ["lat":latStr, "lon":lonStr]
            userRef2.updateChildValues(values, withCompletionBlock: { (err2, dataRef2) in
                Design.stopLoader()
                if err2 != nil {
                    
                    print(err2?.localizedDescription as Any)
                    return
                }
                else {}
            })
        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

