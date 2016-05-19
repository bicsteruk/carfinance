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
    dynamic var downPaymentMax : Int = 10000
    dynamic var downPaymentDefault : Int = 0
    dynamic var aprDefault : Double = 1.0
    dynamic var monthsDefault : Int = 36
    dynamic var taxRate : Double = 13
}