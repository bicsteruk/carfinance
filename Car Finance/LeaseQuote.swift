//
//  LeaseQuote.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-04.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import Foundation
import RealmSwift

class LeaseQuote : Quote{
    
    // lease specific fields
    dynamic var msrpValue : Double = 0.0
    dynamic var residualVal : Double = 0.0
}