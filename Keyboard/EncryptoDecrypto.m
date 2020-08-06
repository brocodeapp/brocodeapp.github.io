//
//  EncryptoDecrypto.m
//  Keyboard
//
//  Created by Aniruddha Kadam on 28/03/18.
//  Copyright © 2018 Apple. All rights reserved.
//

#import "EncryptoDecrypto.h"
#import "NSStringEntention.h"

@implementation EncryptoDecrypto

- (instancetype)init {
    self = [super init];
    if (self) {
        oneBit = @"​";
        zeroBit = @""; //@"‍";
        _zerobitString = [NSString stringWithFormat:@"%@",zeroBit];
        startingSequence = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@ ",zeroBit,zeroBit,zeroBit,zeroBit,zeroBit,zeroBit,zeroBit,zeroBit,zeroBit,zeroBit];
        startingDSequence = @"0000000000";
    }
    return self;
}

- (NSString *)encryptStringSequence:(NSString *)stringValue
{
  NSString *  newString = [NSString stringWithFormat:@"%@%@%@",startingSequence,[self encryptString:stringValue],startingSequence];
    NSLog(@"%@",newString);
    return newString;
}

- (NSString *)decryptStringSequence:(NSString *)encryptyString
{
    NSString * encString = [NSString stringWithFormat:@"%@",encryptyString];
    
    if ([encString containsString:startingSequence]) {
        NSArray * strArray = [encString componentsSeparatedByString:startingSequence];
        if (strArray.count == 3) {
            NSString * str = [strArray objectAtIndex:1];
            NSString * decryptString =  [self decodeString:str];
            return decryptString;
        }
    }
    return @"No Secret Message Found";
}

- (NSString *)encryptString:(NSString *)secretString {
    const char *unencoded = [secretString UTF8String];
    
    int  cnt;
    cnt = 9;
    long length = secretString.length;
    length = length * 8;
    
    NSMutableArray *encoded = [[NSMutableArray alloc] initWithCapacity:length];
    
    NSMutableArray *unencodedArray = [[NSMutableArray alloc] init];
    
    while ( *unencoded ){
        NSString * hexstr = [NSString stringWithFormat:@"%d",*unencoded++];
        [unencodedArray addObject:hexstr];
    }
    NSLog(@"%@",unencodedArray);
    
    for (int i = 0; i < secretString.length; i++) {
        NSInteger unEncodedValue = [[unencodedArray objectAtIndex:i] integerValue];
        
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
        
    }
    
    NSMutableString * encryptedString = [[NSMutableString alloc] init];
    for (int j = 0; j < encoded.count; j++) {
        [encryptedString appendString:[encoded objectAtIndex:j]];
    }
    
    
    NSLog(@"OutputString:[%@]", [self decodeString:encryptedString]);
    
    return encryptedString;
}

- (NSString *)decodeString:(NSString *)encyString
{
    NSString * newStr = [NSString stringWithFormat:@"%@",encyString];
    NSMutableArray *decodedUTF8 = [[NSMutableArray alloc] initWithCapacity:newStr.length/8];
    
    for (int i = 0; i < encyString.length/8; i++) {
        NSNumber * num = [NSNumber numberWithInteger:0];
        [decodedUTF8 addObject:num];
    }
    
    Byte decodedUTF8AA[newStr.length/8];
    for (int i = 0; i < newStr.length/8; i++) {
        decodedUTF8AA[i] = 0;
    }
    
    NSArray * encryptedCharArray = [newStr convertToArray];
    
    int i = 0;
    while (i < encryptedCharArray.count) {
        long tempValue = decodedUTF8AA[i / 8];
        NSString * binArry = encryptedCharArray[i];
        if (i % 8 == 0) {
            if ([binArry isEqualToString:oneBit]) {
                decodedUTF8AA[i / 8] = (tempValue | -128);
            }
        } else if (i % 8 == 1) {
            if ([binArry isEqualToString:oneBit]) {
                decodedUTF8AA[i / 8] = (tempValue | 64);
            }
        } else if (i % 8 == 2) {
            if ([binArry isEqualToString:oneBit]) {
                decodedUTF8AA[i / 8] = (tempValue | 32);
            }
        } else if (i % 8 == 3) {
            if ([binArry isEqualToString:oneBit]) {
                decodedUTF8AA[i / 8] =  (tempValue | 16);
            }
        } else if (i % 8 == 4) {
            if ([binArry isEqualToString:oneBit]) {
                decodedUTF8AA[i / 8] =  (tempValue | 8);
            }
        } else if (i % 8 == 5) {
            if ([binArry isEqualToString:oneBit]) {
                decodedUTF8AA[i / 8] =  (tempValue | 4);
            }
        } else if (i % 8 == 6) {
            if ([binArry isEqualToString:oneBit]) {
                decodedUTF8AA[i / 8] =  (tempValue | 2);
            }
        } else if (i % 8 == 7 && [binArry isEqualToString:oneBit]) {
            decodedUTF8AA[i / 8] =  (tempValue | 1);
        }
        i++;
    }
    
    NSString * decipheredString = [[NSString alloc] initWithBytes:decodedUTF8AA
                                                           length:newStr.length/8
                                                         encoding:NSUTF8StringEncoding];
    NSLog(@"%@",decipheredString);
    return decipheredString;
}

@end
