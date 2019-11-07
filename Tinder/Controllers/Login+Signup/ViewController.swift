//
//  ViewController.swift
//  Tinder
//
//  Created by Apple on 05/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit

import FirebaseCore
import FirebaseFirestore
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController {

    //-------------------------------------------------
    //IBOutlet
    
    @IBOutlet var btnNumber: UIButton!
    
    @IBOutlet var btnFaceBook: UIButton!
    @IBOutlet var lblTerm: UILabel!
    
    @IBOutlet var backView: UIView!
    
    //-------------------------------------------------
    //Variable
    var defaults = UserDefaults()
    var db: Firestore!
 
    //====================================================================
    // MARK: - Life Cycle Methods Start
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIApplication.shared.statusBarStyle = .lightContent
        //-------------------------------------------------
        //call design methods
        Design.backImage(firstview: view)
        
        Design.roundButton(button: btnFaceBook)
        Design.roundButton(button: btnNumber)
        Design.borderButton(button: btnNumber)
        
        //-------------------------------------------------
        //navigation function
        self.navigationController?.navigationBar.isHidden = true
        
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
       
        
        var ref: DocumentReference? = nil
        
        ref = db.collection("Profile").addDocument(data: [
            "first": "Ada",
            "last": "jhhjgjhhjhhj",
            "born": "1815"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.description)")
            }
        }
        db.collection("cities").document("LA").setData([
            "name": "Los jhgjhyjhy",
            "state": "CA",
            "country": "USA"
        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }         
        }
        db.collection("cities").document("LA").setData([ "capital": true ], merge: true)
        
    }
    
    // MARK: Life Cycle Methods End
    //====================================================================

    //====================================================================
    // MARK: - ALL Button Action Start
    @IBAction func facebookAction(_ sender: Any) {
        
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    print("lgoin successs..\(fbloginresult.token as Any)")
                    self.getFBUserData()
                }
            }
        }
        print("Ok facebook")
    }
    func getFBUserData(){
        if((AccessToken.current) != nil){
        
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){

                    //everything works print the user data
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    Auth.auth().signIn(with: credential) { (authResult, error) in
                        if error != nil {
                            // ...
                            return
                        }
                        else{
                            print("frirebase login success..\(String(describing: authResult?.description))")
                            let no = CreateAccountFirebase()
                            no.AddDataFireabse(email: "email", name: "name", gender: "male", age: "2", controller: self.navigationController!)
                            SwitchController.updateRootVC()
                        }

                    }
                    print("result....\(result!)")
                }
                else{
                    print("erroro,,,,,,,\(String(describing: error))")
                }
            })
        }
    }
    @IBAction func numberAction(_ sender: Any) {
        defaults.set(true, forKey: "isLogin")
        //SwitchController.updateRootVC()
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginController") as? LoginController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    // MARK: ALL Button Action End
    //====================================================================
    
    public func showAlert(){
        let alert = UIAlertController(title: "Success", message: "Successfully Signup", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            SwitchController.updateRootVC()
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
}

