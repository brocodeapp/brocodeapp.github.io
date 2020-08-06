//
//  NSStringEntention.m
//  SphinxEncryptor
//
//  Created by Aniruddha Kadam on 31/03/18.
//  Copyright © 2018 Aniruddha Kadam. All rights reserved.
//

#import "NSStringEntention.h"

@implementation NSString (ConvertToArray)

-(NSArray *)convertToArray
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i=0; i < self.length; i++) {
        NSString *tmp_str = [self substringWithRange:NSMakeRange(i, 1)];
        [arr addObject:[tmp_str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return arr;
}

@end
