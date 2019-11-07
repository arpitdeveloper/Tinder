//
//  NewAccountController.swift
//  Tinder
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import MaterialComponents
import Firebase
import FirebaseCore
import FirebaseFirestore
import TTSegmentedControl
import DBNumberedSlider
import CoreLocation

class NewAccountController: UIViewController {

    @IBOutlet var nameTF: MDCTextField!
    @IBOutlet var emailTF: MDCTextField!
    @IBOutlet var passwordTF: MDCTextField!
    @IBOutlet var createBTN: UIButton!
    @IBOutlet var sliderView: DBNumberedSlider!
    
    @IBOutlet var mfSeg: TTSegmentedControl!
    
    var mfStr = "Male"
    var db: Firestore!
    let locationManager = CLLocationManager()
    var clCord = CLLocationCoordinate2D()
    var currentLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locationManager.location
            
        }
        
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
       
        //Toggle Button......
        let arry = ["Male", "Female"] 
        mfSeg.itemTitles = arry
        mfSeg.didSelectItemWith = { (index, title) -> () in
            //print("Selected item \(index)....name.\(title ?? "")")
            if title == "Male"  {
                print("Male")
                self.mfStr = "Male"
            } else {
                print("female")
                self.mfStr = "Female"
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        clCord = locValue
        print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    // MARK: - Button Tapped

    @IBAction func createAccountTapped(_ sender: Any) {
        
        Design.startLoader()
        guard let email = emailTF.text, let password = passwordTF.text, let name = nameTF.text else {
            let alert = UIAlertController(title: "Alert", message: "Fill all the field", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if error != nil {
                Design.stopLoader()
                let msg = error?.localizedDescription
                let alert = UIAlertController(title: "Faild!", message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print(error?.localizedDescription as Any)
                return
            }
            else{
                guard let uid = authResult?.user.uid else{
                    return
                }
                let ref:DatabaseReference = Database.database().reference(fromURL: "https://tinder-45f6d.firebaseio.com/")
                let userRef = ref.child("users").child(uid)
                let values = ["name":name, "email":email, "gender":self.mfStr,"age":"20", "image":"image"]
                userRef.updateChildValues(values, withCompletionBlock: { (err, dataRef) in

                    
                    if err != nil {
                        Design.stopLoader()
                        print(err?.localizedDescription as Any)
                        return
                    }
                    else {
                        if self.mfStr == "Male"{
                            let ref2:DatabaseReference = Database.database().reference(fromURL: "https://tinder-45f6d.firebaseio.com/")
                            let userRef2 = ref2.child("location").child("male").child(uid)
                            let lat = "self.currentLocation.coordinate.latitude"
                            let lon = "self.currentLocation.coordinate.longitude"
                            let latStr = String(lat)
                            let lonStr = String(lon)
                            let values = ["lat":latStr, "lon":lonStr]
                            userRef2.updateChildValues(values, withCompletionBlock: { (err2, dataRef2) in
                                Design.stopLoader()
                                if err2 != nil {
                                    
                                    print(err2?.localizedDescription as Any)
                                    return
                                }
                                else {
                                    print("\(dataRef2.description())")
                                    self.db.collection("cities").document(uid).setData([  "name": name, "email": email, "gender": self.mfStr ], merge: true)
                                    
                                    self.showAlert()
                                }
                            })
                        }else {
                            let ref2:DatabaseReference = Database.database().reference(fromURL: "https://tinder-45f6d.firebaseio.com/")
                            let userRef2 = ref2.child("location").child("female").child(uid)
                            let lat = self.currentLocation.coordinate.latitude
                            let lon = self.currentLocation.coordinate.longitude
                            let latStr = String(lat)
                            let lonStr = String(lon)
                            let values = ["lat":latStr, "lon":lonStr, "age":"20"]
                            userRef2.updateChildValues(values, withCompletionBlock: { (err2, dataRef2) in
                                Design.stopLoader()
                                if err2 != nil {
                                    
                                    print(err2?.localizedDescription as Any)
                                    return
                                }
                                else {
                                    print("\(dataRef2.description())")
                                    self.db.collection("cities").document(uid).setData([  "name": name, "email": email, "gender": self.mfStr ], merge: true)
                                  self.showAlert()
                                }
                            })
                        }
                    }
                })
            }
        }
    }
    
    public func showAlert(){
        let alert = UIAlertController(title: "Success", message: "Successfully Signup", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in
            SwitchController.updateRootVC()
        }))
        
        self.present(alert, animated: true, completion: nil)

    }
}
