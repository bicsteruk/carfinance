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
    static func listQuotes() -> [Quote]{
        let quotesList = try! Realm().objects(Quote)
        
        // convert list into array
        return Array(quotesList)
    }
    
    // delete quote
    static func removeQuote(quote : Quote){
        do{
            let realm = try Realm()
            try realm.write {
                realm.delete(quote)
            }
        }
        catch let error{
            print("Error deleting quote: \(error)")
        }
    }
    
    // modify quote
    static func updateQuote(quote : Quote, newQuote : Quote){
        do{
            let realm = try Realm()
            try realm.write {
                
                quote.loanAmount = newQuote.loanAmount
                quote.financeCost = newQuote.financeCost
                quote.totalCost = newQuote.totalCost
                quote.weeklyCost = newQuote.weeklyCost
                quote.biWeeklyCost = newQuote.biWeeklyCost
                quote.monthlyCost = newQuote.monthlyCost
                
                quote.negPrice = newQuote.negPrice
                quote.moneyDown = newQuote.moneyDown
                quote.aprVal = newQuote.aprVal
                quote.numberOfMonths = newQuote.numberOfMonths
                quote.incTax = newQuote.incTax
                
                quote.downPaymentSliderMinimumValue = newQuote.downPaymentSliderMinimumValue
                quote.downPaymentSliderMaximumValue = newQuote.downPaymentSliderMaximumValue
                quote.downPaymentSliderValue = newQuote.downPaymentSliderValue
                
                quote.monthStepperMinimumValue = newQuote.monthStepperMinimumValue
                quote.monthStepperMaximumValue = newQuote.monthStepperMaximumValue
                quote.monthStepperValue = newQuote.monthStepperValue
                
                quote.aprStepperMinimumValue = newQuote.aprStepperMinimumValue
                quote.aprStepperMaximumValue = newQuote.aprStepperMaximumValue
                quote.aprStepperValue = newQuote.aprStepperValue
                
                // lease specific items
                if quote.type == Common.LEASE{
                    
                    quote.msrpValue = newQuote.msrpValue
                    quote.residualVal = newQuote.residualVal
                
                    quote.residualSliderMinimumValue = newQuote.residualSliderMinimumValue
                    quote.residualSliderMaximumValue = newQuote.residualSliderMaximumValue
                    quote.residualSliderValue = newQuote.residualSliderValue
                }
                
                realm.add(quote, update: true)
            }
        }
        catch let error{
            print("Error modifying quote: \(error)")
        }
    }
    
    
    
}