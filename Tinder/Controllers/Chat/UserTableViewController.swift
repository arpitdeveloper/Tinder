//
//  UserTableViewController.swift
//  Tinder
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import Firebase

class UserTableViewController: UITableViewController {
    //-------------------------------------------------
    //IBOutlet
    
    //-------------------------------------------------
    //Variable
    var user = [UserInfo]()
    //====================================================================
    // MARK: - Life Cycle Methods Start
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ContactViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.getUser()
    }
    override func viewWillAppear(_ animated: Bool) {
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
        var image = UIImage(named: "user-gray")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(leftNAVBTNTapped))
        
        //Right Button
        var image0 = UIImage(named: "chat-red")
        image0 = image0?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image0, style:.plain, target: self, action: #selector(rightNAVBtnTapped))
    }
    
    // MARK: Life Cycle Methods End
    //====================================================================
    
    @objc func rightNAVBtnTapped(){
        
    }
    @objc func leftNAVBTNTapped(){
        
        let firstController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        self.navigationController?.pushViewController(firstController, animated: false)
    }
   
    @objc func clickOnButton() {
        let firstController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeController
        self.navigationController?.pushViewController(firstController, animated: false)
    }
    
    func getUser() {
        Design.startLoader()
        Database.database().reference().child("users").observe(.childAdded, with: { (snapShot) in
            print(snapShot)
            Design.stopLoader()
            if let dictionary = snapShot.value as? [String: AnyObject] {
                let UserIn = UserInfo()
                
                if Auth.auth().currentUser?.uid != snapShot.key{
                    UserIn.id = snapShot.key
                    UserIn.email = dictionary["email"] as? String
                    UserIn.name = dictionary["name"] as? String
                    //UserIn.setValuesForKeys(dictionary)
                    //UserIn.setValuesForKeys(dictionary)
                    self.user.append(UserIn)
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("\(UserIn.email ?? ""), \(UserIn.name ?? "") , \(UserIn.id ?? "")")
                }
                
            }
        }, withCancel: nil)
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return user.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactViewCell
        if user.count != 0{
            cell.nameLBL.text = user[indexPath.row].name
            cell.emailLBL.text = user[indexPath.row].email
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController
        vc?.users = user[indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }

}
