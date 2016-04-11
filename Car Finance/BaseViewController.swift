//
//  BaseViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-03-30.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
        
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
        
  /*      let rightMenuButton = UIButton(type: UIButtonType.System)
        rightMenuButton.setImage(UIImage(named: "Settings"), forState: UIControlState.Normal)
        rightMenuButton.frame = CGRectMake(0, 0, 30, 30)
        rightMenuButton.addTarget(self, action: #selector(BaseViewController.onRightButtonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        let rightBarItem = UIBarButtonItem(customView: rightMenuButton)
        self.navigationItem.rightBarButtonItem = rightBarItem;
 */
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
}
