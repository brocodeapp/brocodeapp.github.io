//
//  CatboardBanner.swift
//  TastyImitationKeyboard
//
//  Created by Alexei Baboulevitch on 10/5/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit

/*
This is the demo banner. The banner is needed so that the top row popups have somewhere to go. Might as well fill it
with something (or leave it blank if you like.)
*/

class CatboardBanner: ExtraView {
    
    var catLabel: UILabel = UILabel()
    
    let enCryptButton: UIButton = UIButton()
    let deCryptButton: UIButton = UIButton()
    let backbutton: UIButton = UIButton()
    let backTokeyboardbutton: UIButton = UIButton()

    
    let defaultTxtFiled: MyLabel = MyLabel()
    let keyTxtFiled: MyLabel = MyLabel()
    
    let defaultTxtFiledContainerView = UIView()
    let defaultTxtplaceHolderLbl = UILabel()
    let keyTxtFiledContainerView = UIView()
    let keyTxtplaceHolderLbl = UILabel()


    let sendButon: UIButton = UIButton()
    
    var selectedLabel: UILabel?
    var activeColor: CGColor = UIColor.blue.cgColor


    //let defaultCustomTxtlabel: UILabel = UI()
    
    func updatePlaceHolderTextUI() {
        let defaultText = defaultTxtFiled.text ?? ""
        let secretText = keyTxtFiled.text ?? ""
        defaultTxtFiled.backgroundColor = defaultText.isEmpty ? UIColor.clear : UIColor.white
        keyTxtFiled.backgroundColor = secretText.isEmpty ? UIColor.clear : UIColor.white
        defaultTxtFiledContainerView.backgroundColor = .white
        defaultTxtplaceHolderLbl.backgroundColor = .white
        defaultTxtplaceHolderLbl.textColor = .lightGray
        
        keyTxtFiledContainerView.backgroundColor = .white
        keyTxtplaceHolderLbl.backgroundColor = .white
        keyTxtplaceHolderLbl.textColor = .lightGray
        
    }

    
    required init(globalColors: GlobalColors.Type?, darkMode: Bool, solidColorMode: Bool) {
        super.init(globalColors: globalColors, darkMode: darkMode, solidColorMode: solidColorMode)
        
        self.addSubview(enCryptButton)
        self.addSubview(deCryptButton)
        self.addSubview(backbutton)
        self.addSubview(backTokeyboardbutton)
        
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture1))
        tabGesture.numberOfTapsRequired = 1
        tabGesture.numberOfTouchesRequired = 1
        self.defaultTxtFiled.addGestureRecognizer(tabGesture)
        
        ///// Encrypt

        let tabGesture1 = UITapGestureRecognizer(target: self, action: #selector(tapGesture2))
        tabGesture1.numberOfTapsRequired = 1
        tabGesture1.numberOfTouchesRequired = 1
        self.keyTxtFiled.addGestureRecognizer(tabGesture1)
        
        self.keyTxtFiled.isUserInteractionEnabled = true
        
        
        self.addSubview(defaultTxtFiledContainerView)
               self.addSubview(defaultTxtplaceHolderLbl)
        defaultTxtplaceHolderLbl.text = "Enter your message"

        self.addSubview(keyTxtFiledContainerView)
               self.addSubview(keyTxtplaceHolderLbl)
        keyTxtplaceHolderLbl.text = "Enter secret message"

        
        // Sequnce 1
        self.addSubview(defaultTxtFiledContainerView)
        self.addSubview(keyTxtFiledContainerView)
        
        // Sequnce 2
        self.addSubview(defaultTxtplaceHolderLbl)
        self.addSubview(keyTxtplaceHolderLbl)
        
        // Sequnce 3
        self.addSubview(defaultTxtFiled)
        self.addSubview(keyTxtFiled)
        
        self.addSubview(sendButon)
        
        backbutton.isHidden = true
        backTokeyboardbutton.isHidden = true
        defaultTxtFiled.isHidden = true
        defaultTxtFiledContainerView.isHidden = true
        defaultTxtplaceHolderLbl.isHidden = true
        keyTxtFiled.isHidden = true
        keyTxtplaceHolderLbl.isHidden = true
        keyTxtFiledContainerView.isHidden = true
        sendButon.isHidden = true
        
        defaultTxtFiled.textColor = .black
        keyTxtFiled.textColor = .black
        defaultTxtFiled.layer.cornerRadius = 5
        defaultTxtFiled.clipsToBounds = true
        defaultTxtFiledContainerView.layer.cornerRadius = 5
               defaultTxtFiledContainerView.clipsToBounds = true
        keyTxtFiled.layer.cornerRadius = 5
        keyTxtFiled.clipsToBounds = true
        keyTxtFiledContainerView.layer.cornerRadius = 5
           keyTxtFiledContainerView.clipsToBounds = true
        self.updateAppearance()
    }
    
    @objc func tapGesture1(){
        NotificationCenter.default.post(name: Notification.Name("tapGesture"), object: nil)
        selectedLabel = self.defaultTxtFiled
        self.updatePlaceHolderTextUI()
    }
    
    @objc func tapGesture2(){
        NotificationCenter.default.post(name: Notification.Name("tapGesture1"), object: nil)
        selectedLabel = self.keyTxtFiled
        self.updatePlaceHolderTextUI()
    }
  

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setNeedsLayout() {
        super.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.deCryptButton.frame = CGRect(x: 5, y: self.frame.size.height - 36, width: 32, height: 32)
        self.enCryptButton.frame = CGRect(x: 45, y: self.frame.size.height - 36, width: 32, height: 32)
        self.backbutton.frame = CGRect(x: 8, y: self.frame.size.height - 36, width: 32, height: 32)
        self.backTokeyboardbutton.frame = CGRect(x: 5, y: self.frame.size.height - 36, width: 32, height: 32)
        self.defaultTxtFiled.frame = CGRect(x: 10, y: 10, width: self.frame.size.width - 20, height: 40)
        self.keyTxtFiled.frame = CGRect(x: 10, y: 60, width: self.frame.size.width - 20, height: 40)
        self.defaultTxtFiledContainerView.frame = CGRect(x: 10, y: 10, width: self.frame.size.width - 20, height: 40)
        self.keyTxtFiledContainerView.frame = CGRect(x: 10, y: 60, width: self.frame.size.width - 20, height: 40)
        
        self.defaultTxtplaceHolderLbl.frame = CGRect(x: 15, y: 15, width: self.frame.size.width - 30, height: 30)
        self.keyTxtplaceHolderLbl.frame = CGRect(x: 15, y: 65, width: self.frame.size.width - 30, height: 30)

        self.sendButon.frame = CGRect(x: self.frame.size.width - 40, y: self.frame.size.height - 40, width: 35, height: 35)
    }

    func updateAppearance() {
//        if self.catSwitch.isOn {
//            self.catLabel.text = "😺"
//            self.catLabel.alpha = 1
//        }
//        else {
//            self.catLabel.text = "🐱"
//            self.catLabel.alpha = 0.5
//        }
//
//        self.catLabel.sizeToFit()
    }
}


