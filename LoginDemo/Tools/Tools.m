//
//  Tools.m
//  LoginDemo
//
//  Created by david on 14-2-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "Tools.h"
@interface Tools()
@property (nonatomic,strong) UIAlertView *alert;
+(Tools*)defaultTools;
@end

@implementation Tools
+(Tools*)defaultTools{
    static Tools *defaultTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultTool = [[Tools alloc] init];
    });
    return defaultTool;
}

+(NSString*)formateDateStringWithSecond:(int)second{
    int temp = second;
    int level = 2;
    NSMutableString *date = [[NSMutableString alloc] init];
    while (level > 0) {
        if (temp/(int)pow(60, level) <= 0) {
            level--;
            continue;
        }
        switch (level) {
            case 2:
                [date appendFormat:@"%d ",temp/(int)pow(60, level)];
                break;
            case 1:
                [date appendFormat:@"%d' ",temp/(int)pow(60, level)];
                break;
            default:
                break;
        }
        temp = temp%(int)pow(60, level);
        level--;
    }
    [date appendFormat:@"%d\" ",temp];
    return date.lowercaseString;
}

+(NSString *)filterValue:(NSString*)filterValue{
    NSString *value = [NSString stringWithFormat:@"%@",filterValue];
    if ([value isEqualToString:@""] || [value isEqualToString:@"<NULL>"] || [value isEqualToString:@"null"] || [value isEqualToString:@"<null>"]) {
        return nil;
    }
    return value;
}

///异步请求网络数据
+(void)requestDataWithRequest:(NSURLRequest*)request withSuccess:(void (^)(NSDictionary *dicData))success withFailure:(void (^)(NSError *error))failure{
    if (!request) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        DLog(@"%@,%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        if (error) {
            [Tools requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": tipMsg}]);
                    }
                });
            }];
            
            return ;
        }
        
        NSError *jsonError = nil;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (!dicData || dicData.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取空数据"}]);
                }
            });
            return ;
        }
        
        
        if (![dicData objectForKey:@"status"] || [[dicData objectForKey:@"status"] isEqualToString:@"error"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg": [dicData objectForKey:@"notice"]?:@"获取数据失败"}]);
                }
            });
            return;
        }
        
        if (success) {
            success(dicData);
        }
    });
}

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
    if ([Tools defaultTools].alert != nil) {
        UIAlertView *alert = [Tools defaultTools].alert;
        [alert dismissWithClickedButtonIndex:0 animated:NO];
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
