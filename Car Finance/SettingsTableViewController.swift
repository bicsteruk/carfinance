//
//  SettingsTableViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-03.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsTableViewController: BaseTableViewController, UITextFieldDelegate {

    @IBOutlet var saveButton : UIButton!
    
    @IBOutlet var taxRate : UITextField!
    @IBOutlet var monthTextField : UITextField!
    @IBOutlet var aprTextField : UITextField!
    @IBOutlet var downPaymentMin : UITextField!
    @IBOutlet var downPaymentMax : UITextField!
    @IBOutlet var downPaymentDefault : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        
        // remove navigation button items
       // self.navigationItem.leftBarButtonItems = []
       // self.navigationItem.rightBarButtonItems = []
        
        // add a cancel button
     /*   let cancelButton = UIButton(type: UIButtonType.System)
        cancelButton.setImage(UIImage(named: "Cancel"), forState: UIControlState.Normal)
        cancelButton.frame = CGRectMake(0, 0, 30, 30)
        cancelButton.addTarget(self, action: #selector(BaseViewController.onLeftButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelBarItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = cancelBarItem;
      */
        taxRate.delegate = self
        taxRate.keyboardType = UIKeyboardType.DecimalPad
        monthTextField.delegate = self
        monthTextField.keyboardType = UIKeyboardType.NumberPad
        aprTextField.delegate = self
        aprTextField.keyboardType = UIKeyboardType.DecimalPad
        
        downPaymentMin.delegate = self
        downPaymentMin.keyboardType = UIKeyboardType.NumberPad
        downPaymentMax.delegate = self
        downPaymentMax.keyboardType = UIKeyboardType.NumberPad
        downPaymentDefault.delegate = self
        downPaymentDefault.keyboardType = UIKeyboardType.NumberPad
        
        textFields.append(taxRate)
        textFields.append(aprTextField)
        textFields.append(monthTextField)
        textFields.append(downPaymentMax)
        textFields.append(downPaymentDefault)
        
        // add done button
        self.addDoneButtonOnKeyboard()
        
        // read stored settings
        outputSettings(SettingsController.readSettings())
    }
 
    func outputSettings(settings : SettingsDetails){
        taxRate.text = String(format: "%.1f", settings.taxRate)
        monthTextField.text = "\(settings.monthsDefault)"
        aprTextField.text = String(format: "%.2f", settings.aprDefault)
        downPaymentDefault.text = "\(settings.downPaymentDefault)"
        downPaymentMin.text = "\(settings.downPaymentMin)"
        downPaymentMax.text = "\(settings.downPaymentMax)"
    }
    
    func readSettings() -> SettingsDetails{
        let settings = SettingsDetails()
        settings.taxRate = Double(Common.retrieveTextFieldValue(taxRate))!
        settings.monthsDefault = Int(Common.retrieveTextFieldValue(monthTextField))!
        settings.aprDefault = Double(Common.retrieveTextFieldValue(aprTextField))!
        settings.downPaymentDefault = Int(Common.retrieveTextFieldValue(downPaymentDefault))!
        settings.downPaymentMin = Int(Common.retrieveTextFieldValue(downPaymentMin))!
        settings.downPaymentMax = Int(Common.retrieveTextFieldValue(downPaymentMax))!
        return settings
    }
    
    @IBAction func saveSettings(){
        // notify all views of a settings update
        let navigationController = self.navigationController as! NavigationViewController
        let settings = readSettings()
        SettingsController.saveSettings(settings)
        navigationController.notifySettingsUpdate(settings)
        // close the settings window
        navigationController.popViewControllerAnimated(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    // return number of views per section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        
        if section == 1{
            return 5
        }
        
        if section == 2{
            return 1
        }
        
        return 0
    }
}