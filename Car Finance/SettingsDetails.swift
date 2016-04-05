//
//  SettingsDetails.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-01.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsDetails : Object{
    
    dynamic var downPaymentMin : Int = 0
    dynamic var downPaymentMax : Int = 25000
    dynamic var downPaymentDefault : Int = 0
    dynamic var aprDefault : Double = 1.0
    dynamic var monthsDefault : Int = 36
    dynamic var taxRate : Double = 13.1
    
/*   required init(){
        
    }
    
    convenience required init(){
        self.init()
        
        self.downPaymentMin = 0
        self.downPaymentMax = 50000
        self.downPaymentDefault = 0
        self.aprDefault = 1.0
        self.monthsDefault = 36
        self.taxRate = 13.1
    }
    
    convenience init(downPaymentMin : Int, downPaymentMax : Int, downPaymentDefault : Int, aprDefault : Double, monthsDefault : Int, taxRate : Double){
        self.init()
        self.downPaymentMin = downPaymentMin
        self.downPaymentMax = downPaymentMax
        self.downPaymentDefault = downPaymentDefault
        self.aprDefault = aprDefault
        self.monthsDefault = monthsDefault
        self.taxRate = taxRate
    }*/
}