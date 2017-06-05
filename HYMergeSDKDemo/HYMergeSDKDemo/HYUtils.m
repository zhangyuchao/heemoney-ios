//
//  HYUtils.m
//  HYMergeSDKDemo
//
//  Created by 降瑞雪 on 2017/5/24.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import "HYUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation HYUtils

//判断是否为空
+ (BOOL)isNullOrEmpty:(NSString *)str
{
    if (!str) {
        return YES;
    }
    else if ([str isEqual:[NSNull null]]){
        
        return YES;
    }
    else {
        NSString *trimedString = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if ([trimedString length] == 0) {
            return YES;
        }
        else {
            return NO;
        }
    }
}

+(NSString *)getSystemTimeString
{
    NSDate * data = [NSDate date];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSString * timeString = [formatter stringFromDate:data];
    return timeString;
}

+(NSString *) md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest );
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02X", digest[i]];
    
    return output;
}

+(NSString *)getTimeStamp
{
    /*
     
     这里需要注意一下：[[NSDate date] timeIntervalSince1970] 返回来的时间是 秒，需要进行转换成 毫秒 * 1000 + 时区8小时。
     
     */
    long long t = [[NSDate date] timeIntervalSince1970] * 1000 + 8 * 3600 * 1000;
    NSString * timeStamp = [NSString stringWithFormat:@"%lld",t];
    return timeStamp;
    
}

+(NSString*)encodeURLString:(NSString*)unencodedString
{
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)unencodedString, NULL, nil, kCFStringEncodingUTF8));
    return outputStr;
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

+ (id)objectFromJSONString:(NSString *)jsonString
{
    if(!jsonString || jsonString.length <= 0){
        return nil;
    }
    NSError * error = nil;
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    return dic;
}


+(NSString *)getChannelString:(HYPayChannel)channelCode
{
    if (channelCode == HYPayChannelWxApp) {
        return @"WX_APP";
    }
    else if (channelCode == HYPayChannelWxJsApi){
        return @"WX_JSAPI";
    }
    else if (channelCode == HYPayChannelWxNative){
        return @"WX_NATIVE";
    }
    else if (channelCode == HYPayChannelWxH5){
        return @"WX_H5";
    }
    else if (channelCode == HYPayChannelWxScan){
        return @"WX_MICROPAY";
    }
    else if (channelCode == HYPayChannelApplePay){
        return @"AP_APP";
    }
    else if (channelCode == HYPayChannelBaiduQrCode){
        return @"BD_QRCODE";
    }
    else if (channelCode == HYPayChannelBaiduWap){
        return @"BD_WAP";
    }
    else if (channelCode == HYPayChannelBaiduApp){
        return @"BD_APP";
    }
    else if (channelCode == HYPayChannelUnQrCode){
        return @"UP_QRCODE";
    }
    else if (channelCode == HYPayChannelUnWap){
        return @"UP_WAP";
    }
    else if (channelCode == HYPayChannelUnApp){
        return @"UP_APP";
    }
    else if (channelCode == HYPayChannelQQAPP){
        return @"QQ_APP";
    }
    else if (channelCode == HYPayChannelQQQrCode){
        return @"QQ_QRCODE";
    }
    else if (channelCode == HYPayChannelQQWap){
        return @"QQ_WAP";
    }
    else if (channelCode == HYPayChannelAliQrCode){
        return @"ALI_QRCODE";
    }
    else if (channelCode == HYPayChannelAliWap){
        return @"ALI_WAP";
    }
    else if (channelCode == HYPayChannelAliApp){
        return @"ALI_APP";
    }
    else if (channelCode == HYPayChannelAliScan){
        return @"ALI_Bar_Code";
    }
    else if (channelCode == HYPayChannelJingDongQrCode){
        return @"JD_QRCODE";
    }
    else if (channelCode == HYPayChannelJingDongWAP){
        return @"JD_WAP";
    }
    else if (channelCode == HYPayChannelYiBaoQrCode){
        return @"YEE_QRCODE";
    }
    else if (channelCode == HYPayChannelYiBaoWAP){
        return @"YEE_WAP";
    }
    return @"未知的通道类型";
}

@end
