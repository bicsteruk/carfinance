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
    
    @IBOutlet var saveButton : UIButton!
    
    //helper variables
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

    var quote : Quote = Quote()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Finance Calculator"
        didViewLoad = true
        
        // set input field settings
        agreedPriceField.delegate = self
        agreedPriceField.keyboardType = UIKeyboardType.DecimalPad
        monthTextField.delegate = self
        monthTextField.keyboardType = UIKeyboardType.NumberPad
        aprTextField.delegate = self
        aprTextField.keyboardType = UIKeyboardType.DecimalPad
        
        textFields.append(agreedPriceField)
        textFields.append(monthTextField)
        textFields.append(aprTextField)
        
        // setup buttons
        self.addDoneButtonOnKeyboard()
        self.setupSaveButton(saveButton)
        
        settingsUpdate(SettingsController.readSettings())
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // we only update the navigation buttons and show quote if this is a view instance
        if(quote.name != ""){
            let btnShowMenu = UIButton(type: UIButtonType.System)
            btnShowMenu.setImage(UIImage(named: "Back"), forState: UIControlState.Normal)
            btnShowMenu.frame = CGRectMake(0, 0, 30, 30)
            btnShowMenu.addTarget(self, action: #selector(LoanTableViewController.goBack), forControlEvents: UIControlEvents.TouchUpInside)
            let customBarItem = UIBarButtonItem(customView: btnShowMenu)
            self.navigationItem.leftBarButtonItem = customBarItem;
            
            showQuote()
            quoteChanged = false
            inViewMode = true
        }
        
        super.viewWillAppear(animated)
    }
    
    override func calculate(){
        updateHelperVars()
        
        quoteChanged = true
        
        saveButton.enabled = true
        
        // ensure any keyboard is hidden
        for textField in textFields{
            textField.resignFirstResponder()
        }
        
        if(numberOfMonths == 0){
            numberOfMonths = 1
        }
        
        let numberOfWeeks = Int(round(Double(numberOfMonths) * 4.333333))
        
        if(aprVal == 0){
            
            // a zero apr makes things very easy!
            var priceToPay = negPrice
            if(taxSwitch.on){
                priceToPay = priceToPay * 1.13
            }
            
            priceToPay -= Double(moneyDown)
            
            monthlyCost = priceToPay/Double(numberOfMonths)
            weeklyCost = priceToPay/Double(numberOfWeeks)
            biWeeklyCost = priceToPay/Double(numberOfWeeks/2)
            
            totalCost = priceToPay+Double(moneyDown)

            updateCalculatedFields()
            
            return
        }
        
        //calculate apr factor
        let moneyFactor = (aprVal / 100)/12
        let jVal = pow((1+moneyFactor), Double(-numberOfMonths))
        
        loanAmount = negPrice - Double(moneyDown)
        
        var priceToPay = negPrice
        
        if(taxSwitch.on){
            priceToPay = priceToPay * 1.13
        }
        
        priceToPay -= Double(moneyDown)

        // calculate monthly cost
        monthlyCost = (priceToPay * (moneyFactor / (1-jVal)))
        
        // calculate loan amount
        loanAmount = negPrice - Double(moneyDown)
        
        // calculate total cost
        totalCost = (monthlyCost * Double(numberOfMonths)) + Double(moneyDown)
        financeCost = (monthlyCost * Double(numberOfMonths)) - loanAmount
        
        
        let totalMonthlies = monthlyCost * Double(numberOfMonths)
        weeklyCost = totalMonthlies / Double(numberOfWeeks)
        biWeeklyCost = totalMonthlies / Double(numberOfWeeks/2)
        
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
    
    override func updateQuote(){
        
        // update the quote
        QuoteController.updateQuote(quote, newQuote : populateQuote())
        
        // pop the view controller
        self.navigationController?.popViewControllerAnimated(true)
    }

    func populateQuote() -> Quote{
        let quote = Quote()
        quote.type = Common.LOAN

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

        return quote
    }

    
    override func saveQuote(name : String){
        
        // retrieve quote
        let quote = populateQuote()
        quote.name = name
        
        // save the quote
        QuoteController.addQuote(quote)
        
        saveButton.enabled = false
    }
    
    func showQuote(){
        self.title = quote.name
        
        // map out from the quote object to the view
        //msrpField.text = String(format: "%.2f", quote.msrpValue)
        agreedPriceField.text = String(format: "%.2f", quote.negPrice)
        
        downPaymentSlider.minimumValue = quote.downPaymentSliderMinimumValue
        downPaymentSlider.maximumValue = quote.downPaymentSliderMaximumValue
        downPaymentSlider.value = quote.downPaymentSliderValue
        downPaymentLabel.text = "Money Down/Trade In: \(currencySymbol)\(quote.moneyDown)"
        
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
    
    func settingsUpdate(details : SettingsDetails){
        
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
            return 4
        }
        
        return 5
    }
}