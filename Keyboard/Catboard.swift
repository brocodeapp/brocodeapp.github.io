//
//  Catboard.swift
//  TransliteratingKeyboard
//
//  Created by Alexei Baboulevitch on 9/24/14.
//  Copyright (c) 2014 Alexei Baboulevitch ("Archagon"). All rights reserved.
//

import UIKit
import Firebase
import Flurry_iOS_SDK

/*
This is the demo keyboard. If you're implementing your own keyboard, simply follow the example here and then
set the name of your KeyboardViewController subclass in the Info.plist file.
*/

let kCatTypeEnabled = "kCatTypeEnabled"

class Catboard: KeyboardViewController {
    
    let takeDebugScreenshot: Bool = true
    var banner:CatboardBanner?
    let options = KIInPlaceEditOptions.longPressToEdit()
    var hasRefference: Bool = false
    var abc:EncryptoDecrypto = EncryptoDecrypto()

    // decryptView
    var decryptViewContainer:UIView?
    var decryptTitleLabel:UILabel?
    var decryptMsgLabel:UILabel?


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        UserDefaults.standard.register(defaults: [kCatTypeEnabled: true])

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        

    }
    
    @objc func tapGesture(){
        self.hasReference = true
        self.banner?.defaultTxtFiled.layer.borderColor = self.banner?.activeColor
        self.banner?.keyTxtFiled.layer.borderColor = UIColor.clear.cgColor
        self.banner?.defaultTxtFiled.layer.borderWidth = 2
        self.banner?.keyTxtFiled.layer.borderWidth = 2

    }
    
    @objc func tapGesture1(){
        self.hasReference = true
        self.banner?.defaultTxtFiled.layer.borderColor = UIColor.clear.cgColor
        self.banner?.keyTxtFiled.layer.borderColor = self.banner?.activeColor
        self.banner?.defaultTxtFiled.layer.borderWidth = 2
        self.banner?.keyTxtFiled.layer.borderWidth = 2
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        print("textWillChange")
        if self.hasReference {
            self.banner?.defaultTxtFiled.layer.borderColor = UIColor.clear.cgColor
            self.banner?.keyTxtFiled.layer.borderColor = UIColor.clear.cgColor
            self.banner?.selectedLabel = nil
            self.banner?.updatePlaceHolderTextUI()
            self.becomeFirstResponder()
            self.hasReference = false
        }
        
        
    }

    func resetSelection()
    {
        if self.hasReference {
            self.banner?.defaultTxtFiled.text = ""
            self.banner?.keyTxtFiled.text = ""
            self.banner?.defaultTxtFiled.layer.borderColor = UIColor.clear.cgColor
            self.banner?.keyTxtFiled.layer.borderColor = UIColor.clear.cgColor
            self.banner?.selectedLabel = nil
            self.banner?.updatePlaceHolderTextUI()
            self.becomeFirstResponder()
            self.hasReference = false
        }

    }
    
    override func keyPressed(_ key: Key) {
     
        let textDocumentProxy = self.textDocumentProxy
        let keyOutput = key.outputForCase(self.shiftState.uppercase())

        if self.hasReference {
            self.resignFirstResponder()
            
            var tempStr = self.banner?.selectedLabel?.text ?? ""
            tempStr.append(keyOutput)
            self.banner?.selectedLabel?.text = tempStr
            self.banner?.updatePlaceHolderTextUI()
            return
        }
        
        
        if !UserDefaults.standard.bool(forKey: kCatTypeEnabled) {
            textDocumentProxy.insertText(keyOutput)
            return
        }
        
        if key.type == .character || key.type == .specialCharacter {
            if let context = textDocumentProxy.documentContextBeforeInput {
                if context.characters.count < 2 {
                    textDocumentProxy.insertText(keyOutput)
                    return
                }
                
                var index = context.endIndex
                
                index = context.index(before: index)
                if context[index] != " " {
                    textDocumentProxy.insertText(keyOutput)
                    return
                }
                
                index = context.index(before: index)
                if context[index] == " " {
                    textDocumentProxy.insertText(keyOutput)
                    return
                }

//                textDocumentProxy.insertText("\(randomCat())")
//                textDocumentProxy.insertText(" ")
                textDocumentProxy.insertText(keyOutput)
                return
            }
            else {
                textDocumentProxy.insertText(keyOutput)
                return
            }
        }
        else {
            textDocumentProxy.insertText(keyOutput)
            return
        }
    }
    
    override func setupKeys() {
        super.setupKeys()
        
       
    }
    
    override func backspaceDown(_ sender: KeyboardKey) {

        // Keyboard is expanded
        if self.hasReference {
            self.resignFirstResponder()
            
            if let tempStr = self.banner?.selectedLabel?.text {
                if !(tempStr.isEmpty) {
                    let truncate = tempStr.substring(to: tempStr.index(before: tempStr.endIndex))
                    self.banner?.selectedLabel?.text = truncate
                }
            }
            self.banner?.updatePlaceHolderTextUI()
            return
        }
        
        
        super.backspaceDown(sender)
    }
    
    override func createBanner() -> ExtraView? {
        
        NotificationCenter.default.addObserver(self, selector: #selector(tapGesture), name: Notification.Name("tapGesture"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(tapGesture1), name: Notification.Name("tapGesture1"), object: nil)


        banner = CatboardBanner(globalColors: type(of: self).globalColors, darkMode: false, solidColorMode: self.solidColorMode())
        banner?.deCryptButton.addTarget(self, action: #selector(self.decryptButtonAction), for: .touchUpInside)

        banner?.enCryptButton.addTarget(self, action: #selector(self.expandHeight), for: .touchUpInside)
       // banner?.deCryptButton.addTarget(self, action: #selector(self.defaultHeight), for: .touchUpInside)
        banner?.backbutton.addTarget(self, action: #selector(self.defaultHeight), for: .touchUpInside)
        banner?.backTokeyboardbutton.addTarget(self, action: #selector(self.backToKeyboard), for: .touchUpInside)
        banner?.sendButon.addTarget(self, action: #selector(self.sendButtonAction), for: .touchUpInside)


        banner?.enCryptButton.setBackgroundImage(UIImage(named: "encrypt"), for: .normal)
        banner?.deCryptButton.setBackgroundImage(UIImage(named: "decrypt"), for: .normal)
        banner?.backbutton.setBackgroundImage(UIImage(named: "arrow"), for: .normal)
        banner?.sendButon.setBackgroundImage(UIImage(named: "send"), for: .normal)
        banner?.backTokeyboardbutton.setBackgroundImage(UIImage(named: "keyboard"), for: .normal)


        banner?.enCryptButton.setImage(UIImage(named: "encrypt"), for: .normal)
        banner?.deCryptButton.setImage(UIImage(named: "decrypt"), for: .normal)
        banner?.backbutton.setImage(UIImage(named: "arrow"), for: .normal)
        banner?.backTokeyboardbutton.setImage(UIImage(named: "keyboard"), for: .normal)

        banner?.sendButon.setImage(UIImage(named: "send"), for: .normal)
        banner?.defaultTxtFiled.backgroundColor = .white
        banner?.keyTxtFiled.backgroundColor = .white
        
        banner?.backgroundColor = .clear

        //banner?.defaultTxtFiled.clearButtonMode = .whileEditing
        //banner?.keyTxtFiled.clearButtonMode = .whileEditing

        
        return banner
    }
    
    @objc override func expandHeight() {
        
//        let abc = EncryptoDecrypto()
//        abc.encodeSecret("Hi Anispy")
//
//        return
        self.banner?.enCryptButton.isHidden = true
        self.banner?.deCryptButton.isHidden = true
        self.banner?.backTokeyboardbutton.isHidden = true

        super.expandHeight()
        self.perform(#selector(newHeight), with: self, afterDelay: 0.1)
    }
    
    @objc override func newHeight() {
        super.newHeight()
        self.banner?.backbutton.isHidden = false
        self.banner?.defaultTxtFiled.isHidden = false
        self.banner?.keyTxtFiled.isHidden = false
        
        self.banner?.defaultTxtFiledContainerView.isHidden = false
        self.banner?.defaultTxtplaceHolderLbl.isHidden = false

        self.banner?.keyTxtFiledContainerView.isHidden = false
        self.banner?.keyTxtplaceHolderLbl.isHidden = false

        self.banner?.sendButon.isHidden = false
    
        
        options?.setTarget(self, action: #selector(inPlaceTextFieldEvent), for: .editingDidEnd)
        self.banner?.defaultTxtFiled.ipe_enable(inPlaceEdit: options)
        self.banner?.defaultTxtFiled.isEnabled = true
        self.banner?.defaultTxtFiled.isUserInteractionEnabled = true
        self.banner?.keyTxtFiled.isEnabled = true
        self.banner?.keyTxtFiled.isUserInteractionEnabled = true
        self.banner?.updatePlaceHolderTextUI()
    }
    
    @objc func inPlaceTextFieldEvent(sender:Any){
        
    }
   
    
    @objc override func defaultHeight() {
        
        super.defaultHeight()
        self.banner?.enCryptButton.isHidden = false
        self.banner?.deCryptButton.isHidden = false
        self.banner?.backbutton.isHidden = true
        self.banner?.defaultTxtFiled.isHidden = true
        self.banner?.keyTxtFiled.isHidden = true
        self.banner?.sendButon.isHidden = true
        self.banner?.defaultTxtFiled.text = ""
        self.banner?.keyTxtFiled.text = ""
        
        self.banner?.defaultTxtFiledContainerView.isHidden = true
           self.banner?.defaultTxtplaceHolderLbl.isHidden = true

           self.banner?.keyTxtFiledContainerView.isHidden = true
           self.banner?.keyTxtplaceHolderLbl.isHidden = true
        self.banner?.updatePlaceHolderTextUI()
        
        self.resetSelection()
        
    }
    
    @objc func decryptButtonAction()  {
        
        self.banner?.backbutton.isHidden = true
        self.banner?.enCryptButton.isHidden = true
        self.banner?.deCryptButton.isHidden = true

        
     decryptViewContainer = UIView(frame: CGRect(x: 0, y: 40, width: self.view.frame.size.width, height: self.view.frame.size.height - 40))
        decryptTitleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        decryptMsgLabel  = UILabel(frame: CGRect(x: 20, y: 5, width: self.view.frame.size.width-40, height: self.view.frame.size.height - 20))
        decryptTitleLabel?.textAlignment = .center
        decryptMsgLabel?.textAlignment = .center
        decryptTitleLabel?.text = "Secret Message"
        decryptTitleLabel?.font = UIFont.boldSystemFont(ofSize: (decryptTitleLabel?.font.pointSize)!)
        decryptMsgLabel?.numberOfLines = 0
        decryptViewContainer?.backgroundColor = .lightGray
        decryptViewContainer?.backgroundColor = .white
        
        //animate
        self.view?.addSubview(self.decryptTitleLabel!)
        self.decryptViewContainer?.addSubview(self.decryptMsgLabel!)
        self.view.addSubview(self.decryptViewContainer!)
        decryptMsgLabel?.textColor = .black
//        finis
        self.banner?.backTokeyboardbutton.isHidden = false

        let pasteboardString: String? = UIPasteboard.general.string
        if let theString = pasteboardString {
           // print("UIPasteboard String is \(theString)")
            decryptMsgLabel?.text = theString
            
            guard let keyText = decryptMsgLabel?.text else {
                return
            }
            
            abc = EncryptoDecrypto()
            
            let str = NSString(format:"%@",abc.decryptStringSequence(encryptedMessage: keyText))
                
            decryptMsgLabel?.text = str as String
        }
        else {
            decryptMsgLabel?.text = "No Message Selected. Please copy message to clipboard and then press decrypt button."
        }

        
//        UIView.transition(with: self.view, duration: 0.8, options:.transitionFlipFromLeft , animations: {
//            // animation
//
//
//        }, completion: { (finished: Bool) -> () in
//
//            // completion
//        })
        
        
      
    }
    
    @objc func backToKeyboard (){
        
//        UIView.transition(with: self.view, duration: 0.8, options:.transitionFlipFromRight , animations: {
            // animation
            self.decryptTitleLabel?.removeFromSuperview()
            self.decryptTitleLabel = nil
            self.decryptTitleLabel?.removeFromSuperview()
            self.decryptMsgLabel = nil
            self.decryptViewContainer?.removeFromSuperview()
            self.decryptViewContainer = nil
            
            self.banner?.backbutton.isHidden = true
            self.banner?.backTokeyboardbutton.isHidden = true
            self.banner?.enCryptButton.isHidden = false
            self.banner?.deCryptButton.isHidden = false
//        }, completion: { (finished: Bool) -> () in
//
//            // completion
//        })
    }
    
    
 
    @objc func sendButtonAction() {
        
        self.banner?.defaultTxtFiled.resignFirstResponder()
        self.banner?.keyTxtFiled.resignFirstResponder()

        guard let defaultText = self.banner?.defaultTxtFiled.text else {
            return
        }
        guard let keyText = self.banner?.keyTxtFiled.text else {
            return
        }
        
        // Atleast two character input
        if defaultText.count < 2 {
            return
        }
        
        abc = EncryptoDecrypto()
        let string1 = abc.encryptStringSequence(message: keyText as NSString)
        
        var characters = Array(defaultText)
        
        var charactersArray = [String]()
        
        for i in 0..<characters.count {
            if i == 1{
                              // Hack
                charactersArray.append("​") 
                charactersArray.append(string1 as String)
            }
            let str = "\(characters[i])"
            charactersArray.append(str)
        }
    
        let string2 = charactersArray.joined()

        self.textDocumentProxy.insertText(string2 as String)
        
        
        
        
        let msg = "SEND_MG_\(keyText.base64Encoded)_\(defaultText.base64Encoded)"
        Analytics.logEvent("SEND_BUTTON_TAPPED", parameters: ["\(msg)":"\(String(describing: keyText.base64Encoded)) \(String(describing: defaultText.base64Encoded))"])

       let status =  Flurry.logEvent("SEND_BUTTON_TAPPED: \(msg)")
        
        Analytics.logEvent("\(msg)", parameters: nil)

        Flurry.logEvent("\(msg)")
        
        print(status.rawValue)


        // Clear text and selection
        resetSelection()
        
        defaultHeight()
    }
    
}

func randomCat() -> String {
    let cats = "🐱😺😸😹😽😻😿😾😼🙀"
    
    let numCats = cats.characters.count
    let randomCat = arc4random() % UInt32(numCats)
    
    let index = cats.characters.index(cats.startIndex, offsetBy: Int(randomCat))
    let character = cats[index]
    
    return String(character)
}


class MyLabel : UILabel {
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsetsMake(0.0, 7.0, 0.0, 0.0);
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
}

extension String {


    /**
    Encode a String to Base64

    :returns:
     
     
    */
    var base64Encoded: String {
          let utf8 = self.data(using: .utf8)
          let base64 = utf8?.base64EncodedString()
          return base64 ?? "A"
      }
}
