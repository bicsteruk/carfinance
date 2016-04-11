//
//  NavigationViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-03-30.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit
import RealmSwift

class NavigationViewController: UINavigationController {
    
    static var topViewController : UIViewController = UIViewController()
    static var homeViewController : UIViewController = UIViewController()
    static var leaseTableViewController : UITableViewController = UITableViewController()
    static var loanTableViewController : UITableViewController = UITableViewController()
    static var settingsTableViewController : UITableViewController = UITableViewController()
    static var quoteTableViewController : UITableViewController = UITableViewController()
    static var helpViewController : UIViewController = UIViewController()
    static var aboutViewController : UIViewController = UIViewController()
    
    var viewArray : [SettingsObserver] = []
    
    // called from settings window
    func notifySettingsUpdate(details : SettingsDetails){
        for view in viewArray{
            view.settingsUpdate(details)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set font and test of navigation controller titles
        self.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(18), NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // instantiate view controllers
        self.dynamicType.homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeView") as! HomeViewController
        self.dynamicType.leaseTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LeaseTableView") as! LeaseTableViewController
        self.dynamicType.loanTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LoanTableView") as! LoanTableViewController
        self.dynamicType.settingsTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsTableView") as! SettingsTableViewController
        self.dynamicType.quoteTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("QuoteTableView") as! QuoteTableViewController
        self.dynamicType.helpViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HelpView") as! HelpViewController
        self.dynamicType.aboutViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AboutView") as! AboutViewController
        
        // add views to observer array
        viewArray.append(self.dynamicType.leaseTableViewController as! LeaseTableViewController)
        viewArray.append(self.dynamicType.loanTableViewController as! LoanTableViewController)
        
        // push the home view controller on top of the default menu
        self.pushViewController(self.dynamicType.homeViewController, animated: false)
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}