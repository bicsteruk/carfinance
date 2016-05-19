//
//  HomeViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-03-30.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        title = "Home"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
