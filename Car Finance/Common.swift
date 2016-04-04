//
//  Common.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-03.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import Foundation
import UIKit

class Common{
    
    static let blueColor = UIColor(red: 22, green: 165, blue: 237)
    static let greyColor = UIColor(red: 121, green: 122, blue: 127)
    
    static func retrieveTextFieldValue(textField : UITextField!) -> String{
        
        if let textFieldUnwrapped = textField{
            if let text = textFieldUnwrapped.text{
                if text.characters.count > 0{
                    return text
                }
            }
        }
        
        return "0"
    }
    
    static func updateStepperVal(newValue : Double, stepper : UIStepper!){
        if newValue >= stepper.maximumValue-1{
            stepper.maximumValue = newValue+1
        }
        stepper.value = newValue
    }
}

extension UIColor
{
    convenience init(red: Int, green: Int, blue: Int)
    {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}