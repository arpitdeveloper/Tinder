//
//  ProfileController.swift
//  Tinder
//
//  Created by Apple on 17/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import Firebase

class ProfileController: UIViewController {
    
    //-------------------------------------------------
    //IBOutlet
    @IBOutlet var userIV: UIImageView!
    @IBOutlet var imgBackView: UIView!
    @IBOutlet var settingBTN: UIButton!
    @IBOutlet var mediaBTN: UIButton!
    @IBOutlet var infoBTN: UIButton!
    
    //-------------------------------------------------
    //Variable
    
    //====================================================================
    // MARK: - Life Cycle Methods Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //-------------------------------------------------
        //Button Design
        Design.roundButton(button: settingBTN)
        Design.roundButton(button: mediaBTN)
        Design.roundButton(button: infoBTN)
        
        //self.imgBackView.layer.cornerRadius = self.imgBackView.bounds.width/2
       
        //-------------------------------------------------
        //Navigation Button
        let button =  UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 50, height: 40)
        var image1 = UIImage(named: "tinder-gray")
        image1 = image1?.withRenderingMode(.alwaysOriginal)
        button.setImage(image1, for: .normal)
        button.addTarget(self, action: #selector(clickOnButton), for: .touchUpInside)
        button.tintColor = .black
        button.titleLabel?.textColor = .black
        navigationItem.titleView = button
        
        //Lest button
        var image = UIImage(named: "user-red")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(leftNAVBTNTapped))
        
        //Right Button
        var image0 = UIImage(named: "chat-gray")
        image0 = image0?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image0, style:.plain, target: self, action: #selector(rightNAVBtnTapped))
        
    }
    
    // MARK: Life Cycle Methods End
    //====================================================================
    
    //====================================================================
    // MARK: - ALL Button Action Start
    @objc func rightNAVBtnTapped(){
        let firstController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTableViewController") as! UserTableViewController
        self.navigationController?.pushViewController(firstController, animated: true)
    }
    @objc func leftNAVBTNTapped(){
        
    }
    @objc func clickOnButton() {
        let firstController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.navigationController?.pushViewController(firstController, animated: true)
    }
    
    @IBAction func settingTapped(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }catch let logoutErr {
            print(logoutErr)
        }
        SwitchController.updateRootVC()
    }
    @IBAction func mediaTapped(_ sender: Any) {
        let firstController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "UploadImageController") as! UploadImageController
        self.navigationController?.pushViewController(firstController, animated: false)
        print("add photo")
        
    }
    
    @IBAction func infoTapped(_ sender: Any) {
        let firstController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditInfoViewController")  as! EditInfoViewController
        self.navigationController?.pushViewController(firstController, animated: true)
    }
    // MARK: ALL Button Action End
    //====================================================================
    
}
