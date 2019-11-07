//
//  MaterialDesignClass.swift
//  Tinder
//
//  Created by Apple on 05/06/19.
//  Copyright © 2019 Rajesh Shinde. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

let buttonScheme = MDCButtonScheme()
let shapeScheme1 = MDCShapeScheme()
let largeShapeCategory = MDCShapeCategory()

class MDclass{
    public static func continueBTN(btn:MDCButton){
        
       
        let rounded50PercentCorner = MDCCornerTreatment.corner(withRadius: 0.5,
                                                               valueType: .percentage)
        
        largeShapeCategory?.topLeftCorner = rounded50PercentCorner
        largeShapeCategory?.topRightCorner = rounded50PercentCorner
        shapeScheme1.largeComponentShape = largeShapeCategory!
    
        buttonScheme.shapeScheme = shapeScheme1
        MDCOutlinedButtonThemer.applyScheme(buttonScheme, to: btn)
        
        
    }
}

/*
 
 userNameController = MDCTextInputControllerOutlined(textInput: userNameTF)
 passwordController = MDCTextInputControllerOutlined(textInput: passwordTF)
 
 */
