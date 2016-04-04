//
//  SettingsProtocol.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-01.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import Foundation

protocol SettingsObserver {
    func settingsUpdate(details : SettingsDetails)
}