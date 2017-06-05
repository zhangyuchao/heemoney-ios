//
//  HeeMoney.h
//  HeeMoneySDKSource
//
//  Created by  huiyuan on 16/6/8.
//  Copyright © 2016年 汇元网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HYPayResp.h"

#pragma mark --- HeeMoneyDelegate

@protocol HYMergepayDelegate <NSObject>

@required
/**
 *  不同类型的请求，对应不同的响应
 *  @param resp 响应体
 */
-(void)onMergepayResp:(HYPayResp *)resp;

@end

#pragma mark --- HeeMoney
@interface HYMergepayManager : NSObject

//获取终端信息，此信息用于商户服务器下单接口中的terminal_info字段的传值。
+ (NSString *)getTerminalInfos;

/**
 * 处理通过URL启动App时传递的数据。需要在application:openURL:sourceApplication:annotation:中调用。
 *
 * @param url 启动第三方应用时传递过来的URL
 *
 * @return 成功返回YES，失败返回NO。
 */
+ (BOOL)handleOpenUrl:(NSURL *)url;


/**
 *  设置开启或关闭沙箱测试环境
 *
 *  @param sandbox YES表示开启沙箱、关闭生产环境，并请确保已经初始化沙箱环境；NO表示关闭沙箱环境、开启生产环境，并确保已经初始化生产环境
 */
+ (void)setSandboxMode:(BOOL)sandbox;

/**
 *  如果是sandbox环境，返回YES；
 *  如果是live环境，返回NO；
 *
 *  @return YES表示当前是沙箱测试环境
 */
+ (BOOL)getCurrentMode;

/**
 *  判断手机是否支持Apple Pay；商户可以根据此方法返回的值来决定是否显示Apple Pay的支付图标
 *
 *  @param cardType  0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；
 *  @return YES表示支持
 */
+ (BOOL)canMakeApplePayments:(NSUInteger)cardType;

/*
 * 调用手机摄像头，扫描二维码。
 * completeBlock: 扫描结束的回调。
 * content:扫描到的内容。如果hasError == YES，此内容为错误描述。
 * hasError: 本次扫码是否出现错误。
 */

+ (void)openQRScanningWithViewController:(UIViewController *)viewController completeBlock:(void(^)(NSString *content))completeBlock;

/*
 * 跳转到绑定银行卡的钱包页面
 */
+(void)openPaymentSetup;


/**
 *  获取API版本号
 *
 *  @return 版本号
 */
+ (NSString *)getHYApiVersion;

/**
 *  设置是否打印log
 *
 *  @param flag YES打印
 */
+ (void)setWillPrintLog:(BOOL)flag;

#pragma mark - Send HeeMoney Request

/**
 *  发送HeeMoney Request请求
 *
 *  @param req 请求体
 *
 *  @return 发送请求是否成功
 */
+ (BOOL)sendHYReq:(HYPayReq *)req delegate:(id<HYMergepayDelegate>) delegate;

@end
