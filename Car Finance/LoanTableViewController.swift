//
//  LoanTableViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-03.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class LoanTableViewController: BaseTableViewController, UITextFieldDelegate, SettingsObserver {
    
    @IBOutlet var agreedPriceField : UITextField!
    
    @IBOutlet var downPaymentSlider : UISlider!
    @IBOutlet var downPaymentLabel : UILabel!
    
    @IBOutlet var aprStepper : UIStepper!
    @IBOutlet var aprTextField : UITextField!
    
    @IBOutlet var monthStepper : UIStepper!
    @IBOutlet var monthTextField : UITextField!
    
    @IBOutlet var loanAmountLabel : UILabel!
    @IBOutlet var financeCostLabel : UILabel!
    @IBOutlet var totalCostLabel : UILabel!
    
    @IBOutlet var weeklyLabel : UILabel!
    @IBOutlet var biWeeklyLabel : UILabel!
    @IBOutlet var monthlyLabel : UILabel!
    
    @IBOutlet var taxSwitch : UISwitch!
    
    // helper variables
    var currencySymbol = "$"
    
    var negPrice : Double = 0.0
    var moneyDown : Int = 0
    var aprVal : Double = 0.0
    var numberOfMonths : Int = 0
    var incTax : Bool = false
    
    var taxAmount : Double = 13.1
    
    // calculated variables
    var loanAmount : Double = 0.0
    var financeCost : Double = 0.0
    var totalCost : Double = 0.0
    var weeklyCost : Double = 0.0
    var biWeeklyCost : Double = 0.0
    var monthlyCost : Double = 0.0
    
    var aprDefault : Double = 0.0
    var monthsDefault : Int = 0
    
    var didViewLoad : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Finance Calculator"
        didViewLoad = true
        
        // read the user's currency symbol
        let currentLocale = NSLocale.currentLocale()
        self.currencySymbol = String(currentLocale.objectForKey(NSLocaleCurrencySymbol)!)
        
        // set input field settings
        agreedPriceField.delegate = self
        agreedPriceField.keyboardType = UIKeyboardType.DecimalPad
        monthTextField.delegate = self
        monthTextField.keyboardType = UIKeyboardType.NumberPad
        aprTextField.delegate = self
        aprTextField.keyboardType = UIKeyboardType.DecimalPad
        // add done button to keyboards
        self.addDoneButtonOnKeyboard()
        
        

        
        settingsUpdate(SettingsDetails())

    }
    
    func calculate(){
        updateHelperVars()
        
        print("Calculations go here!")
        
        updateCalculatedFields()
    }
    
    func updateHelperVars(){
        
        negPrice = Double(Common.retrieveTextFieldValue(agreedPriceField))!
        aprVal = Double(Common.retrieveTextFieldValue(aprTextField))!
        numberOfMonths = Int(Common.retrieveTextFieldValue(monthTextField))!
        
        // update stepper values to reflect what was typed in
        let currentApr = aprVal * 100
        Common.updateStepperVal(currentApr, stepper : aprStepper)
        Common.updateStepperVal(Double(numberOfMonths), stepper : monthStepper)
        
        // read switch value
        incTax = (taxSwitch.on == true)
    }
    
    
    func updateCalculatedFields(){
        // update the fields to show here
        loanAmountLabel.text = currencySymbol + String(format: "%.2f", loanAmount)
        financeCostLabel.text = currencySymbol + String(format: "%.2f", financeCost)
        totalCostLabel.text = currencySymbol + String(format: "%.2f", totalCost)
        weeklyLabel.text = currencySymbol + String(format: "%.2f", weeklyCost)
        biWeeklyLabel.text = currencySymbol + String(format: "%.2f", biWeeklyCost)
        monthlyLabel.text = currencySymbol + String(format: "%.2f", monthlyCost)
    }
    
    @IBAction func downPaymentSlide(slider : UISlider){
        let downPaymentValue = Int(round(slider.value / 100) * 100)
        moneyDown = Int(downPaymentValue)
        downPaymentLabel.text = "Down Payment: \(currencySymbol)\(downPaymentValue)"
        calculate()
    }
    
    @IBAction func aprStepperValueChanged(sender: UIStepper) {
        aprVal = sender.value/100.0
        aprTextField.text = String(format: "%.2f", aprVal)
        calculate()
    }
    
    @IBAction func monthStepperValueChanged(sender: UIStepper) {
        numberOfMonths = Int(sender.value)
        monthTextField.text = "\(numberOfMonths)"
        calculate()
    }
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            print("Tap detected")
            dismissKeyboard()
        }
    }
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(LoanTableViewController.dismissKeyboard))
        
        let items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        
        doneToolbar.items = [done]
        doneToolbar.sizeToFit()
        
        agreedPriceField.inputAccessoryView = doneToolbar
        aprTextField.inputAccessoryView = doneToolbar
        monthTextField.inputAccessoryView = doneToolbar
        
    }
    
    func dismissKeyboard()
    {
        agreedPriceField.resignFirstResponder()
        aprTextField.resignFirstResponder()
        monthTextField.resignFirstResponder()
        calculate()
    }
    
    @IBAction func switchFlipped(mySwitch : UISwitch){
        calculate()
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == aprTextField{
            aprStepper.enabled = false
        }
        
        if textField == monthTextField{
            monthStepper.enabled = false
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == aprTextField{
            aprStepper.enabled = true
        }
        
        if textField == monthTextField{
            monthStepper.enabled = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func settingsUpdate(details : SettingsDetails){
        print("settingsUpdate called from LoanTableViewController")
        
        if(!didViewLoad){
            return
        }
        
        downPaymentSlider.minimumValue = Float(details.downPaymentMin)
        downPaymentSlider.maximumValue = Float(details.downPaymentMax)
        
        // ensure the slider isn't outside of the relams of the new values
        if moneyDown == 0{
            downPaymentSlider.value = Float(details.downPaymentDefault)
        }else{
            if Int(downPaymentSlider.value) > details.downPaymentMax{
                downPaymentSlider.value = Float(details.downPaymentMax)
            }else if Int(downPaymentSlider.value) < details.downPaymentMin {
                downPaymentSlider.value = Float(details.downPaymentMin)
            }
        }
        
        // update label
        downPaymentLabel.text = "Down Payment: \(currencySymbol)" + String(format: "%.2f", downPaymentSlider.value)
        
        if aprDefault == 0.0{
            // update steppers and associated labels
            Common.updateStepperVal(details.aprDefault * 100, stepper : aprStepper)
            aprTextField.text = String(format: "%.2f", details.aprDefault)
            aprDefault = details.aprDefault
        }else{
            // we have set settings previously
            if aprDefault == aprVal{
                // user hasn't changed APR value
                if aprDefault != details.aprDefault{
                    // update steppers and associated labels
                    Common.updateStepperVal(details.aprDefault * 100, stepper : aprStepper)
                    aprTextField.text = String(format: "%.2f", details.aprDefault)
                    aprDefault = details.aprDefault
                }
            }
        }
        
        if monthsDefault == 0{
            Common.updateStepperVal(Double(details.monthsDefault), stepper : monthStepper)
            monthTextField.text = "\(details.monthsDefault)"
            monthsDefault = details.monthsDefault
        }else{
            if monthsDefault == numberOfMonths{
                if monthsDefault != details.monthsDefault{
                    // update as defaults have changed by user hasn't changed them
                    Common.updateStepperVal(Double(details.monthsDefault), stepper : monthStepper)
                    monthTextField.text = "\(details.monthsDefault)"
                    monthsDefault = details.monthsDefault
                }
            }
        }

        

        
        // update tax rate
        self.taxAmount = details.taxRate
        
        calculate()
    }

    
    
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 3
        }
        
        if section == 1{
            return 2
        }
        
        if section == 2{
            return 3
        }
        
        return 4
    }
}