//
//  QuoteController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-04.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import Foundation
import RealmSwift

class QuoteController{
    
    // save quote
    static func addQuote(quote : Quote){
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(quote)
            }
        }
        catch let error {
            print("Error addinf quote: \(error)")
        }
    }
    
    // list quotes
    static func listQuotes() -> Results<Quote>{
        return try! Realm().objects(Quote)
    }
    
    // delete quote
    static func removeQuote(quote : Quote){
        do{
            let realm = try Realm()
            realm.delete(quote)
        }
        catch let error{
            print("Error deleting quote: \(error)")
        }
    }
    
}