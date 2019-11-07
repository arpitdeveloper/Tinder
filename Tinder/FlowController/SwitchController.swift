//
//  SwitchController.swift
//  LotNavigator
//
//  Created by Apple on 01/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import Firebase

class SwitchController {

    static func updateRootVC(){
        
        //let status = UserDefaults.standard.bool(forKey: "isLogin")
        //var rootVC : UIViewController?
        let navigationController = UINavigationController()
        let appStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        //print(status)
        let uid = Auth.auth().currentUser?.uid
        
        if uid != nil {
            let firstController: UIViewController = appStoryBoard.instantiateViewController(withIdentifier: "HomeController") as! HomeController
            navigationController.viewControllers = [firstController]
        } else {
            let firstController: UIViewController = appStoryBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            navigationController.viewControllers = [firstController]
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = navigationController
        appDelegate.window?.makeKeyAndVisible()
        
    }

}
