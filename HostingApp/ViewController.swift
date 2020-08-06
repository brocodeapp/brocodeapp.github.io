//
//  ViewController.swift
//  TransliteratingKeyboard
//
//  Created by Alexei Baboulevitch on 6/9/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import Firebase
import StoreKit

class HostingAppViewController: UIViewController {
    
    @IBOutlet var stats: UILabel?
    
    @IBOutlet var containerView: UIView?
    @IBOutlet var aboutButton: UIButton?
    @IBOutlet var emailButton: UIButton?
    
    @IBOutlet var rateUSButton: UIButton?


    @IBOutlet var containerView1: UIView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        
        Flurry.logEvent("ROOT_VIEW_CONTROLLER", withParameters: ["viewDidLoad": "\(self.title ?? "HostingAppViewController")"])
        Analytics.logEvent("ROOT_VIEW_CONTROLLER", parameters: [
            "viewDidLoad": "\(self.title ?? "HostingAppViewController")"])
        Flurry.logEvent("ROOT_VIEW_VIEWDIDLOAD")

    }
    
    
    @IBAction func dontateButtonClicked() {
        Flurry.logEvent("DONATE", withParameters: ["donate_button_clcicked": "\(true)"])
        Analytics.logEvent("DONATE", parameters: [
            "donate_button_clcicked": "\(true)"])
        Flurry.logEvent("DONATE_BUTTON_CLICKED")
        
        let donateUrlString = "https://www.paypal.me/brocodeapp"
        guard let url = URL(string: donateUrlString) else { return }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func emaileButtonClicked() {
        Flurry.logEvent("EMAIL_ID", withParameters: ["email_button_clicked": "\(true)"])
        Analytics.logEvent("EMAIL_ID", parameters: [
            "email_button_clicked": "\(true)"])
        Flurry.logEvent("EMAIL_BUTTON_CLICKED")
        
        let email = "brocodeapp@gmail.com"
        if let url = URL(string: "mailto:\(email)") {
          if #available(iOS 10.0, *) {
            UIApplication.shared.open(url)
          } else {
            UIApplication.shared.openURL(url)
          }
        }
    }
    
    @IBAction func rateUSButtonClicked() {
        Analytics.logEvent("RATE_US", parameters: [
            "rateUs_button_clicked": "\(true)"])
        Flurry.logEvent("RATE_US_BUTTON_CLICKED")
        rateApp()
    }
    
    private func rateApp() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "appId") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func setupContainerView() {
        containerView?.layer.cornerRadius = 12
        containerView?.layer.borderWidth = 0.5
        containerView?.layer.borderColor = UIColor.white.cgColor
        containerView?.clipsToBounds = true
        
        aboutButton?.layer.cornerRadius = 8
        aboutButton?.layer.borderWidth = 0.5
        aboutButton?.layer.borderColor = UIColor.white.cgColor
        
        emailButton?.layer.cornerRadius = 8
        emailButton?.layer.borderWidth = 0.5
        emailButton?.layer.borderColor = UIColor.white.cgColor
        
        rateUSButton?.layer.cornerRadius = 8
        rateUSButton?.layer.borderWidth = 0.5
        rateUSButton?.layer.borderColor = UIColor.white.cgColor
        
        containerView1?.layer.cornerRadius = 12
        containerView1?.layer.borderWidth = 0.5
        containerView1?.layer.borderColor = UIColor.white.cgColor
        containerView1?.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

