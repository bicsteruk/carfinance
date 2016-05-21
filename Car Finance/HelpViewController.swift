//
//  HelpViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-04-10.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class HelpViewController: BaseViewController {

    @IBOutlet var helpTextView : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        title = "Help"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
