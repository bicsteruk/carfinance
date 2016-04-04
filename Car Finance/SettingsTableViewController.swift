//
//  SettingsTableViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-03.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class SettingsTableViewController: BaseTableViewController {

    @IBOutlet var saveButton : UIButton!
    
    @IBOutlet var taxRate : UITextField!
    @IBOutlet var monthTextField : UITextField!
    @IBOutlet var aprTextField : UITextField!
    @IBOutlet var downPaymentMin : UITextField!
    @IBOutlet var downPaymentMax : UITextField!
    @IBOutlet var downPaymentDefault : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Settings"
        
        // remove navigation button items
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
        
        // add a cancel button
        let cancelButton = UIButton(type: UIButtonType.System)
        cancelButton.setImage(UIImage(named: "Cancel"), forState: UIControlState.Normal)
        cancelButton.frame = CGRectMake(0, 0, 30, 30)
        cancelButton.addTarget(self, action: #selector(BaseViewController.onLeftButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let cancelBarItem = UIBarButtonItem(customView: cancelButton)
        self.navigationItem.leftBarButtonItem = cancelBarItem;
        
    }
 
    @IBAction func saveSettings(){
        // notify all views of a settings update
        let navigationController = self.navigationController as! NavigationViewController
        let settings = SettingsDetails()
        navigationController.notifySettingsUpdate(settings)
        // close the settings window
        navigationController.popViewControllerAnimated(true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    // return number of views per section
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        
        if section == 1{
            return 5
        }
        
        if section == 2{
            return 1
        }
        
        return 0
    }

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
