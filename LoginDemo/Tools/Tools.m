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

+(BOOL)requestFailure:(NSError*)error tipMessageBlock:(void(^)(NSString *tipMsg))msg{
    if (!error) {
        return NO;
    }
    NSString *tip = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    if (!tip) {
        return NO;
    }
    
    if ([tip isEqualToString:@"The request timed out"]) {
        msg(@"连接网络失败");
        return YES;
    }
    
    if ([tip isEqualToString:@"A connection failure occurred"] || [tip isEqualToString:@"The Internet connection appears to be offline."]) {
        msg(@"当前网络不可用");
        return YES;
    }
    
    if ([tip isEqualToString:@"Could not connect to the server."]) {
        msg(@"无法连接服务器");
        return YES;
    }
    if ([tip isEqualToString:@"Expected status code in (200-299)"]) {
        msg(@"无法连接服务器");
        return YES;
    }
    if ([tip isEqualToString:@"The network connection was lost."]) {
        msg(@"无法连接服务器");
        return YES;
    }
    
    if ([tip isEqualToString:@"未能连接到服务器。"]) {
        msg(@"未能连接到服务器");
        return YES;
    }
    
    if ([tip isEqualToString:@"似乎已断开与互联网的连接。"]) {
        msg(@"无法连接网络");
        return YES;
    }
    return NO;
}

+(void)judgeNetWorkStatus:(void (^)(NSString*networkStatus))networkStatus{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = @"NotReachable";
        Reachability *r = [Reachability reachabilityWithHostName:@"lms.finance365.com"];
        switch ([r currentReachabilityStatus]) {
            case NotReachable:
                str = @"NotReachable";
                break;
            case ReachableViaWWAN:
                str = @"ReachableViaWWAN";
                break;
            case ReachableViaWiFi:
                str = @"ReachableViaWiFi";
                break;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            networkStatus(str);
        });
    });
}

+(NSString*)convertFileSizeUnitWithBytes:(NSString*)bytes{
    int level = 0;
    NSString *convertSize = nil;
    long long size = bytes.longLongValue;
    double lenght = size*1.0;
    while (lenght >= 1024.0) {
        if (level >= 3) {
            break;
        }
        level++;
        lenght = lenght/1024.0;
    }
    
    switch (level) {
        case 0:
            convertSize = [NSString stringWithFormat:@"%0.2fKB",lenght];
            break;
        case 1:
            convertSize = [NSString stringWithFormat:@"%0.2fM",lenght];
            break;
        case 2:
            convertSize = [NSString stringWithFormat:@"%0.2fG",lenght];
            break;
        case 3:
            convertSize = [NSString stringWithFormat:@"%0.2fTB",lenght];
            break;
        default:
            break;
    }
    return convertSize;
}
@end
