//
//  WebRequest.h
//  HeeMoneySDKSource
//
//  Created by 降瑞雪 on 2017/2/16.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^WebRequestCompleteBlock)(NSString * charge,BOOL hasError);
@interface WebRequest : NSObject

@property (nonatomic,strong) WebRequestCompleteBlock complete;

+ (void)sendRequestWithPaymentFee:(NSString *)paymentFee paymentType:(NSUInteger)pay_type completeBlock:(WebRequestCompleteBlock) complete;

@end

