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
    

    static let config = Realm.Configuration(
        // Set the new schema version. This must be greater than the previously used
        // version (if you've never set a schema version before, the version is 0).
        schemaVersion: 0,
            
        // Set the block which will be called automatically when opening a Realm with
        // a schema version lower than the one set above
        migrationBlock: { migration, oldSchemaVersion in
        // We haven’t migrated anything yet, so oldSchemaVersion == 0
        switch oldSchemaVersion {
            case 0:
                break
            default:
                // Nothing to do!
                // Realm will automatically detect new properties and removed properties
                // And will update the schema on disk automatically
                //self.zeroToOne(migration)
                print("Need to migrate Realm schema!")
            }
        })
    
    static func readSettings() -> SettingsDetails{
        let currentSettings = try! Realm(configuration: config).objects(SettingsDetails).first
        if let currentSettingsUW = currentSettings{
            // we have current settings
            return currentSettingsUW
        }else{
            // add these settings to be default
            let settings = SettingsDetails()
            saveSettings(settings)
            return settings
        }
    }
    
    static func saveSettings(newSettings : SettingsDetails){
        let currentSettings = try! Realm(configuration: config).objects(SettingsDetails).first
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