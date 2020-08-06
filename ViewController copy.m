//
//  ViewController.m
//  SphinxEncryptor
//
//  Created by Aniruddha Kadam on 31/03/18.
//  Copyright © 2018 Aniruddha Kadam. All rights reserved.
//

#import "ViewController.h"
#import <stdio.h>
#import "NSStringEntention.h"

@interface ViewController ()
{
    NSString * oneBit ;
    NSString * zerobit ;
}
- (IBAction)encryptButtonClicked:(id)sender;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    oneBit = @"​";
    
    oneBit = @"1";

    
    NSScanner *scan = [[NSScanner alloc] initWithString:@"U+001D"];
    unsigned int val;
    [scan scanHexInt:&val];
    char cc[4];
    cc[3] = (val >> 0) & 0xFF;
    cc[2] = (val >> 8) & 0xFF;
    cc[1] = (val >> 16) & 0xFF;
    cc[0] = (val >> 24) & 0xFF;
    zerobit = [[NSString alloc]
                   initWithBytes:cc
                   length:4
                   encoding:NSUTF32StringEncoding];
    
    
    zerobit = @"‍";
    zerobit = @"0";

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)encryptButtonClicked:(id)sender {
    
    [self encryptString:@"Hi Anispy"];
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
            encoded[i * 8] = zerobit;
        }
        if ((unEncodedValue & 64) == 64) {
            encoded[(i * 8) + 1] = oneBit;
        } else {
            encoded[(i * 8) + 1] = zerobit;
        }
        if ((unEncodedValue & 32) == 32) {
            encoded[(i * 8) + 2] = oneBit;
        } else {
            encoded[(i * 8) + 2] = zerobit;
        }
        if ((unEncodedValue & 16) == 16) {
            encoded[(i * 8) + 3] = oneBit;
        } else {
            encoded[(i * 8) + 3] = zerobit;
        }
        if ((unEncodedValue & 8) == 8) {
            encoded[(i * 8) + 4] = oneBit;
        } else {
            encoded[(i * 8) + 4] = zerobit;
        }
        if ((unEncodedValue & 4) == 4) {
            encoded[(i * 8) + 5] = oneBit;
        } else {
            encoded[(i * 8) + 5] = zerobit;
        }
        if ((unEncodedValue & 2) == 2) {
            encoded[(i * 8) + 6] = oneBit;
        } else {
            encoded[(i * 8) + 6] = zerobit;
        }
        if ((unEncodedValue & 1) == 1) {
            encoded[(i * 8) + 7] = oneBit;
        } else {
            encoded[(i * 8) + 7] = zerobit;
        }
        
    }
    
    NSMutableString * encryptedString = [[NSMutableString alloc] init];
    for (int j = 0; j < encoded.count; j++) {
        [encryptedString appendString:[encoded objectAtIndex:j]];
    }

    NSLog(@"OutputString:[%@]", encryptedString);
    
    
//    NSString *str = @"01100010 01110010 01101001 01100001 01101110 00110001 00110010 00110011";

    [self decodeString:encryptedString];

    return encryptedString;
}

- (NSString *)decodeString:(NSString *)encryptedString
{
    NSMutableArray *decodedUTF8 = [[NSMutableArray alloc] initWithCapacity:encryptedString.length/8];

    for (int i = 0; i < encryptedString.length/8; i++) {
        NSNumber * num = [NSNumber numberWithInteger:0];
        [decodedUTF8 addObject:num];
    }
    
    Byte decodedUTF8AA[encryptedString.length/8];
    for (int i = 0; i < encryptedString.length/8; i++) {
        decodedUTF8AA[i] = 0;
    }
    
   // Byte decodedUTF8AA[encryptedString.length/8] = "";
    
    
    NSArray * encryptedCharArray = [encryptedString convertToArray];
//    NSString * secretMSg = stringFromBinString(encryptedString);
//    NSLog(@"Orignal Msg: %@",secretMSg);
    
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

    NSLog(@"%c",decodedUTF8[0]);
    NSLog(@"%c",decodedUTF8[1]);
    NSLog(@"%c",decodedUTF8[2]);
    NSLog(@"%c",decodedUTF8[3]);
    NSLog(@"%c",decodedUTF8[4]);
    NSLog(@"%c",decodedUTF8[5]);
    NSLog(@"%c",decodedUTF8[6]);
    NSLog(@"%c",decodedUTF8[7]);
    NSLog(@"%c",decodedUTF8[8]);
    
    NSData * data = [NSData dataWithBytesNoCopy:decodedUTF8AA length:9 freeWhenDone:NO];
    NSString * newSring = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",newSring);


    NSString * utfStr = [[NSString alloc] initWithBytes:decodedUTF8AA
                                                 length:9
                                               encoding:NSUTF8StringEncoding];

    NSLog(@"String: %@",utfStr);

    
    
    return @"";
}


NSString* stringFromBinString(NSString* binString) {
    NSArray *tokens = [binString componentsSeparatedByString:@" "];
    char *chars = malloc(sizeof(char) * ([tokens count] + 1));
    
    for (int i = 0; i < [tokens count]; i++) {
        const char *token_c = [[tokens objectAtIndex:i] cStringUsingEncoding:NSUTF8StringEncoding];
        char val = (char)strtol(token_c, NULL, 2);
        chars[i] = val;
    }
    chars[[tokens count]] = 0;
    NSString *result = [NSString stringWithCString:chars
                                          encoding:NSUTF8StringEncoding];
    
    free(chars);
    return result;
}


@end


