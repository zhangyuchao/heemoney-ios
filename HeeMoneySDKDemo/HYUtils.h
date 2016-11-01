//
//  HYUtils.h
//  HeeMoneySDKDemo
//
//  Created by 降瑞雪 on 2016/10/24.
//  Copyright © 2016年  huiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYPayReq.h"
#import "MBProgressHUD.h"

@interface HYUtils : NSObject

+ (NSString *)getTimeStamp;
+ (NSString *)jsonStringFromObject:(id)object;
+ (NSString *)getChannelString:(PayChannel)channel;
+ (PayChannel)getChannelCode:(NSString *)channelString;
+ (NSString *)getChannelProvider:(PayChannel)channel;
+ (void)alertMsg:(NSString *)msg;
+ (MBProgressHUD *)startWaiting:(NSString *)title onViewController:(UIViewController *)viewController;

@end
