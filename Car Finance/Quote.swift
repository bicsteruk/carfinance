//
//  Quote.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-04.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import Foundation
import RealmSwift

class Quote:Object{

    dynamic var quoteID = NSUUID().UUIDString
    
    dynamic var name : String = ""
    dynamic var type : String = ""
    
    // common fields
    dynamic var negPrice : Double = 0.0
    dynamic var moneyDown : Int = 0
    dynamic var aprVal : Double = 0.0
    dynamic var numberOfMonths : Int = 0
    dynamic var incTax : Bool = false
    
    // calculated variables
    dynamic var loanAmount : Double = 0.0
    dynamic var financeCost : Double = 0.0
    dynamic var totalCost : Double = 0.0
    dynamic var weeklyCost : Double = 0.0
    dynamic var biWeeklyCost : Double = 0.0
    dynamic var monthlyCost : Double = 0.0

    // settings
    dynamic var downPaymentMin : Int = 0
    dynamic var downPaymentMax : Int = 25000
    dynamic var downPaymentDefault : Int = 0
    dynamic var aprDefault : Double = 1.0
    dynamic var monthsDefault : Int = 36
    dynamic var taxRate : Double = 13.1
    
    // control variables
    dynamic var downPaymentSliderMinimumValue : Float = 0
    dynamic var downPaymentSliderMaximumValue : Float = 0
    dynamic var downPaymentSliderValue : Float = 0
    
    dynamic var monthStepperMinimumValue : Double = 0
    dynamic var monthStepperMaximumValue : Double = 0
    dynamic var monthStepperValue : Double = 0
    
    dynamic var aprStepperMinimumValue : Double = 0
    dynamic var aprStepperMaximumValue : Double = 0
    dynamic var aprStepperValue : Double = 0
    
    // lease specific fields
    dynamic var msrpValue : Double = 0.0
    dynamic var residualVal : Double = 0.0
    
    // control values
    dynamic var residualSliderMinimumValue : Float = 0
    dynamic var residualSliderMaximumValue : Float = 0
    dynamic var residualSliderValue : Float = 0

}