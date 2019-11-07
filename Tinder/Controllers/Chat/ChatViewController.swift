//
//  ChatViewController.swift
//  Tinder
//
//  Created by Apple on 19/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import Firebase
class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet var sendBTN: UIButton!
    @IBOutlet var messageVIew: UIView!
    @IBOutlet var messageTF: UITextField!
    @IBOutlet var chatTBL: UITableView!

    @IBOutlet var chatScroll: UIScrollView!
    @IBOutlet var bottomConstant2: NSLayoutConstraint!
    @IBOutlet var bottm: NSLayoutConstraint!
    
    var msg = [Message]()
    var msgDict = [String: Message]()
    var users:UserInfo? {
        didSet {
            navigationItem.title = users?.name
        }
    }
    //====================================================================
    // MARK: - Life Cycle Methods Start
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getMessages()
        Design.chatBackImage(firstview: chatScroll)
        chatTBL.register(UINib(nibName: "BubbleViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //----------------------------------------
        //Keyboard Notification
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        bottm.constant = 0
        bottomConstant2.constant = 0
    
    }
    // MARK: Life Cycle Methods end
    //=======================================================================
    
    func getMessages(){
        let ref:DatabaseReference = Database.database().reference().child("message")
        ref.observe(.childAdded, with: { (snapShot) in
            let toldID = self.users!.id!
            let fromID = Auth.auth().currentUser!.uid
            
            let ref2:DatabaseReference = Database.database().reference().child("user-All-Message").child(fromID).child(toldID)
             ref2.observe(.childAdded, with: { (snapShot1) in
                
                    if let dictionary = snapShot.value as? [String: AnyObject] {
                        let message = Message()
                        
                        //self.msg.removeAll()
                        if snapShot.key == snapShot1.key {
                            message.keyID = snapShot.key
                            message.text = dictionary["text"] as? String
                            message.fromID = dictionary["fromID"] as? String
                            message.toldID = dictionary["toldID"] as? String
                            message.timestamp = dictionary["timestamp"] as? NSNumber
                            //message.setValuesForKeys(dictionary)
                            self.msg.append(message)
                            
                            self.msgDict[snapShot1.key] = message
                            DispatchQueue.main.async {
                                self.chatTBL.reloadData()
                                //self.scrollToBottom()
                                self.chatTBL.scrollToBottom()
                            }
                        }
              
                    }
                 }, withCancel: nil)
   
        }, withCancel: nil)
        DispatchQueue.main.async {
            self.chatTBL.scrollToBottom()
        }
 
    }

    //=======================================================================
    // MARK: - All Button Tapped Start

    @IBAction func sendTapped(_ sender: Any) {
        let ref:DatabaseReference = Database.database().reference().child("message")
        let childRef = ref.childByAutoId()
        let toldID = users!.id!
        let fromID = Auth.auth().currentUser!.uid
        let timestam = NSDate().timeIntervalSince1970 as NSNumber
        let meg = messageTF.text
        if meg != ""{
            print("message emty")
       
            let values = ["text": messageTF.text!, "toldID": toldID, "fromID":fromID, "timestamp": Int(truncating: timestam)] as [String : Any]
            //childRef.updateChildValues(values)
            childRef.updateChildValues(values) { (erro, ref2) in
                if erro != nil {
                    print(erro as Any)
                    return
                }
                else{
                    let userMessage:DatabaseReference = Database.database().reference().child("user-All-Message").child(fromID).child(toldID)
                    let messageId:String = childRef.key!
                    userMessage.updateChildValues([messageId: 1]) { (erro0, ref3) in
                        if erro0 != nil {
                            print(erro0 as Any)
                            return
                        }
                        else{
                            let userMessage0:DatabaseReference = Database.database().reference().child("user-All-Message").child(toldID).child(fromID)
                            let messageId0:String = childRef.key!
                            
                            userMessage0.updateChildValues([messageId0: 1])
                        }
                    }
                    //userMessage.updateChildValues([messageId: 1])
                }
            }
        }
        DispatchQueue.main.async {
            self.chatTBL.scrollToBottom()
        }
        print("Message dict\n\(msgDict)")
       // self.scrollToBottom()
        messageTF.text = ""
    }
    // MARK: All Button Tapped end
    //=======================================================================
    
    //=======================================================================
    // MARK: - KeyBoard Methods start
    @objc func keyboardWillShow(notification:NSNotification) {
        self.adjustingHeight(show: true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.adjustingHeight(show: false, notification: notification)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        chatTBL.endEditing(true)
    }
    func adjustingHeight(show:Bool, notification:NSNotification) {
        // 1
        var userInfo = notification.userInfo!
        // 2
        let keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        // 3
        let animationDurarion = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        // 4
        let changeInHeight = (keyboardFrame.height) * (show ? 1 : -1)
        
        UIScrollView.animate(withDuration: animationDurarion, animations: {
            self.bottm.constant += changeInHeight
            self.bottomConstant2.constant += changeInHeight
        })

    }
    // MARK: KeyBoard Methods end
    //=======================================================================
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msg.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BubbleViewCell
        if msg.count != 0{
            if msg[indexPath.row].fromID == Auth.auth().currentUser!.uid{
                cell.senderIV.isHidden = true
                cell.senderView.isHidden = true
                cell.userIV.isHidden = false
                cell.reciverView.isHidden = false
                cell.layer.backgroundColor = UIColor.clear.cgColor
                
                cell.userIV.layer.cornerRadius = 15
                cell.textLBL.text = msg[indexPath.row].text
                cell.time2LBL.text = Design.showDate(epochTime: msg[indexPath.row].timestamp!)
                
                cell.reciverView.layer.cornerRadius = 5
                return cell
            }
            else if msg[indexPath.row].fromID == users?.id{
                cell.senderIV.isHidden = false
                cell.senderView.isHidden = false
                cell.userIV.isHidden = true
                cell.reciverView.isHidden = true
                cell.layer.backgroundColor = UIColor.clear.cgColor
                
                cell.senderIV.layer.cornerRadius = 15
                cell.messageLBL.text = msg[indexPath.row].text
                cell.timeLBL.text = Design.showDate(epochTime: msg[indexPath.row].timestamp!)
                cell.senderView.layer.cornerRadius = 5
                return cell
            }
            else {
                cell.senderIV.isHidden = true
                cell.senderView.isHidden = true
                cell.userIV.isHidden = true
                cell.layer.backgroundColor = UIColor.clear.cgColor
                
                cell.reciverView.isHidden = true
                let cell2 = UITableViewCell()
                return cell2
            }
        }
        else{
            let cell2 = UITableViewCell()
            return cell2
        }
        
    }
}

extension UITableView {
    func scrollToBottom() {
        
        let lastSectionIndex = self.numberOfSections - 1
        if lastSectionIndex < 0 { //if invalid section
            return
        }
        
        let lastRowIndex = self.numberOfRows(inSection: lastSectionIndex) - 1
        if lastRowIndex < 0 { //if invalid row
            return
        }
        
        let pathToLastRow = IndexPath(row: lastRowIndex, section: lastSectionIndex)
        self.scrollToRow(at: pathToLastRow, at: .bottom, animated: false)
    }
}
