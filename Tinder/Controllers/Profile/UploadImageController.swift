//
//  UploadImageController.swift
//  Tinder
//
//  Created by Apple on 23/07/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import Firebase

class UploadImageController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var deviceBTN: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Navigation

    @IBAction func buttonTapped(_ sender: Any) {
   
        let pickImage = UIImagePickerController()
        pickImage.delegate = self
        pickImage.allowsEditing = true
        present(pickImage, animated: true) {
            print("ok")
        }
            
        
    }
    func uploadImage(fileurl: URL){
        Design.startLoader()
        let imageName = NSUUID().uuidString
        
        let storeRef = Storage.storage().reference().child("\((Auth.auth().currentUser?.uid)!)/\(imageName)")
        //let strUrl = URL(fileURLWithPath: fileurl)
        let imgData = NSData(contentsOf: fileurl as URL)
  
        storeRef.putData(imgData! as Data, metadata: nil) { (storData, err) in
            if err != nil{
                print(err as Any)
            }
            else{
                print(storData as Any)
                
                let downloadStor = Storage.storage().reference().child("\((Auth.auth().currentUser?.uid)!)/\(imageName)")
                downloadStor.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error as Any)
                    }
                    else{
                        Database.database().reference().child("users").observe(.childAdded, with: { (snapShot) in
                            print(snapShot)
                            Design.stopLoader()
                            if let dictionary = snapShot.value as? [String: AnyObject] {
                               print("\(dictionary)")
                                if Auth.auth().currentUser?.uid == snapShot.key{
                                   
                                    let utentiRef =  Database.database().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("image")
                                    utentiRef.updateChildValues([imageName:"\(url!)"])

                                }
                            }
                        }, withCancel: nil)
                    }
                })
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if #available(iOS 11.0, *) {
            if let orignalIMG = info[UIImagePickerController.InfoKey.imageURL]{
                print(orignalIMG)
                self.uploadImage(fileurl: orignalIMG as! URL)
                dismiss(animated: true, completion: nil)
            }
        } else {
            // Fallback on earlier versions
            
        }
        print("picker controller.....\(info)")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("did cancel")
        dismiss(animated: true, completion: nil)
    }
}
