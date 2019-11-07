//
//  HomeController.swift
//  Tinder
//
//  Created by Apple on 06/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import UIKit
import Firebase
//import PopBounceButton

class HomeController: UIViewController, ButtonStackViewDelegate, ARKGalleryViewDelegate {
   
    //-------------------------------------------------
    //IBOutlet
    
    @IBOutlet var swapVIew: UIView!
    
    @IBOutlet var reloadBTN: UIButton!
    @IBOutlet var crossBTN: UIButton!
    @IBOutlet var starBTN: UIButton!
    @IBOutlet var heartBTN: UIButton!
    @IBOutlet var lightBTN: UIButton!
    
 
    @IBOutlet var buttonSTView: ButtonStackView!
    //-------------------------------------------------
    //Variable
 
   // let kCardNib = UINib(nibName: "View", bundle: nil)
    
    private let stackView = ButtonStackView()
    
    //Test
    var dataArray = [Int]()
    var imageArray = [String]()
    
    var defaults = UserDefaults.standard
    var isRun: Bool = true
    var cards = [ImageCard] ()
    var imgCard = ImageCard()
    let gallery: ImageCard = ImageCard()
    let cardAttributes: [(downscale: CGFloat, alpha: CGFloat)] = [(1,1),(0.92,0.8),(0.84,0.6),(0.76,0.4)]
    let cardInterItemSpacing: CGFloat = 15
    var dynamicAnimator: UIDynamicAnimator!
    var cardAttachmentBehavior: UIAttachmentBehavior!
    var cardIsHiding = false
    var user = [GetUser]()
    var isCalled = true
    var userKeyArray = [String]()
    var userDict = [String:Any]()
    //====================================================================
    // MARK: - Life Cycle Methods Start
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageArray = ["01","02","03","04","05","06","07","08"]
        buttonSTView.delegate = self
        setupStackView()
        
        self.gallery.delegate = self
        self.getUser()
       
        dynamicAnimator = UIDynamicAnimator (referenceView: self.view)
        // 1. setup screen

        
    }
    private func setupStackView() {
        view.addSubview(buttonSTView)
        if #available(iOS 11.0, *) {
            buttonSTView.anchor(top: nil, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingLeft: 24, paddingBottom: 12, paddingRight: 24)
        } else {
            // Fallback on earlier versions
        }
    }
    override func viewWillAppear(_ animated: Bool) {

        //-------------------------------------------------
        //navigation function
        self.navigatFunction()

    }
    override func viewDidAppear(_ animated: Bool) {
        //navigation function
        self.navigationController?.navigationBar.isHidden = false
    }
    // MARK: Life Cycle Methods End
    //====================================================================

    func getUser() {
        Design.startLoader()
        Database.database().reference().child("users").observe(.childAdded, with: { (snapShot) in
            Design.stopLoader()

            if let dictionary = snapShot.value as? [String: AnyObject] {

                if Auth.auth().currentUser?.uid != snapShot.key{
                    let didc = snapShot.key as String
                    self.userDict[didc] = dictionary
                    self.userKeyArray.append(didc)
    
                    DispatchQueue.main.async {
                        if self.isCalled == true{
                            self.isCalled = false
                            self.getCards()
                        }
                    }
                }
            }
        }, withCancel: nil)
        
    }
    func getCards(){
        for i in 0...self.userDict.count-1{
            
            let card = ImageCard(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 20, height: self.view.frame.height * 0.7))
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            card.infoImg.addGestureRecognizer(tap)
            card.tag = i
            card.infoImg.isUserInteractionEnabled = true
            card.infoImg.tag = i
            card.isUserInteractionEnabled = true
            
            let userIndex = userKeyArray[i] as String
            let userData = userDict[userIndex] as! [String: AnyObject]

            let img = userData["image"]
            let slide1 = ARKSlide()
            if (img as? [String:AnyObject]) != nil {
                
                let im = img?.allKeys as! Array<String>
                
                let imgData = userData["image"] as! [String: AnyObject]
                var imgArr = [ARKSlide]()
                
                for j in 0...im.count-1{
                    let imgKey = im[j]
                    let imgUrl = imgData[imgKey]
                    let url = URL(string: imgUrl as! String)
                    let data = try? Data(contentsOf: url!)
                    
                    if let imageData = data {
                        slide1.title = userData["name"] as? String
                        slide1.subtitle = "Enjoying the crystal clear water"
                        slide1.image = UIImage(data: imageData)
                        
                        imgArr.append(slide1)
                    }
                    
                }
                let model = ARKGalleryViewModel()
                model.slides = imgArr
                card.model = model
                
                self.cards.append(card)
                imgArr.removeAll()
                
            } else{
                slide1.title = userData["name"] as? String
                slide1.subtitle = "Enjoying the crystal clear water"
                slide1.image = UIImage(named: "user")
                
                let model = ARKGalleryViewModel()
                model.slides = [slide1]
                card.model = model
                
                self.cards.append(card)
                
            }

            
            
            
            
          
            
//            let slide2 = ARKSlide()
//            slide2.title = "Mountain"
//            slide2.subtitle = "female"
//            slide2.image = UIImage(named: "b2")
//
//            let slide3 = ARKSlide()
//            slide3.title = "Forest"
//            slide3.subtitle = "male"
//            slide3.image = UIImage(named: "b1")
//
//            let model = ARKGalleryViewModel()
//            model.slides = [slide1, slide2, slide3]
//            card.model = model
//
//            self.cards.append(card)
            
        }
        
        // show first 4 cards
        self.layoutCards()
    }
    //====================================================================
    // MARK: - ALL Button Action Start
    func didTapButton(_ button: TinderButton) {
        switch button.tag {
        case 1:
            print("Undo")
        case 2:
            print("Pass")
        case 3:
            print("Super like")
        case 4:
            print("Like")
        case 5:
            print("Boost")
        default:
            break
        }
    }
    @objc func leftNAVBTNTapped() {
        let firstController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        self.navigationController?.pushViewController(firstController, animated: false)
    }
    
    @objc func rightNAVBtnTapped() {
        let firstController: UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "UserTableViewController") as! UserTableViewController
        self.navigationController?.pushViewController(firstController, animated: true)
    }
    // MARK: ALL Button Action End
    //====================================================================
    
    func navigatFunction() {
        UIApplication.shared.statusBarStyle = .default
        self.navigationController?.navigationBar.isHidden = false
        
        var image = UIImage(named: "user-gray")
        image = image?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target: self, action: #selector(leftNAVBTNTapped))
        
        var image0 = UIImage(named: "chat-gray")
        image0 = image0?.withRenderingMode(.alwaysOriginal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image0, style:.plain, target: self, action: #selector(rightNAVBtnTapped))
        
    }

}
//MARK:- Delegate and DataSource
extension HomeController
{

    //scale and alpha of successive cards visible to the user
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("number of index...\(sender.view?.tag ?? 12)")
       
    }
    func layoutCards()
    {
        let firstCard = cards[0]
        self.view.addSubview(firstCard)
        firstCard.layer.zPosition = CGFloat(cards.count)
        firstCard.center = self.view.center
        let tapGesture = UIPanGestureRecognizer(target: self, action: #selector(handleCardPan))
        
        firstCard.addGestureRecognizer(tapGesture)
        
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            
            let card = cards[i]
            
            card.layer.zPosition = CGFloat(cards.count - i)
            
            let downscale = cardAttributes[i].downscale
            let alpha = cardAttributes[i].alpha
            card.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            card.alpha = alpha
            
            
            card.center.x = self.view.center.x
            card.frame.origin.y = cards[0].frame.origin.y + (CGFloat(i)*cardInterItemSpacing)
            
            if i == 3 {
                card.frame.origin.y += 1.5
                //print("here i == 3")
            }
            self.view.addSubview(card)
        }
        self.view.bringSubviewToFront(cards[0])
    }
    
    
    
    
    func showNextCard() {
        let animationDuration: TimeInterval = 0.2
        
        for i in 1...3 {
            if i > (cards.count - 1) { continue }
            let card = cards[i]
            let newDownscale = cardAttributes[i-1].downscale
            let newAlpha = cardAttributes[i-1].alpha
            //print("pirnt new down scale\(newDownscale)")
            UIView.animate(withDuration: animationDuration, delay: (TimeInterval(i-1)*(animationDuration/2)), options: [], animations: {
                card.transform = CGAffineTransform(scaleX: newDownscale, y: newDownscale)
                card.alpha = newAlpha
                
                if i == 1 {
                    card.center = self.view.center
                }
                else{
                    card.center.x = self.view.center.x
                    card.frame.origin.y = self.cards[1].frame.origin.y + (CGFloat(i-1) * self.cardInterItemSpacing)
                }
                
            }, completion: {(_) in
                if i == 1 {
                    
                    card.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan)))
                }
            })
        }
        
        
        //add new card to the back of deck
        if 4 > (cards.count - 1) {
            if cards.count != 1 {
                self.view.bringSubviewToFront(cards[1])
            }
            return
        }
        let newCard = cards[4]
        newCard.layer.zPosition = CGFloat(cards.count - 4)
        let downscale = cardAttributes[3].downscale
        let alpha = cardAttributes[3].alpha
        
        
        //new card start
        newCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        newCard.alpha = 0
        newCard.center.x = self.view.center.x
        newCard.frame.origin.y = cards[1].frame.origin.y + (4*cardInterItemSpacing)+30
        self.view.addSubview(newCard)
        
        //new card end animate
        UIView.animate(withDuration: animationDuration, delay: (3*(animationDuration/2)), options: [], animations: {
            newCard.transform = CGAffineTransform(scaleX: downscale, y: downscale)
            newCard.alpha = alpha
            newCard.center.x = self.view.center.x
            newCard.frame.origin.y = self.cards[1].frame.origin.y + (3*self.cardInterItemSpacing) + 1.5
        }, completion: {
            (_) in
        })
        self.view.bringSubviewToFront(self.cards[1])
    }
    
    func removOldFrontCard(){
        cards[0].removeFromSuperview()
        cards.remove(at: 0)
    }
    
    
    
    @objc func handleCardPan(sender: UIPanGestureRecognizer) {
        
        
        if cardIsHiding {
            return
        }
        
        let optionLength: CGFloat = 60
        
        let requiredOffsetFromCenter: CGFloat = 15
        
        let panLocationInView = sender.location(in: view)
        let panLocationInCard = sender.location(in: cards[0])
        
        
        
        switch sender.state {
        case .began:
            dynamicAnimator.removeAllBehaviors()
            let offset = UIOffset(horizontal: panLocationInCard.x + cards[0].bounds.midX, vertical: panLocationInCard.y + cards[0].bounds.midY);
            // card is attached to center
            cardAttachmentBehavior = UIAttachmentBehavior(item: cards[0], offsetFromCenter: offset, attachedToAnchor: panLocationInView)
            dynamicAnimator.addBehavior(cardAttachmentBehavior)
            
        case .changed:
            cardAttachmentBehavior.anchorPoint = panLocationInView
            if cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter){
                if cards[0].center.y < (self.view.center.y - optionLength){
                    cards[0].showOptionLabel(option: .like1)
                    
                }
                else if cards[0].center.y > (self.view.center.y + optionLength)
                {
                    cards[0].showOptionLabel(option: .like3)
                }
                else{
                    cards[0].showOptionLabel(option: .like2)
                }
            } else if cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter) {
                if cards[0].center.y < (self.view.center.y - optionLength) {
                    cards[0].showOptionLabel(option: .dislike1)
                } else if cards[0].center.y > (self.view.center.y + optionLength) {
                    cards[0].showOptionLabel(option: .dislike3)
                } else {
                    cards[0].showOptionLabel(option: .dislike2)
                }
            } else {
                cards[0].hideOptionLabel()
            }
        case .ended:
            dynamicAnimator.removeAllBehaviors()
            print("number of index...\(sender.view?.tag ?? 12)")
            if sender.view?.tag == user.count - 1 {
                isCalled = true
            }
            if !(cards[0].center.x > (self.view.center.x + requiredOffsetFromCenter) || cards[0].center.x < (self.view.center.x - requiredOffsetFromCenter)) {
                let snapBehavior  = UISnapBehavior(item: cards[0], snapTo: self.view.center)
                dynamicAnimator.addBehavior(snapBehavior)
            }else {
                let velocity = sender.velocity(in: self.view)
                let pushBehavior = UIPushBehavior(items: [cards[0]], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x/10, dy: velocity.y/10)
                pushBehavior.magnitude = 175
                dynamicAnimator.addBehavior(pushBehavior)
                
                
                //spin
                
                var angular = CGFloat.pi / 2
                let currentAngle : Double = atan2(Double(cards[0].transform.b), Double(cards[0].transform.a))
                
                if currentAngle > 0 {
                    angular = angular * 1
                } else {
                    angular = angular * -1
                }
                let itemBehavior = UIDynamicItemBehavior(items: [cards[0]])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angular), for: cards[0])
                dynamicAnimator.addBehavior(itemBehavior)
                
                showNextCard()
                hideFrontCard()
                
            }
            
        default:
            break
        }
    }
    
    
    func hideFrontCard() {
        if #available(iOS 10.0, *) {
            var cardRemoverTimer: Timer? = nil
            cardRemoverTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {
                [weak self] (_) in
                //gaurd self !=nil else {return}
                if !(self!.view.bounds.contains(self!.cards[0].center)){
                    cardRemoverTimer!.invalidate()
                    self?.cardIsHiding = true
                    UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseIn], animations: {
                        self?.cards[0].alpha = 0.0
                    }, completion: { (_) in
                        self?.removOldFrontCard()
                        self?.cardIsHiding = false
                        
                    })
                }
            })
        } else {
            UIView.animate(withDuration: 0.2, delay: 1.5, options: [.curveEaseIn], animations: {
                self.cards[0].alpha = 0.0
            }, completion: { (_) in
                self.removOldFrontCard()
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func gallery0Tapped(index: Int) {
        print(index)
    }
    
    func gallery0LongPressed(index: Int) {
        print(index)
    }
}
