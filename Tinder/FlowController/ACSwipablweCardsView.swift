//
//  ACSwipablweCardsView.swift
//  ACSwipableCardsView
//
//  Created by Alexey Rossoshansky on 10.12.17.
//  Copyright © 2017 Alexey Rossoshansky. All rights reserved.
//

import UIKit

enum SwipeDirections : Int
{
    case left
    case right
}

protocol ACSwipablweCardsViewDataSource : class
{
    func view ( view : UIView , atIndex index : Int )
    func numberOfViews () -> Int
}

protocol ACSwipablweCardsViewDelegate : class
{
    func swiped ( direction : SwipeDirections , index : Int )
    func swipesEnded()

}

//MARK:- Initialization interface

class ACSwipablweCardsView: UIView
{
    weak var dataSource : ACSwipablweCardsViewDataSource?
        {
        didSet
        {
            setUp()
        }
    }
    weak var delegate : ACSwipablweCardsViewDelegate?
    
    private var nib : UINib?
    //first model is first
    var visibleViews = NSArray()
    var visibleIndex = 0
    var modelsCount = 0
 
    
    func registerNib ( nib : UINib )
    {
        self.nib = nib
    }
    
    private func setUp ()
    {
        clipsToBounds = false
        
        if nib == nil
        {
            print("There is no view IBOutlet!")
            return
        }
        
        drawViews()
    }
    
    func reloadData ()
    {
        if  modelsCount >= dataSource!.numberOfViews(){
            return
        }
        
        let dataDif = dataSource!.numberOfViews() - modelsCount
        let viewsDiff = dataDif > 3 - subviews.count ? 3 - subviews.count : dataDif
        
        if viewsDiff >= 0 {
            modelsCount = dataSource!.numberOfViews()
            renderViews(number: viewsDiff, startIndex: visibleIndex + 1)
        }
        
    }
    
    private func drawViews ()
    {
        modelsCount = dataSource!.numberOfViews()
        if modelsCount == 0
        {
            return
        }
        let viewsNumber = dataSource!.numberOfViews() >= 3 ? 3 : modelsCount
        renderViews( number: viewsNumber, startIndex: visibleIndex )
    }
    //Rendering of views and adding to subview
    private func renderViews ( number : Int, startIndex: Int )
    {
        let viewsArray = NSMutableArray()
        var indexCounter = startIndex
        
        for _ in 0..<number
        {
            let rawView = nib!.instantiate(withOwner: nil, options: nil)[0] as! UIView
            dataSource!.view(view: rawView, atIndex: indexCounter)
            
            rawView.frame = bounds
            insertSubview(rawView, at: 0)
            viewsArray.add(rawView)
            indexCounter += 1
        }
        
        visibleViews = viewsArray.count > 0 ? viewsArray: visibleViews
        addRecognizers()
    }
    
    private func addRecognizers ()
    {
        for i in 0..<visibleViews.count
        {
            let view = visibleViews[i] as! UIView
            addPanGestureRecognizer ( view: view )
        }
    }
    
    private func addPanGestureRecognizer ( view : UIView )
    {
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(rec:)))
        view.addGestureRecognizer(recognizer)
    }
}

//MARK:- selectors for gesture recognizers

extension ACSwipablweCardsView
{
    @objc func handlePan (rec : UIPanGestureRecognizer)
    {
        let view = rec.view!
        let translation = rec.translation(in: view)
        
        var centerDiff = view.center.x - self.bounds.width / 2
        print("center \(centerDiff)")
        //Center translation
        let newCenter = CGPoint(x: view.center.x + translation.x, y: view.center.y + translation.y)
        view.center = newCenter
        
        //Rotation and decrease
        let rotator = self.frame.width 
        let scale = min(100 / abs(centerDiff), 1)
        view.transform = CGAffineTransform(rotationAngle: centerDiff/rotator).scaledBy(x: scale, y: scale)
        print("rotate \(rotator)")
        if centerDiff > 0 {
            
            UIView.animate(withDuration: 0.1, delay: 0.1, options: .allowAnimatedContent, animations: {
                let img0 = view.viewWithTag(5001) as! UIImageView
                img0.isHidden = false
                
                let img1 = view.viewWithTag(5002) as! UIImageView
                img1.isHidden = true
                
                img1.alpha = 1
                img0.alpha = 1
            }) { (bool) in
                let img1 = view.viewWithTag(5001) as! UIImageView
                
                let img0 = view.viewWithTag(5002) as! UIImageView
                img1.alpha = 1
                img0.alpha = 1
              
            }
            
        }
        if centerDiff < 0 {
     
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .allowAnimatedContent, animations: {
                let img0 = view.viewWithTag(5002) as! UIImageView
                img0.isHidden = false
                let img1 = view.viewWithTag(5001) as! UIImageView
                img1.isHidden = true
                img1.alpha = 1
                img0.alpha = 1
            }) { (bool) in
                
                let img1 = view.viewWithTag(5001) as! UIImageView
                
                let img0 = view.viewWithTag(5002) as! UIImageView
                img1.alpha = 1
                img0.alpha = 1
               
            }
        }
        if centerDiff == 0 {
            UIView.animate(withDuration: 0.3, delay: 0.1, options: .allowAnimatedContent, animations: {
                let img1 = view.viewWithTag(5001) as! UIImageView
                img1.isHidden = true
                img1.alpha = 0
                let img0 = view.viewWithTag(5002) as! UIImageView
                img0.isHidden = true
                img0.alpha = 0
            }) { (bool) in
                
                let img1 = view.viewWithTag(5001) as! UIImageView
                img1.isHidden = true
                let img0 = view.viewWithTag(5002) as! UIImageView
                img0.isHidden = true
                img1.alpha = 0
                img0.alpha = 0
            }

        }
        
        if rec.state == .ended
        {
            if abs(centerDiff) >= view.frame.size.width / 3 && centerDiff > 0
            {
                //Leads to right
                UIView.animate(withDuration: 0.2, animations: {
                    
                    view.center = CGPoint(x: view.center.x + 550, y: view.center.y)
                    let img0 = view.viewWithTag(5001) as! UIImageView
                    img0.isHidden = false
                    
                }, completion: { [weak self](finished) in
                    self?.handleAction(direction: .right , view : view )

                })
            } else if abs(centerDiff) >= view.frame.size.width / 3 && centerDiff < 0 {
                //Leads to left
                UIView.animate(withDuration: 0.2, animations: {
                    
                    view.center = CGPoint(x: view.center.x - 550, y: view.center.y)
                    let img0 = view.viewWithTag(5002) as! UIImageView
                    img0.isHidden = false
                }, completion: { [weak self](finished) in
                    self?.handleAction(direction: .left , view : view )
                })
            } else {
                //Leads to center back
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    if self != nil {
                        view.center = CGPoint(x: self!.bounds.size.width/2, y: self!.bounds.size.height/2)
                        print(view.frame.origin.x)
                    }
                    let img1 = view.viewWithTag(5001) as! UIImageView
                    img1.isHidden = true
                    let img0 = view.viewWithTag(5002) as! UIImageView
                    img0.isHidden = true
                    view.transform = .identity
                    centerDiff = 0
                })
            }
        }
        rec.setTranslation(CGPoint.zero, in: view)
    }
    
    private func handleAction ( direction : SwipeDirections , view : UIView )
    {
        delegate?.swiped(direction: direction, index: visibleIndex)
        view.removeFromSuperview()
        if modelsCount - visibleIndex <= 3
        {
            if visibleIndex < modelsCount{
                visibleIndex += 1
                return
            }
        }

        dataSource?.view(view: view, atIndex: visibleIndex + 3 )
        view.transform = .identity
        view.frame = bounds
        insertSubview(view, at: 0)

        visibleIndex += 1
    }
    
   
}

