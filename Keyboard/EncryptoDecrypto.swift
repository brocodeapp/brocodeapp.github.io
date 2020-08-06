////
////  EncryptoDecrypto.swift
////  Keyboard
////
////  Created by Aniruddha Kadam on 02/04/18.
////  Copyright © 2018 Apple. All rights reserved.
////
//
import Foundation



class EncryptoDecrypto: NSObject {
   
    var oneBit = "1"
    var zeroBit = "0"
    var startingSequence = ""
    
    let bro_code = "broC_anispy211ode"
    let salt = "tEi1H3E1aj26XNro1".data(using: .utf8)!
    let iv = "tEi1H3E1aj26XNro".data(using: .utf8)!
    
    
    override init() {
        super.init()
        oneBit = "​"
        zeroBit = "‌"
        startingSequence = "\(oneBit)\(zeroBit)\(zeroBit)\(zeroBit)\(zeroBit)\(zeroBit)\(zeroBit)\(zeroBit)\(zeroBit)\(zeroBit)"
        startingSequence = startingSequence.trimmingCharacters(in: .whitespaces)
    }
    
    func encryptStringSequence(message : NSString) -> NSString {
        
        let encrptedMessage = encryptmessage(secretmessage: message as String)
        
        let encryptedSequenceString = encrptedMessage + startingSequence
        
        return encryptedSequenceString as NSString
    }
    
    
    func decryptStringSequence(encryptedMessage : String) -> String {
        
        let message  = String(format:"%@",encryptedMessage)
        
        if message.contains(startingSequence) {
            let characters = Array(message)
           
            var charactersArray = [String]()
            
            for i in 0..<characters.count {
                if i > 1{
                    let str = "\(characters[i])"
                    charactersArray.append(str)
                }
            }
            
            let newMessage = charactersArray.joined()

            
            if let index = newMessage.range(of: startingSequence)?.lowerBound {
                let substring = newMessage[..<index]
                let string = String(substring)
                let decodedString = decryptMessage(encodedMessage: string) as String
                
                return decodedString
            }
        }
        
        return "No Message Found"
    }
    
    
    func encryptmessage(secretmessage : String) -> String {
                
        let utf8String = secretmessage.cString(using: .utf8)
        
        let encoded = NSMutableArray(capacity: secretmessage.count * 8)
        
      //  print("\n"+"Hi buddy:  \(secretmessage.count)")
        
        var i = 0
        while i < secretmessage.count {
          //  print("\n"+"Hi buddy:  \(i)")
            
            let unEncodedValue:UInt32 = UInt32(utf8String![i])
            
            if ((unEncodedValue & 128) == 128) {
                encoded[i * 8] = oneBit;
            } else {
                encoded[i * 8] = zeroBit;
            }
            if ((unEncodedValue & 64) == 64) {
                encoded[(i * 8) + 1] = oneBit;
            } else {
                encoded[(i * 8) + 1] = zeroBit;
            }
            if ((unEncodedValue & 32) == 32) {
                encoded[(i * 8) + 2] = oneBit;
            } else {
                encoded[(i * 8) + 2] = zeroBit;
            }
            if ((unEncodedValue & 16) == 16) {
                encoded[(i * 8) + 3] = oneBit;
            } else {
                encoded[(i * 8) + 3] = zeroBit;
            }
            if ((unEncodedValue & 8) == 8) {
                encoded[(i * 8) + 4] = oneBit;
            } else {
                encoded[(i * 8) + 4] = zeroBit;
            }
            if ((unEncodedValue & 4) == 4) {
                encoded[(i * 8) + 5] = oneBit;
            } else {
                encoded[(i * 8) + 5] = zeroBit;
            }
            if ((unEncodedValue & 2) == 2) {
                encoded[(i * 8) + 6] = oneBit;
            } else {
                encoded[(i * 8) + 6] = zeroBit;
            }
            if ((unEncodedValue & 1) == 1) {
                encoded[(i * 8) + 7] = oneBit;
            } else {
                encoded[(i * 8) + 7] = zeroBit;
            }
            
            i += 1
        }
        
        var newEncoded = [String]()
        for character in encoded {
            newEncoded.append(character as! String)
        }
        
        
        var finaleEncryptedMessage : String = ""
        finaleEncryptedMessage = newEncoded.joined()
        
        return finaleEncryptedMessage
    }
    
    
    func decryptMessage ( encodedMessage : String) -> String {
        let encryptedMessage = String(format:"%@",encodedMessage)
        
      //  let newString = NSString(format:"%@",encodedMessage)
        
        let encryptedCharArray:NSArray = encodedMessage.convertToArray()! as NSArray
        
//        for thisChar in newString {
//            encryptedCharArray.append(thisChar)
//        }
       
        
        let messageCount = encodedMessage.unicodeScalars.count
        
        var byteArray = [Int]()
        let count = messageCount/8
        for var index in 0..<count {
            byteArray.append(0)
            index = index+1
        }
        
       // print("encryptedMessage: \(encryptedMessage) : \(encryptedCharArray.count)")
        
        var i = 0
        while i < encryptedCharArray.count {
            let tempValue = byteArray [i/8] // TO DO: Check size before accessing
            let binArry1 = encryptedCharArray[i]
            
            let binArry = String(describing: binArry1)
            
            if (i % 8 == 0) {
                if binArry == oneBit {
                    // let integerValue : UInt64 = (tempValue | -128)
                    byteArray [i/8] = (tempValue | -128)
                }
            } else if (i % 8 == 1) {
                if binArry == oneBit {
                    let integerValue = (tempValue | 64);
                    byteArray[i / 8] = integerValue
                }
            } else if (i % 8 == 2) {
                if binArry == oneBit {
                    let integerValue = (tempValue | 32)
                    byteArray[i / 8] = integerValue
                }
            } else if (i % 8 == 3) {
                if binArry == oneBit {
                    let integerValue =  (tempValue | 16);
                    byteArray[i / 8] = integerValue
                }
            } else if (i % 8 == 4) {
                if binArry == oneBit {
                    let integerValue =  (tempValue | 8);
                    byteArray[i / 8] = integerValue
                }
            } else if (i % 8 == 5) {
                if binArry == oneBit {
                    let integerValue =  (tempValue | 4);
                    byteArray[i / 8] = integerValue
                }
            } else if (i % 8 == 6) {
                if binArry == oneBit {
                    let integerValue =  (tempValue | 2);
                    byteArray[i / 8] = integerValue
                }
            } else if (i % 8 == 7 && (binArry == oneBit)) {
                let integerValue =  (tempValue | 1);
                byteArray[i / 8] = integerValue
            }
            
            i += 1
        }
        
      //  print("Decoded Message: \(byteArray) ")
        
        var stringArray = [String]()
        for value in byteArray {
            stringArray.append(String(format:"%c",value))
        }
        
      //  print("stringArray Message: \(stringArray.joined()) ")
        let decryptMessage = stringArray.joined()
        return decryptMessage
    }
    
}



