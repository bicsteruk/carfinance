//
//  ViewLeaseTableViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-05.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class ViewLoanTableViewController: BaseTableViewController {
    
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
    var aprDefault : Double = 0.0
    var monthsDefault : Int = 0
    
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
    
    var quote : Quote = Quote()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove navigation button items
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
    }
    
    override func viewWillAppear(animated: Bool) {
        showQuote()
        super.viewWillAppear(animated)
    }
    
    func showQuote(){
        self.title = quote.name
        
        // map out from the quote object to the view
        //msrpField.text = String(format: "%.2f", quote.msrpValue)
        agreedPriceField.text = String(format: "%.2f", quote.negPrice)
        
        downPaymentSlider.minimumValue = quote.downPaymentSliderMinimumValue
        downPaymentSlider.maximumValue = quote.downPaymentSliderMaximumValue
        downPaymentSlider.value = quote.downPaymentSliderValue
        downPaymentLabel.text = "Down Payment: \(currencySymbol)\(quote.moneyDown)"

        // don't need to set steppers
        aprTextField.text = String(format: "%.2f", quote.aprVal)
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
            return 3
        }
        
        if section == 1{
            return 2
        }
        
        if section == 2{
            return 4
        }
        
        return 3
    }
}