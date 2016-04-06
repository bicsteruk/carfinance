//
//  ViewLeaseTableViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-05.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class ViewLeaseTableViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
