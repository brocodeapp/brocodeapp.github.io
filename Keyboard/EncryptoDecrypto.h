//
//  EncryptoDecrypto.h
//  Keyboard
//
//  Created by Aniruddha Kadam on 28/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptoDecrypto : NSObject
{
    NSString * oneBit;
    NSString * zeroBit;
    NSString * startingSequence;
    NSString * startingDSequence;


}

@property (nonatomic,assign) NSString * zerobitString;

@property (nonatomic,assign) NSString * decryptStr;

- (NSString *)encryptStringSequence:(NSString *)stringValue;
- (NSString *)decryptStringSequence:(NSString *)encryptyString;

@end
