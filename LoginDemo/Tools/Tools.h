//
//  Tools.h
//  LoginDemo
//
//  Created by david on 14-2-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Tools
 *
 * Tools常用函数库
 */
@interface Tools : NSObject
/**
 * @brief identifyEmailString:
 *
 * @param  emailstring email字符串
 *
 * @return YES:验证格式通过,NO:验证格式没有通过
 */
+(BOOL)identifyEmailString:(NSString*)emailstring;

///弹出提示信息
+(void)alertMsg:(NSString*)msg;

+(BOOL)requestFailure:(NSError*)error tipMessageBlock:(void(^)(NSString *tipMsg))msg;

/**
 * @brief 检测网络连接类型
 *
 * @param
 *
 * @return networkStatus :ReachableViaWWAN：三G网络，ReachableViaWiFi：wifi网络，NotReachable：无网络
 */
+(void)judgeNetWorkStatus:(void (^)(NSString*networkStatus))networkStatus;

@end
