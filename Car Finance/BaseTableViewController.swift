//
//  TableViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-03-30.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    var textFields : [UITextField] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
    }
    
    @IBAction func savePressed(saveButton : UIButton){
        print("Save pressed!")
        
        let ac = UIAlertController(title: "Please enter a name for the quote:", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Save", style: .Default) {(action: UIAlertAction!) in
            let answer = ac.textFields![0] 
            print("User entered : \(answer.text)")
            
            if let name = answer.text{
                self.saveQuote(name)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) {(action: UIAlertAction!) in
            print("Cancel pressed")
        }
        
        ac.addAction(submitAction)
        ac.addAction(cancelAction)
        ac.view.setNeedsLayout()
        presentViewController(ac, animated: true, completion: nil)
    }
    
/*    func handleCancel(alertView: UIAlertAction!)
    {
        print("User click cancel button")
    }
 */
    func saveQuote(name : String){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupSaveButton(saveButton : UIButton){
        saveButton.backgroundColor = Common.blueColor
        saveButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        //saveButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Disabled)
        saveButton.layer.cornerRadius = 5
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    func calculate(){
        
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
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(BaseTableViewController.dismissKeyboard))
        
        let items = NSMutableArray()
        items.addObject(flexSpace)
        items.addObject(done)
        
        doneToolbar.items = [done]
        doneToolbar.sizeToFit()
        
        for textField in textFields{
            textField.inputAccessoryView = doneToolbar
        }
    }
    
    func dismissKeyboard()
    {
        for textField in textFields{
            textField.resignFirstResponder()
        }

        calculate()
    }
    
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            // dismiss keyboards
            dismissKeyboard()
        }
    }
    
    @IBAction func switchFlipped(mySwitch : UISwitch){
        calculate()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}