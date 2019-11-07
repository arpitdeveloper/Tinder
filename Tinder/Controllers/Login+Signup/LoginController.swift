//
//  LoginController.swift
//  Tinder
//
//  Created by Apple on 05/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase


class LoginController: UIViewController {

    //-------------------------------------------------
    //IBOutlet
    
    
    @IBOutlet var mailView: UIView!
    
    @IBOutlet var emailBTN: UIButton!
    @IBOutlet var numberTF: MDCTextField!
    @IBOutlet var emailTF: MDCTextField!
    @IBOutlet var passwordTF: MDCTextField!
    
    @IBOutlet var codeBTN: UIButton!
    @IBOutlet var continueBTN: UIButton!
    @IBOutlet var sendmailBTN: UIButton!
    
    //-------------------------------------------------
    //Variable
    var isEmailViewOPenn:Bool = false
    //====================================================================
    // MARK: - Life Cycle Methods Start
    override func viewDidLoad() {
        super.viewDidLoad()
         
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        mailView.isHidden = true
        
        //-------------------------------------------------
        //Button function
        Design.roundButton(button: emailBTN)
        Design.roundButton(button: continueBTN)
        
        //-------------------------------------------------
        //navigation function
        
        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarStyle = .default
        
        let leftbtn = UIBarButtonItem(image: UIImage(named: "back-icon"), style: .plain, target: self, action:#selector(leftBtnAction))
        self.navigationItem.leftBarButtonItem  = leftbtn
              
    }
    
    // MARK: Life Cycle Methods End
    //====================================================================
 
    //====================================================================
    // MARK: - ALL Button Action Start

    @objc func leftBtnAction(){
        if isEmailViewOPenn {
            isEmailViewOPenn = false
            mailView.isHidden = true
        }
        else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func createAccountTapped(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "NewAccountController") as? NewAccountController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func codeAction(_ sender: Any) {
        
    }
    @IBAction func emailAction(_ sender: Any) {
       
        isEmailViewOPenn = true
        mailView.isHidden = false
    }
    @IBAction func continueAction(_ sender: Any) {
        
    }
    
    @IBAction func sendMailAction(_ sender: Any) {
        Design.startLoader()
        guard let email = emailTF.text, let password = passwordTF.text else {
            let alert = UIAlertController(title: "Alert", message: "Fill all the field", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (dataResult, err) in
            Design.stopLoader()
            if err != nil {
                print(err?.localizedDescription as Any)
            }
            else{
                print(dataResult?.user.uid as Any)
                let alert = UIAlertController(title: "Welocome", message: "Successfully Login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
                    
                    let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeController") as? HomeController
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                    
                }))
                
                self.present(alert, animated: true, completion: nil)
                
                
            }
        }
        
        
        
        
//        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "HomeController") as? HomeController
//        self.navigationController?.pushViewController(vc!, animated: true)
    }
    // MARK: ALL Button Action End
    //====================================================================
}
