//
//  LeaseTableViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-03-30.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class LeaseTableViewController: BaseTableViewController, UITextFieldDelegate, SettingsObserver {
    
    
    @IBOutlet var msrpField : UITextField!
    @IBOutlet var agreedPriceField : UITextField!
    
    @IBOutlet var downPaymentSlider : UISlider!
    @IBOutlet var downPaymentLabel : UILabel!
    
    @IBOutlet var residualSlider : UISlider!
    @IBOutlet var residualLabel : UILabel!
    
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
    
    var msrpValue : Double = 0.0
    var negPrice : Double = 0.0
    var residualVal : Double = 0.0
    var moneyDown : Int = 0
    var aprVal : Double = 0.0
    var numberOfMonths : Int = 0
    var residualSliderVal : Int = 0
    var incTax : Bool = false
    
    var taxAmount : Double = 13.1
    
    // calculated variables
    var loanAmount : Double = 0.0
    var financeCost : Double = 0.0
    var totalCost : Double = 0.0
    var weeklyCost : Double = 0.0
    var biWeeklyCost : Double = 0.0
    var monthlyCost : Double = 0.0
    
    var didViewLoad : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lease Calculator"
        self.didViewLoad = true
        
        // read the user's currency symbol
        let currentLocale = NSLocale.currentLocale()
        self.currencySymbol = String(currentLocale.objectForKey(NSLocaleCurrencySymbol)!)
        
        // set input field settings
        msrpField.delegate = self
        msrpField.keyboardType = UIKeyboardType.DecimalPad
        agreedPriceField.delegate = self
        agreedPriceField.keyboardType = UIKeyboardType.DecimalPad
        monthTextField.delegate = self
        monthTextField.keyboardType = UIKeyboardType.NumberPad
        aprTextField.delegate = self
        aprTextField.keyboardType = UIKeyboardType.DecimalPad
        
        // set default values
        settingsUpdate(SettingsDetails())
        
        // set residual to be 0
        residualLabel.text = "Residual: \(residualVal)%"
        residualSlider.minimumValue = 0
        residualSlider.maximumValue = 100
        
        //reset labels
        loanAmountLabel.text = "\(currencySymbol)0.00"
        financeCostLabel.text = "\(currencySymbol)0.00"
        totalCostLabel.text = "\(currencySymbol)0.00"
        
        weeklyLabel.text = "\(currencySymbol)0.00"
        biWeeklyLabel.text = "\(currencySymbol)0.00"
        monthlyLabel.text = "\(currencySymbol)0.00"
        
        // set up stepper
        monthStepper.wraps = false
        monthStepper.autorepeat = true
        monthStepper.continuous = true
        monthStepper.minimumValue = 1
        monthStepper.maximumValue = 90
        //monthStepper.value = 36.0
        
        
        aprStepper.wraps = false
        aprStepper.autorepeat = true
        aprStepper.continuous = true
        aprStepper.minimumValue = 0
        aprStepper.maximumValue = 1000
        //aprStepper.value = 100.0

        taxSwitch.thumbTintColor = Common.greyColor
        taxSwitch.onTintColor = Common.blueColor
        
        
        // add done button to keyboard
        self.addDoneButtonOnKeyboard()
        

    }
    
    func settingsUpdate(details : SettingsDetails){
        print("settingsUpdate called from LeaseTableController")
        
        if(!didViewLoad){
            return
        }
        
        if residualVal == 0.0{
            residualSlider.value = 0.0
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
        
        // update steppers and associated labels
        Common.updateStepperVal(details.aprDefault * 100, stepper : aprStepper)
        aprTextField.text = String(format: "%.2f", details.aprDefault)
        
        Common.updateStepperVal(Double(details.monthsDefault), stepper : monthStepper)
        monthTextField.text = "\(details.monthsDefault)"
        
        // update tax rate
        self.taxAmount = details.taxRate
        
        calculate()
    }
    
    
    
    func calculate(){
        // read values from the view
        updateHelperVars()

        // avoid a divide by zero
        if(numberOfMonths == 0){
            numberOfMonths = 1
        }
        
        loanAmount = (negPrice - Double(moneyDown)) - residualVal
        let moneyFactor = aprVal / 2400
        let monthlyLeaseFee = (negPrice + residualVal) * moneyFactor
        financeCost = monthlyLeaseFee * Double(numberOfMonths)
        
        let monthlyLoanCostWithoutFee = loanAmount / Double(numberOfMonths)
        monthlyCost = monthlyLoanCostWithoutFee + monthlyLeaseFee
        
        totalCost = residualVal + financeCost + loanAmount + Double(moneyDown)
        
        if(incTax){
            monthlyCost = monthlyCost * (1+(taxAmount/100))
        }
        
        let totalFinanceCost = monthlyCost * Double(numberOfMonths)
        
        let numberOfWeeks = Int(round(Double(numberOfMonths) * 4.333333))
        weeklyCost = totalFinanceCost / Double(numberOfWeeks)
        biWeeklyCost = totalFinanceCost / Double(numberOfWeeks/2)
        
        // update the view
        updateCalculatedFields()
    }
    
    func updateHelperVars(){
        
        msrpValue = Double(Common.retrieveTextFieldValue(msrpField))!
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
    
    @IBAction func residualSlide(slider : UISlider){
        let residualVal = Int(roundf(residualSlider.value) * 1)
        //self.residualSliderVal = residualVal
        if msrpValue == 0.0{
            residualLabel.text = "Residual: \(residualVal)%"
        }else{
            self.residualVal = (msrpValue/100) * Double(residualVal)
            residualLabel.text = "Residual: \(residualVal)% (\(currencySymbol)\(Int(self.residualVal)))"
        }
        calculate()
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
            // dismiss keyboards
            dismissKeyboard()
        }
    }
    
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(LeaseTableViewController.dismissKeyboard))
        
        let items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        
        doneToolbar.items = [done]
        doneToolbar.sizeToFit()
        
        msrpField.inputAccessoryView = doneToolbar
        agreedPriceField.inputAccessoryView = doneToolbar
        aprTextField.inputAccessoryView = doneToolbar
        monthTextField.inputAccessoryView = doneToolbar

    }
    
    func dismissKeyboard()
    {
        msrpField.resignFirstResponder()
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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 17
    }
}
