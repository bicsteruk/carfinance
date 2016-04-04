//
//  SettingsDetails.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-01.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import Foundation

class SettingsDetails{
    
    var downPaymentMin : Int = 0
    var downPaymentMax : Int = 50000
    var downPaymentDefault : Int = 0
    
    var aprDefault : Double = 1.0

    var monthsDefault : Int = 36
    
    var taxRate : Double = 13.1
    
    init(){
        
    }
    
    convenience init(downPaymentMin : Int, downPaymentMax : Int, downPaymentDefault : Int, aprDefault : Double, monthsDefault : Int, taxRate : Double){
        self.init()
        self.downPaymentMin = downPaymentMin
        self.downPaymentMax = downPaymentMax
        self.downPaymentDefault = downPaymentDefault
        self.aprDefault = aprDefault
        self.monthsDefault = monthsDefault
        self.taxRate = taxRate
    }
}