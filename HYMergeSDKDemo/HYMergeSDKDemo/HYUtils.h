//
//  HYUtils.h
//  HYMergeSDKDemo
//
//  Created by 降瑞雪 on 2017/5/24.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPayReq.h"

@interface HYUtils : NSObject
+ (BOOL)isNullOrEmpty:(NSString *)str;
+(NSString *)getSystemTimeString;
+(NSString *) md5:(NSString *)str;
+(NSString *)getTimeStamp;
+(NSString*)encodeURLString:(NSString*)unencodedString;
+ (NSString *)jsonStringFromObject:(id)object;
+ (id)objectFromJSONString:(NSString *)jsonString;
+(NSString *)getChannelString:(HYPayChannel)channelCode;

@end
