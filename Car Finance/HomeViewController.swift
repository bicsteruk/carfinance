//
//  HomeViewController.swift
//  Car Finance
//
//  Created by Chris Beech on 2016-03-30.
//  Copyright © 2016 Chris Beech. All rights reserved.
//

import UIKit
import GoogleMobileAds

class HomeViewController: BaseViewController {

  //  @IBOutlet weak var bannerView: GADBannerView!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addSlideMenuButton()
        
 /*       print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
        bannerView.adSize = kGADAdSizeSmartBannerPortrait
        bannerView.adUnitID = "ca-app-pub-4625488968352761/1237294130"
        bannerView.rootViewController = self
       bannerView.loadRequest(GADRequest())
  */  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
