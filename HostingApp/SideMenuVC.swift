//
//  SideMenuVC.swift
//  Side Menu
//
//  Created by Kyle Lee on 8/6/17.
//  Copyright © 2017 Kyle Lee. All rights reserved.
//

import UIKit

class SideMenuVC: UIViewController {
    
    @IBOutlet var icoImageView: UIImageView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        icoImageView?.layer.cornerRadius = 53
        icoImageView?.layer.borderWidth = 1
        icoImageView?.clipsToBounds = true
    }

    
    @IBAction func showHomeButonClicked() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("ShowProfile"), object: nil)
    }
    
    @IBAction func showSettingsButonClicked() {
        NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name("ShowSettings"), object: nil)
    }
}

