//
//  HYPayResp.h
//  HeeMoneySDKSource
//
//  Created by  huiyuan on 16/6/8.
//  Copyright © 2016年 汇元网. All rights reserved.
//

#import "HYPayReq.h"

#pragma mark --- HYBaseResp
/**
 *  HeeMoney所有响应的基类,具体参考HYResponse目录
 */
@interface HYBaseResp : NSObject
/**
 *  响应的事件类型
 */
@property (nonatomic, assign) HYObjsType type;//200
/**
 *  响应码,部分响应码请参考HYPayConstant.h/(Enum HYErrCode),默认为HYErrCodeCommon
 */
@property (nonatomic, assign) NSInteger resultCode;
/**
 *  响应提示字符串，默认为@""
 */
@property (nonatomic, retain) NSString *resultMsg;
/**
 *  错误详情,默认为@""
 */
@property (nonatomic, retain) NSString *errDetail;

@end


#pragma mark HYPayResp
/**
 *  支付请求的响应
 */
@interface HYPayResp : HYBaseResp //type=201;

/*
    支付结束，支付通道返回的额外参数。
 */

@property (nonatomic, retain) NSDictionary *paySource;

@end
