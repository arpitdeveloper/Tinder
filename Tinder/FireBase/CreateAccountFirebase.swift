//
//  CreateAccountFirebase.swift
//  Tinder
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//
import Firebase
import FirebaseFirestore
import Foundation
import CoreLocation
import UIKit

private var db: Firestore!
private let locationManager = CLLocationManager()
private var clCord = CLLocationCoordinate2D()
private var currentLocation: CLLocation!
class CreateAccountFirebase{
   
    public func AddDataFireabse(email: String, name: String, gender: String, age: String, controller: UINavigationController){
        self.addData(email: email, name: name, gender: gender, age: age, controller: controller)
    }
    private func addData(email: String, name: String, gender: String, age: String, controller: UINavigationController){
        
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
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
            guard let uid = Auth.auth().currentUser?.uid else{
                return
            }
            let ref:DatabaseReference = Database.database().reference(fromURL: "https://tinder-45f6d.firebaseio.com/")
            let userRef = ref.child("users").child(uid)
            let values = ["name":name, "email":email, "gender":gender,"age":age]
            userRef.updateChildValues(values, withCompletionBlock: { (err, dataRef) in
                
                
                if err != nil {
                    Design.stopLoader()
                    print(err?.localizedDescription as Any)
                    return
                }
                else {
                    if gender == "Male"{
                        let ref2:DatabaseReference = Database.database().reference(fromURL: "https://tinder-45f6d.firebaseio.com/")
                        let userRef2 = ref2.child("location").child("male").child(uid)
                        let lat = currentLocation.coordinate.latitude
                        let lon = currentLocation.coordinate.longitude
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
                                db.collection("cities").document(uid).setData([  "name": name, "email": email, "gender": gender, "age":age ], merge: true)
                                
                                let no = ViewController()
                                no.showAlert()
                            }
                        })
                    }else {
                        let ref2:DatabaseReference = Database.database().reference(fromURL: "https://tinder-45f6d.firebaseio.com/")
                        let userRef2 = ref2.child("location").child("female").child(uid)
                        let lat = currentLocation.coordinate.latitude
                        let lon = currentLocation.coordinate.longitude
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
                           
                                let no = ViewController()
                                no.showAlert()
                            }
                        })
                    }
                }
            })
        
    }
}
