//
//  ViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-03-30.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate  {
    
    
    // table menu options
    @IBOutlet var tblMenuOptions : UITableView!
    
    // transparent button to hide menu
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    // menu option array
    var arrayMenuOptions = [Dictionary<String,String>]()
    
    // menu button tapped to display the menu
    var btnMenu : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("MenuView did load")
        tblMenuOptions.tableFooterView = UIView()
        
        // load menu options into array
        arrayMenuOptions.append(["title":"Home", "icon":"Home"] )
        arrayMenuOptions.append(["title":"Lease Calculator", "icon":"Lease"])
        arrayMenuOptions.append(["title":"Finance Calculator", "icon":"Loan"])

        self.addSlideMenuButton()
        
        // remove settings from menu view
        self.navigationItem.rightBarButtonItems = []
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("MenuView will appear")
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        tblMenuOptions.reloadData()
    }
    
   @IBAction func onCloseMenuClick(button:UIButton!){
   
        var index = Int32(button.tag)
        if(button == self.btnCloseMenuOverlay){
            index = -1
        }
        print("onCloseMenuClick option \(index)")

        switch(index){
            case 0:
                self.navigationController?.pushViewController(NavigationViewController.homeViewController, animated: true)
            break
            case 1:
                self.navigationController?.pushViewController(NavigationViewController.leaseTableViewController, animated: true)
            break
            case 2:
                self.navigationController?.pushViewController(NavigationViewController.loanTableViewController, animated: true)
            break
            default:
                return
        }
    }
 
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
        
        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let btn = UIButton(type: UIButtonType.Custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }

}

