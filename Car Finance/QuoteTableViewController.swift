//
//  QuoteTableViewController.swift
//  
//
//  Created by Chris Beech on 2016-04-04.
//
//

import UIKit

class QuoteTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Quotes"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

}
