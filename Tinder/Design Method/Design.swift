//
//  Design.swift
//  Tinder
//
//  Created by Apple on 05/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import IHProgressHUD

class Design: UIViewController {
    
    //=====================================================
    // MARK: - View Design
    public static func backImage(firstview:UIView){
        
        let bgImageView = UIImageView()
        bgImageView.frame = firstview.bounds
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.image = UIImage(named: "home")
        firstview.insertSubview(bgImageView, at: 0)
        firstview.addSubview(bgImageView)
        firstview.sendSubviewToBack(bgImageView)
        
    }
    
    public static func chatBackImage(firstview: UIView){
        
        let bgImageView = UIImageView()
        bgImageView.frame = firstview.bounds
        bgImageView.contentMode = .center
        bgImageView.image = UIImage(named: "chat-back")
        firstview.insertSubview(bgImageView, at: 0)
        firstview.addSubview(bgImageView)
        firstview.sendSubviewToBack(bgImageView)
        
    }
    //=====================================================
    // MARK: - Button Design
    
    public static func roundButton(button: UIButton){
        
        button.layer.cornerRadius = button.bounds.size.height/2
    }
    
    public static func borderButton(button: UIButton){
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
    }
    public static func singleButtonShadow(button: TinderButton){
        button.layer.cornerRadius = button.bounds.size.height/2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
    }
    public static func shadowRoundBTN(button: UIButton, button1: UIButton, button2: UIButton, button3: UIButton, button4: UIButton){
        
        button.layer.cornerRadius = button.bounds.size.height/2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
        
        button1.layer.cornerRadius = button1.bounds.size.height/2
        button1.layer.shadowColor = UIColor.black.cgColor
        button1.layer.shadowOffset = CGSize.zero
        button1.layer.shadowRadius = 5
        button1.layer.shadowOpacity = 1.0
        
        button2.layer.cornerRadius = button2.bounds.size.height/2
        button2.layer.shadowColor = UIColor.black.cgColor
        button2.layer.shadowOffset = CGSize.zero
        button2.layer.shadowRadius = 5
        button2.layer.shadowOpacity = 1.0
        
        button3.layer.cornerRadius = button3.bounds.size.height/2
        button3.layer.shadowColor = UIColor.black.cgColor
        button3.layer.shadowOffset = CGSize.zero
        button3.layer.shadowRadius = 5
        button3.layer.shadowOpacity = 1.0
        
        button4.layer.cornerRadius = button4.bounds.size.height/2
        button4.layer.shadowColor = UIColor.black.cgColor
        button4.layer.shadowOffset = CGSize.zero
        button4.layer.shadowRadius = 5
        button4.layer.shadowOpacity = 1.0
    }
    public static func btnCorner(button: UIButton){
        button.layer.cornerRadius = button.bounds.size.height/2
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize.zero
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 1.0
    }
    //=====================================================
    // MARK: - Activity Indictor
    public static func startLoader(){
        IHProgressHUD.show()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    public static func stopLoader(){
        IHProgressHUD.dismiss()
        UIApplication.shared.endIgnoringInteractionEvents()
        
    }
    
    public static func showDate(epochTime:NSNumber)->String{
        
        let timeResult:NSNumber = epochTime
        let date = NSDate(timeIntervalSince1970: TimeInterval(truncating: timeResult))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        dateFormatter.dateFormat = "hh:mm a"
        let localDate = dateFormatter.string(from: date as Date)
        
        return "\(localDate)"
        
    }
    
        
}
