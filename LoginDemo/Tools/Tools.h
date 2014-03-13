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

/**
 * @brief 单位换算，吧bytes转换成带指定单位大小
 *
 * @param  bytes：字节数
 *
 * @return 带单位的大小
 */
+(NSString*)convertFileSizeUnitWithBytes:(NSString*)bytes;

///把秒数转换成时间字符串，如：61 => 1'1"
+(NSString*)formateDateStringWithSecond:(int)second;

///过滤json数据，可能出现<NULL>,null,等等情况
+(NSString *)filterValue:(NSString*)value;

///异步请求网络数据
+(void)requestDataWithRequest:(NSURLRequest*)request withSuccess:(void (^)(NSDictionary *dicData))success withFailure:(void (^)(NSError *error))failure;
@end
