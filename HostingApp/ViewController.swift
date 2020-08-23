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
import GoogleMobileAds

class HostingAppViewController: UIViewController {
    
    @IBOutlet var stats: UILabel?
    
    @IBOutlet var containerView: UIView?
    @IBOutlet var aboutButton: UIButton?
    @IBOutlet var emailButton: UIButton?
    
    @IBOutlet var rateUSButton: UIButton?
    
    
    @IBOutlet var containerView1: UIView?
    
    var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContainerView()
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.heavy)
        ]
        
        Flurry.logEvent("ROOT_VIEW_CONTROLLER", withParameters: ["viewDidLoad": "\(self.title ?? "HostingAppViewController")"])
        Analytics.logEvent("ROOT_VIEW_CONTROLLER", parameters: [
            "viewDidLoad": "\(self.title ?? "HostingAppViewController")"])
        Flurry.logEvent("ROOT_VIEW_VIEWDIDLOAD")
        
        // In this case, we instantiate the banner with desired ad size.
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        
        bannerView.adUnitID = "ca-app-pub-4669862103908847/1705591111"
        
        bannerView.rootViewController = self
        bannerView.delegate = self
        
        
        addBannerViewToView(bannerView)
                    bannerView.load(GADRequest())

        NotificationCenter.default.addObserver(self,
                                                   selector: #selector(showAboutScreen),
                                                   name: NSNotification.Name("ShowSettings"),
                                                   object: nil)
        
    }
    
    
    @IBAction func onMoreTapped() {
           NotificationCenter.default.post(name: NSNotification.Name("ToggleSideMenu"), object: nil)
        Analytics.logEvent("TOGGLE_MENU", parameters: nil)
        Flurry.logEvent("ROOT_VIEW_VIEWDIDLOAD")
        
    }
    
   @objc func showAboutScreen() {
        performSegue(withIdentifier: "ShowSettings", sender: nil)
        Analytics.logEvent("SHOW_ABOUT_SCREEN", parameters: nil)
        Flurry.logEvent("SHOW_ABOUT_SCREEN")
    }
       
    
    private func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem: bottomLayoutGuide,
                                attribute: .top,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
        ])
        
        let adSize = GADAdSizeFromCGSize(CGSize(width: self.view.frame.size.width, height: 50))
        bannerView.adSize = adSize
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


extension HostingAppViewController: GADBannerViewDelegate {
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        
        bannerView.alpha = 0
        UIView.animate(withDuration: 1, animations: {
            bannerView.alpha = 1
        })
        addBannerViewToView(bannerView)
        
        Analytics.logEvent("AD_MOB", parameters: [
            "AD_MOB_ADD_RECIVED": "\(true)", "ADD_UNIT": "\(String(describing: bannerView.adUnitID))",
            "ADD_RESPONSE": "\(String(describing: bannerView.responseInfo?.debugDescription))",
            "ADD_PAID_RESPONSE": "\(bannerView.paidEventHandler.debugDescription)"])
        Flurry.logEvent("AD_MOB_ADD_RECIVED")
        Flurry.logEvent("AD_MOB_ADD_UNIT: \(String(describing: bannerView.adUnitID))")
        Flurry.logEvent("AD_MOB_ADD_RESPONSE: \(String(describing: bannerView.responseInfo?.debugDescription))")
        Flurry.logEvent("AD_MOB_ADD_PAID_RESPONSE: \(bannerView.paidEventHandler.debugDescription)")
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
        Analytics.logEvent("AD_MOB", parameters: [
            "AD_MOB_FAILED_TO_RECIVE_AD": "\(true)"])
        Flurry.logEvent("AD_MOB_FAILED_TO_RECIVE_AD")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
        Analytics.logEvent("AD_MOB", parameters: [
            "AD_MOB_WILL_PRESENT_AD": "\(true)"])
        Flurry.logEvent("AD_MOB_WILL_PRESENT_AD")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
        Analytics.logEvent("AD_MOB", parameters: [
            "AD_MOB_WILL_DISMISS_SCREEN": "\(true)"])
        Flurry.logEvent("AD_MOB_WILL_DISMISS_SCREEN")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
        Analytics.logEvent("AD_MOB", parameters: [
            "AD_MOB_WILL_DID_DISMISS_SCREEN": "\(true)"])
        Flurry.logEvent("AD_MOB_WILL_DID_DISMISS_SCREEN")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
        Analytics.logEvent("AD_MOB", parameters: [
            "AD_MOB_WILL_LEAVE_APPLICATION": "\(true)"])
        Flurry.logEvent("AD_MOB_WILL_LEAVE_APPLICATION")
    }
    
}
