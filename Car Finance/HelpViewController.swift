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

        // configure text view
        helpTextView.selectable = true
        helpTextView.editable = false
        helpTextView.dataDetectorTypes = UIDataDetectorTypes.Link
        
        helpTextView.backgroundColor = UIColor.blackColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
