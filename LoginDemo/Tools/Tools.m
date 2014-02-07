//
//  Tools.m
//  LoginDemo
//
//  Created by david on 14-2-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "Tools.h"

@implementation Tools
+(BOOL)identifyEmailString:(NSString*)emailstring{
    if (!emailstring || [emailstring isEqualToString:@""]) {
        return NO;
    }
    NSString *regexCall = @"(\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)|(1[0-9]{10})";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    return [predicateCall evaluateWithObject:emailstring];
}

+(void)alertMsg:(NSString*)msg{
    if (!msg || [msg isEqualToString:@""]) {
        return;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
@end
