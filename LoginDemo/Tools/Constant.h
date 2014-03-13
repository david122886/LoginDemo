//
//  Constant.h
//  LoginDemo
//
//  Created by david on 14-2-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

#if 1
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif