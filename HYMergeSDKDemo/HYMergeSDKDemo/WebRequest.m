//
//  WebRequest.m
//  HeeMoneySDKSource
//
//  Created by 降瑞雪 on 2017/2/16.
//  Copyright © 2017年 汇元网. All rights reserved.
//

#import "WebRequest.h"
#import "OrderModel.h"
#import <CommonCrypto/CommonDigest.h>
#import "HYMergepayManager.h"
#import "HYUtils.h"

#define kMchUid                   @"4945892094734" //线上地址对应参数
#define kApp_id                   @"hyp17041449458900000057698DAAB00" //线上地址对应参数
#define kMD5Key                   @"5454778B83484969ACFB20BA"   //线上地址对应参数
#define  kPayInitURL              @"https://pay.heemoney.com/v1/ApplyPay"  //线上地址


@interface WebRequest ()

@property (nonatomic,copy) NSDictionary * bizParmas;
@end

@implementation WebRequest

+ (void)sendRequestWithPaymentFee:(NSString *)paymentFee paymentType:(NSUInteger)pay_type completeBlock:(WebRequestCompleteBlock)complete
{
    OrderModel * payModel = [[OrderModel alloc] init];
    
    //业务参数。
    payModel.out_trade_no = [HYUtils getSystemTimeString];
    payModel.subject = @"iPhone 7p";
    payModel.total_fee = paymentFee;
    payModel.timeout_express = @"6";
    payModel.client_ip = @"127.0.0.1";
    payModel.channel_Type = [HYUtils getChannelString:pay_type];
    payModel.notify_url = @"https://www.heepay.com";
    payModel.return_url = @"https://www.heepay.com";
    payModel.body = @"iPhone 7p,白色,无拆分";
    payModel.terminal_info = [HYMergepayManager getTerminalInfos];
    payModel.provider_type = @"Heepay";
    payModel.attach = [HYUtils jsonStringFromObject:@{@"url_scheme":@"HeeMoneySDKSource"}];
    payModel.biz_content = [[self alloc] getBizParams:payModel];
    
    //功能参数。
    payModel.version = @"1.0";
    payModel.app_id = kApp_id;
    payModel.method = @"heemoney.pay.applypay"; //
    payModel.mch_uid = kMchUid;
    payModel.charset = @"utf-8";
    payModel.sign_type = @"MD5";
    
    payModel.api_from_type = @"Out_Api";
    
    payModel.timestamp = [HYUtils getSystemTimeString];
    
    payModel.sign = [[self alloc] generateMD5SignString:[payModel dictionaryRepresentation]];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary: [payModel dictionaryRepresentation]];
    [[self alloc] sendRequestWithParams:params complete:complete];
}

- (NSString *)generateMD5SignString:(NSDictionary *)param
{
    NSArray * tmpArr = [param.allKeys sortedArrayUsingComparator:^NSComparisonResult(id    _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray * keys = [NSMutableArray arrayWithArray:tmpArr];
    for (NSString * bizKey in self.bizParmas.allKeys) {
        [keys removeObject:bizKey];
    }
    
    NSMutableString * paramStr = [NSMutableString string];
    for (NSString * key in keys) {
        
        if ([HYUtils isNullOrEmpty:param[key]]) {
            continue;
        }
        [paramStr appendString:[NSString stringWithFormat:@"%@=%@&",key,param[key]]];
    }
    
    [paramStr appendString:[NSString stringWithFormat:@"key=%@",kMD5Key]];
    return [HYUtils md5:paramStr].uppercaseString;
}


- (NSString *)getBizParams:(OrderModel * )payModel
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[payModel dictionaryRepresentation]];
    for (NSString * key in dic.allKeys) {
        if ([HYUtils isNullOrEmpty:dic[key]]) {
            [dic removeObjectForKey:key];
        }
    }
    self.bizParmas = dic;
    NSString * jsonStr = [HYUtils jsonStringFromObject:dic];
    return jsonStr;
}



- (void)sendRequestWithParams:(NSDictionary *)paramsDic complete:(WebRequestCompleteBlock)complete
{
    
    NSMutableDictionary * tmp = [NSMutableDictionary dictionaryWithDictionary:paramsDic];
    for (NSString * bizKey in self.bizParmas.allKeys) {
        [tmp removeObjectForKey:bizKey];
    }
    paramsDic = tmp.copy;
    
    NSString * url =[NSString stringWithFormat:@"%@",kPayInitURL] ;
    NSString * encodeParams = [HYUtils jsonStringFromObject:paramsDic];    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [postRequest setTimeoutInterval:15.0f];
    [postRequest setHTTPBody:[NSData dataWithBytes:[encodeParams UTF8String] length:strlen([encodeParams UTF8String])]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type"];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSURLConnection sendAsynchronousRequest:postRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (connectionError) {
                    complete(connectionError.localizedDescription,true);
                }
                else {
                    NSString * jsonStr = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
                    NSLog(@"json string: %@",jsonStr);
                    NSDictionary * d = [HYUtils objectFromJSONString:jsonStr];

                    NSString * return_code = d[@"return_code"];
                    if([return_code isEqualToString:@"SUCCESS"]){
                    
                        NSString * result_code = d[@"result_code"];
                        if ([result_code isEqualToString:@"SUCCESS"]) {
                            complete(jsonStr,false);
                        }
                        else {
                             complete(d[@"error_msg"],true);
                        }
                    }
                    else {
                        complete(d[@"return_msg"],true);
                    }
                }
            });
        }];
    });
}



@end
