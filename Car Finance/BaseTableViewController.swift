//
//  TableViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-03-30.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addSlideMenuButton(){
        let btnShowMenu = UIButton(type: UIButtonType.System)
        btnShowMenu.setImage(UIImage(named: "Hamburger"), forState: UIControlState.Normal)
        btnShowMenu.frame = CGRectMake(0, 0, 30, 30)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onLeftButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let customBarItem = UIBarButtonItem(customView: btnShowMenu)
        self.navigationItem.leftBarButtonItem = customBarItem;
        
        let rightMenuButton = UIButton(type: UIButtonType.System)
        rightMenuButton.setImage(UIImage(named: "Settings"), forState: UIControlState.Normal)
        rightMenuButton.frame = CGRectMake(0, 0, 30, 30)
        rightMenuButton.addTarget(self, action: #selector(BaseViewController.onRightButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarItem = UIBarButtonItem(customView: rightMenuButton)
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
    func onLeftButtonPressed(sender : UIButton){
        print("Left pressed")
        
        // retrieve reference to current top view controller
        let currentViewController : UIViewController = self.navigationController!.topViewController!
        
        // if the current view is the menu
        if(currentViewController.isKindOfClass(MenuViewController)){
            // dismiss the menu and replace with the previous top view controller
            self.navigationController?.pushViewController(NavigationViewController.topViewController, animated: true)
        }else{
            // hold a reference to the top view controller
            NavigationViewController.topViewController = currentViewController
            // pop the top view controller
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    
    func onRightButtonPressed(sender : UIButton){
        print("Right pressed")
        self.navigationController?.pushViewController(NavigationViewController.settingsTableViewController, animated: true)
    }

    // function to ensure only monetary values are entered into text fields
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            if let textFieldString = textField.text{
                if (textFieldString.containsString(".")){
                    // we have a decimal point so must ensure there is only one character after it
                    let decimalPointIndex = textFieldString.rangeOfString(".", options: .BackwardsSearch)?.startIndex
                    let decimalString = textFieldString.substringFromIndex(decimalPointIndex!)
                    return decimalString.characters.count <= 2
                }else{
                    // return true as no decimal point
                    return true
                }
            }
            return true
        case ".":
            return !(textField.text?.containsString("."))!
        default:
            return true
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
