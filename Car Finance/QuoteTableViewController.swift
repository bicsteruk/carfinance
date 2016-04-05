//
//  QuoteTableViewController.swift
//  
//
//  Created by Chris Beech on 2016-04-04.
//
//

import UIKit

class QuoteTableViewController: UITableViewController {

    var quotes : [Quote] = []
    
    @IBOutlet var tblMenuOptions : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Quotes"
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

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        let quote = quotes[indexPath.row]
        
        //imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        imgIcon.image = UIImage(named: "Lease")
        lblTitle.text = quote.name
        
        return cell
    }


    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return quotes.count
    }

}
