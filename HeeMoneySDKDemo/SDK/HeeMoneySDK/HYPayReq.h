//
//  HYPayReq.h
//  HeeMoneySDKSource
//
//  Created by  huiyuan on 16/6/8.
//  Copyright © 2016年 汇元网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PayChannel) {
    PayChannelNone = 0,
    
    PayChannelWx = 10, //微信
    PayChannelWxApp,//微信APP
    PayChannelWxNative,//微信扫码
    PayChannelWxJsApi,//微信JSAPI(H5)
    PayChannelWxScan,
    
    PayChannelAli = 20,//支付宝
    PayChannelAliApp,//支付宝APP
    PayChannelAliWeb,//支付宝网页即时到账
    PayChannelAliWap,//支付宝手机网页
    PayChannelAliQrCode,//支付宝扫码即时到帐
    PayChannelAliOfflineQrCode,//支付宝线下扫码
    PayChannelAliScan,
    
    PayChannelUn = 30,//银联
    PayChannelUnApp,//银联APP
    PayChannelUnWeb,//银联网页
    PayChannelApplePay,
    
    PayChannelBaidu = 40,//百度
    PayChannelBaiduApp,//百度钱包app
    PayChannelBaiduWeb,//百度网页
    PayChannelBaiduWap,
    
    PayChannelQQWallet = 50 //QQ钱包
};

typedef NS_ENUM(NSInteger, HYErrCode) {
    HYErrCodeSuccess    = 0,    /**< 成功    */
    HYErrCodeCommon     = -1,   /**< 参数错误类型    */
    HYErrCodeUserCancel = -2,   /**< 用户点击取消并返回    */
    HYErrCodeSentFail   = -3,   /**< 发送失败    */
    HYErrCodeUnsupport  = -4,   /**< HeeMoney不支持 */
    HYErrCodeDealing    = -5,   /**< 支付处理中 */
};

typedef NS_ENUM(NSInteger, HYObjsType) {
    HYObjsTypeBaseReq = 100,
    HYObjsTypePayReq,
    
    HYObjsTypeBaseResp = 200,
    HYObjsTypePayResp,
    
    HYObjsTypeBaseResults = 300,
    HYObjsTypeBillResults,
};


#pragma mark --- HYBaseReq
/**
 *  所有请求事件的基类,具体请参考HYRequest目录
 */
@interface HYBaseReq : NSObject
/**
 *  请求事件类型
 */
@property(nonatomic, assign) HYObjsType type;//100

@end


#pragma mark HYPayReq
/**
 *  Pay Request请求结构体
 */
@interface HYPayReq : HYBaseReq

/**
 *  调用支付的app注册在info.plist中的scheme,支付宝支付必填
 */
@property (nonatomic, retain) NSString *scheme;

/**
 *  银联支付或者Sandbox环境必填
 */
@property (nonatomic, retain) UIViewController *viewController;


/**
 *   支付对象。在通道下单成功之后返回。
 */
@property (nonatomic,retain) NSString * charge;
#pragma mark - Functions

/**
 *  发起支付(微信、支付宝、银联、百度钱包、Apple pay)
 */
- (void)payReq;

@end
