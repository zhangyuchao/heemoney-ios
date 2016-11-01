//
//  HYUtils.m
//  HeeMoneySDKDemo
//
//  Created by 降瑞雪 on 2016/10/24.
//  Copyright © 2016年  huiyuan. All rights reserved.
//

#import "HYUtils.h"

@implementation HYUtils

+ (MBProgressHUD *)startWaiting:(NSString *)title onViewController:(UIViewController *)viewController
{
    MBProgressHUD * hudView = [[MBProgressHUD alloc] initWithView:viewController.view];
    hudView.labelText = title;
    [hudView showWaiting:YES];
    [viewController.view addSubview:hudView];
    return hudView;

}

//判断参数是否合法，如果不合法，弹出相关信息。
+(void)alertMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

//获取通道类型。
+ (NSString *)getChannelProvider:(PayChannel)channel
{
    NSString *cType = @"";
    switch (channel) {
#pragma mark PayChannel_WX
        case PayChannelWx:
        case PayChannelWxApp:
        case PayChannelWxNative:
        case PayChannelWxJsApi:
        case PayChannelWxScan:
            cType = @"WeiXin";
            break;
#pragma mark PayChannel_ALI
        case PayChannelAli:
        case PayChannelAliApp:
        case PayChannelAliWeb:
        case PayChannelAliWap:
        case PayChannelAliQrCode:
        case PayChannelAliOfflineQrCode:
        case PayChannelAliScan:
            cType = @"AliPay";
            break;
#pragma mark PayChannel_UN
        case PayChannelUn:
        case PayChannelUnApp:
        case PayChannelUnWeb:
            cType = @"UnionPay";
            break;
#pragma mark PayChannel_Baidu
        case PayChannelBaidu:
        case PayChannelBaiduApp:
        case PayChannelBaiduWap:
        case PayChannelBaiduWeb:
            cType = @"BaiFuBao";
            break;
#pragma mark PayChannel_Applepay
        case PayChannelApplePay:
            cType = @"UPApplePay";
            break;
#pragma mark PayChannel_QQWallet
        case PayChannelQQWallet:
            cType = @"QQPay";
        default:
            break;
    }
    return cType;
}

+ (PayChannel)getChannelCode:(NSString *)channelString
{
    PayChannel channel_code = PayChannelNone;
    if ([channelString isEqualToString:@"WX_APP"]) {
        return PayChannelWxApp;
    }
    else if ([channelString isEqualToString:@"ALI_APP"]){
        return PayChannelAliApp;
    }
    else if ([channelString isEqualToString:@"UP_APP"]){
        return PayChannelUnApp;
    }
    else if ([channelString isEqualToString:@"BD_APP"]){
        return PayChannelBaiduApp;
    }
    else if ([channelString isEqualToString:@"AP_APP"]){
        return PayChannelApplePay;
    }
    else if ([channelString isEqualToString:@"QQ_APP"]){
        return PayChannelQQWallet;
    }
    return channel_code;
}

+ (NSString *)getChannelString:(PayChannel)channel
{
    NSString *cType = @"";
    switch (channel) {
#pragma mark PayChannel_WX
        case PayChannelWx:
            cType = @"WX";
            break;
        case PayChannelWxApp:
            cType = @"WX_APP";
            break;
        case PayChannelWxNative:
            cType = @"WX_NATIVE";
            break;
        case PayChannelWxJsApi:
            cType = @"WX_JSAPI";
            break;
        case PayChannelWxScan:
            cType = @"WX_SCAN";
            break;
#pragma mark PayChannel_ALI
        case PayChannelAli:
            cType = @"ALI";
            break;
        case PayChannelAliApp:
            cType = @"ALI_APP";
            break;
        case PayChannelAliWeb:
            cType = @"ALI_WEB";
            break;
        case PayChannelAliWap:
            cType = @"ALI_WAP";
            break;
        case PayChannelAliQrCode:
            cType = @"ALI_QRCODE";
            break;
        case PayChannelAliOfflineQrCode:
            cType = @"ALI_OFFLINE_QRCODE";
            break;
        case PayChannelAliScan:
            cType = @"ALI_SCAN";
            break;
#pragma mark PayChannel_UN
        case PayChannelUn:
            cType = @"UP";
            break;
        case PayChannelUnApp:
            cType = @"UP_APP";
            break;
        case PayChannelUnWeb:
            cType = @"UP_WEB";
            break;
#pragma mark PayChannel_Baidu
        case PayChannelBaidu:
            cType = @"BD";
            break;
        case PayChannelBaiduApp:
            cType = @"BD_APP";
            break;
        case PayChannelBaiduWap:
            cType = @"BD_WAP";
            break;
        case PayChannelBaiduWeb:
            cType = @"BD_WEB";
            break;
        default:
            break;
#pragma mark PayChannel_ApplePay
        case PayChannelApplePay:
            cType = @"AP_APP";
            break;
#pragma mark PayChannel_QQWallet
        case PayChannelQQWallet:
            cType = @"QQ_APP";
            break;
    }
    return cType;
}


+ (NSString *)jsonStringFromObject:(id)object
{
    if([NSJSONSerialization isValidJSONObject:object]){
        
        NSError * error = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        return [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
    }
    else {
        NSLog(@"\n %s--- 不是合法的JSONObject\n",__FUNCTION__);
    }
    return nil;
}

/*获取时间戳*/
+ (NSString *)getTimeStamp
{
    long long t = [[NSDate date] timeIntervalSince1970] * 1000 + 8 * 3600 * 1000;
    NSLog(@"%lld",t);
    NSString * timeStamp = [NSString stringWithFormat:@"%lld",t];
    
    return timeStamp;
}

@end
