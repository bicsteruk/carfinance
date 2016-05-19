//
//  QuoteTableViewController.swift
//  
//
//  Created by Chris Beech on 2016-04-04.
//
//

import UIKit

class QuoteTableViewController: BaseTableViewController {

    var quotes : [Quote] = []
    var viewLeaseTableViewController : LeaseTableViewController = LeaseTableViewController()
    var viewLoanTableViewController : LoanTableViewController = LoanTableViewController()
    
    @IBOutlet var tblMenuOptions : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Quotes"
        
        // lease and loan controllers
        viewLeaseTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LeaseTableView") as! LeaseTableViewController // view instance of lease table controller
        viewLoanTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoanTableView") as! LoanTableViewController // view instance of loan table controller
        
        // add buttons to navigation bar
        self.addSlideMenuButton()
        // remove settings menu
        self.navigationItem.rightBarButtonItems = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // read all quotes
        quotes = QuoteController.listQuotes()
        
        // update the table
        tblMenuOptions.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let quote = quotes[indexPath.row]
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem

        if quote.type == Common.LEASE{
            viewLeaseTableViewController.quote = quote
            self.navigationController?.pushViewController(viewLeaseTableViewController, animated: true)
        }else{
            viewLoanTableViewController.quote = quote
            self.navigationController?.pushViewController(viewLoanTableViewController, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // remove this quote
            QuoteController.removeQuote(quotes[indexPath.row])
            
            // read all quotes
            quotes = QuoteController.listQuotes()
            
            // update the table
            tblMenuOptions.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("quoteCell")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        let quote = quotes[indexPath.row]
        
        if(quote.type == Common.LEASE){
            imgIcon.image = UIImage(named: "Lease")
        }else{
            imgIcon.image = UIImage(named: "Loan")
        }
        
        lblTitle.text = quote.name
        
        return cell
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quotes.count
    }
}