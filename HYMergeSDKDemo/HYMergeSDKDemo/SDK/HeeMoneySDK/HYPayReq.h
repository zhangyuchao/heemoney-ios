//
//  HYPayReq.h
//  HeeMoneySDKSource
//
//  Created by  huiyuan on 16/6/8.
//  Copyright © 2016年 汇元网. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HYPayChannel) {
    HYPayChannelNone = 0,

    HYPayChannelWxNative = 100, //微信扫码
    HYPayChannelWxJsApi,//微信公众号
    HYPayChannelWxH5,//微信H5
    HYPayChannelWxApp,//微信APP
    HYPayChannelWxScan,//微信刷卡
    
    HYPayChannelAliQrCode = 200,//支付宝扫码
    HYPayChannelAliWap,//支付宝手机网页
    HYPayChannelAliApp = 203,//支付宝APP
    HYPayChannelAliScan, //支付宝刷卡
    
    HYPayChannelQQQrCode = 300, //QQ扫码
    HYPayChannelQQWap, //QQ WAP
    HYPayChannelQQAPP = 303, //QQ钱包

    HYPayChannelUnQrCode = 400,//银联扫码
    HYPayChannelUnWap,//银联WAP
    HYPayChannelUnApp = 403,//银联APP
    
    HYPayChannelBaiduQrCode = 500,//百度扫码
    HYPayChannelBaiduWap,//百度WAP
    HYPayChannelBaiduApp = 503,//百度钱包app
    
    HYPayChannelJingDongQrCode = 510,//京东扫码
    HYPayChannelJingDongWAP,//京东WAP
    
    HYPayChannelYiBaoQrCode = 520,//易宝扫码
    HYPayChannelYiBaoWAP ,//易宝WAP

    HYPayChannelApplePay = 600, //Apple 支付
};

typedef NS_ENUM(NSInteger, HYPayResultCode) {
    
    HYPayResultSuccess     = 0,    /**< 成功    */
    HYPayResultFail        = -1,    //支付失败
    HYPayResultCancel      = -2,   /**< 取消支付   */
    HYPayResultError       = -3,   /**< 支付出错  */
    HYPayResultDealing     = -4,    //单据处理中
    HYPayResultUnkown      = -5,   /**< 未知的支付类型。*/
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
 *  银联、ApplePay、百度支付或者Sandbox环境必填
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
