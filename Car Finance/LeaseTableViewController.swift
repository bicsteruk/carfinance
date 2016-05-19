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
    
    @IBOutlet var saveButton : UIButton!
    
    
    // helper variables
    var aprDefault : Double = 0.0
    var monthsDefault : Int = 0
    
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
    
    var quote : Quote = Quote()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Lease Calculator"
        self.didViewLoad = true
        
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
        settingsUpdate(SettingsController.readSettings())
        
        // set residual to be 0
        residualLabel.text = "Buy Out (Residual): \(residualVal)%"
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
        
        textFields.append(msrpField)
        textFields.append(agreedPriceField)
        textFields.append(aprTextField)
        textFields.append(monthTextField)
        
        self.setupSaveButton(saveButton)
        
        // add done button to keyboard
        self.addDoneButtonOnKeyboard()
    }
    
    override func updateQuote(){
       
        // update the quote
        QuoteController.updateQuote(quote, newQuote : populateQuote())
        
        // pop the view controller
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func populateQuote() -> Quote{
        let quote = Quote()
        quote.type = Common.LEASE
        //quote.name = name
        
        quote.loanAmount = loanAmount
        quote.financeCost = financeCost
        quote.totalCost = totalCost
        quote.weeklyCost = weeklyCost
        quote.biWeeklyCost = biWeeklyCost
        quote.monthlyCost = monthlyCost
        
        quote.negPrice = negPrice
        quote.moneyDown = moneyDown
        quote.aprVal = aprVal
        quote.numberOfMonths = numberOfMonths
        quote.incTax = incTax
        
        quote.downPaymentSliderMinimumValue = downPaymentSlider.minimumValue
        quote.downPaymentSliderMaximumValue = downPaymentSlider.maximumValue
        quote.downPaymentSliderValue = downPaymentSlider.value
        
        quote.monthStepperMinimumValue = monthStepper.minimumValue
        quote.monthStepperMaximumValue = monthStepper.maximumValue
        quote.monthStepperValue = monthStepper.value
        
        quote.aprStepperMinimumValue = aprStepper.minimumValue
        quote.aprStepperMaximumValue = aprStepper.maximumValue
        quote.aprStepperValue = aprStepper.value
        
        // lease specific items
        quote.msrpValue = msrpValue
        quote.residualVal = residualVal
        
        quote.residualSliderMinimumValue = residualSlider.minimumValue
        quote.residualSliderMaximumValue = residualSlider.maximumValue
        quote.residualSliderValue = residualSlider.value
        
        return quote
    }
    
    override func saveQuote(name : String){
        // create the quote object
        let quote = populateQuote()
        quote.name = name
        
        // save the quote
        QuoteController.addQuote(quote)
        
        // disable the save button
        saveButton.enabled = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // we only update the navigation buttons and show quote if this is a view instance
        if(quote.name != ""){
            let btnShowMenu = UIButton(type: UIButtonType.System)
            btnShowMenu.setImage(UIImage(named: "Back"), forState: UIControlState.Normal)
            btnShowMenu.frame = CGRectMake(0, 0, 30, 30)
            btnShowMenu.addTarget(self, action: #selector(LeaseTableViewController.goBack), forControlEvents: UIControlEvents.TouchUpInside)
            let customBarItem = UIBarButtonItem(customView: btnShowMenu)
            self.navigationItem.leftBarButtonItem = customBarItem;

            showQuote()
            quoteChanged = false
            inViewMode = true
        }
        
        super.viewWillAppear(animated)
    }
    


    func showQuote(){
        self.title = quote.name
        
        // map out from the quote object to the view
        msrpField.text = String(format: "%.2f", quote.msrpValue)
        agreedPriceField.text = String(format: "%.2f", quote.negPrice)
        
        downPaymentSlider.minimumValue = quote.downPaymentSliderMinimumValue
        downPaymentSlider.maximumValue = quote.downPaymentSliderMaximumValue
        downPaymentSlider.value = quote.downPaymentSliderValue
        downPaymentLabel.text = "Money Down/Trade In: \(currencySymbol)\(quote.moneyDown)"
        
        residualSlider.minimumValue = quote.residualSliderMinimumValue
        residualSlider.maximumValue = quote.residualSliderMaximumValue
        residualSlider.value = quote.residualSliderValue
        
        msrpValue = quote.msrpValue
        
        let residualVal = Int(roundf(quote.residualSliderValue) * 1)
        if msrpValue == 0.0{
            residualLabel.text = "Buy Out (Residual): \(residualVal)%"
        }else{
            self.residualVal = (msrpValue/100) * Double(residualVal)
            residualLabel.text = "Buy Out (Residual): \(residualVal)% (\(currencySymbol)\(Int(self.residualVal)))"
        }
        
        aprStepper.value = quote.aprStepperValue
        aprStepper.minimumValue = quote.aprStepperMinimumValue
        aprStepper.maximumValue = quote.aprStepperMaximumValue
        aprTextField.text = String(format: "%.2f", quote.aprVal)
        
        monthStepper.value = quote.monthStepperValue
        monthStepper.minimumValue = quote.monthStepperMinimumValue
        monthStepper.maximumValue = quote.monthStepperMaximumValue
        monthTextField.text = "\(quote.numberOfMonths)"
        
        // tax switch
        taxSwitch.on = quote.incTax
        
        // results
        weeklyLabel.text = currencySymbol + String(format: "%.2f", quote.weeklyCost)
        biWeeklyLabel.text = currencySymbol + String(format: "%.2f", quote.biWeeklyCost)
        monthlyLabel.text = currencySymbol + String(format: "%.2f", quote.monthlyCost)
        
        // other details
        loanAmountLabel.text = currencySymbol + String(format: "%.2f", quote.loanAmount)
        financeCostLabel.text = currencySymbol + String(format: "%.2f", quote.financeCost)
        totalCostLabel.text = currencySymbol + String(format: "%.2f", quote.totalCost)
        
        saveButton.setTitle("Update", forState: UIControlState.Normal)
    }

    
    func settingsUpdate(details : SettingsDetails){
        
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
        downPaymentLabel.text = "Money Down/Trade In: \(currencySymbol)" + String(format: "%.2f", downPaymentSlider.value)
    
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
    
    override func calculate(){
        
        quoteChanged = true
        
        saveButton.enabled = true
        
        // read values from the view
        updateHelperVars()
        
        // ensure any keyboard is hidden
        for textField in textFields{
            textField.resignFirstResponder()
        }

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
            residualLabel.text = "Buy Out (Residual): \(residualVal)%"
        }else{
            self.residualVal = (msrpValue/100) * Double(residualVal)
            residualLabel.text = "Buy Out (Residual): \(residualVal)% (\(currencySymbol)\(Int(self.residualVal)))"
        }
        calculate()
    }
    
    @IBAction func downPaymentSlide(slider : UISlider){
        let downPaymentValue = Int(round(slider.value / 100) * 100)
        moneyDown = Int(downPaymentValue)
        downPaymentLabel.text = "Money Down/Trade In: \(currencySymbol)\(downPaymentValue)"
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
        return 4
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 4
        }
        
        if section == 1{
            return 4
        }
        
        if section == 2{
            return 4
        }
        
        return 5
    }
}
