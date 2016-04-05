//
//  SettingsController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-04.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import Foundation
import RealmSwift

class SettingsController{
    
    static func readSettings() -> SettingsDetails{
        let currentSettings = try! Realm().objects(SettingsDetails).first
        if let currentSettingsUW = currentSettings{
            // we have current settings
            print("Current tax rate is \(currentSettingsUW.taxRate)%")
            return currentSettingsUW
        }else{
            // add these settings to be default
            let settings = SettingsDetails()
            saveSettings(settings)
            return settings
        }
    }
    
    static func saveSettings(newSettings : SettingsDetails){
        let currentSettings = try! Realm().objects(SettingsDetails).first
        if let currentSettingsUW = currentSettings{
            // we have current settings so modify
            try! Realm().write {
                currentSettingsUW.aprDefault = newSettings.aprDefault
                currentSettingsUW.downPaymentDefault = newSettings.downPaymentDefault
                currentSettingsUW.downPaymentMin = newSettings.downPaymentMin
                currentSettingsUW.downPaymentMax = newSettings.downPaymentMax
                currentSettingsUW.monthsDefault = newSettings.monthsDefault
                currentSettingsUW.taxRate = newSettings.taxRate
            }
        }else{
            // write these default settings
            let settings = SettingsDetails()
            // save settings
            do {
                let realm = try Realm()
                try realm.write {
                    realm.add(settings)
                }
            }
            catch let error {
                print("Error adding Settings data: \(error)")
            }
        }
    }
}