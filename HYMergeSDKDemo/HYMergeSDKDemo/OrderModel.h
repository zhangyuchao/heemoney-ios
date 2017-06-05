//
//  HYHeePayModel.h
//  HYWebRequestDemo
//
//  Created by Jiangrx on 5/23/16.
//  Copyright © 2016 汇元网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic,copy) NSString * version; //接口版本号
@property (nonatomic,copy) NSString * app_id; //机构APPID
@property (nonatomic,copy) NSString * method ; //接口名
@property (nonatomic,copy) NSString * mch_uid; //汇元网分配的商户号
@property (nonatomic,copy) NSString * charset; //编码方式。
@property (nonatomic,copy) NSString * sign_type; //签名类型。
@property (nonatomic,copy) NSString * sign; // 签名值。
@property (nonatomic,copy) NSString * timestamp; //下单时间。
@property (nonatomic,copy) NSString * terminal_info; //终端信息。
@property (nonatomic,copy) NSString * provider_type; //通道提供方。
@property (nonatomic, copy) NSString *auth_bar_code;//刷卡预授权条码

@property (nonatomic, copy) NSString *api_from_type;

@property (nonatomic,copy) NSString * biz_content; //业务参数集合。

@property (nonatomic,copy) NSString * attach;
@property (nonatomic,copy) NSString * out_trade_no; //商户的订单号。
@property (nonatomic,copy) NSString * subject; //订单标题。
@property (nonatomic,copy) NSString * total_fee; //提交金额。
@property (nonatomic,copy) NSString * timeout_express; //超时时间。
@property (nonatomic,copy) NSString * client_ip; //终端IP地址。
@property (nonatomic,copy) NSString * channel_Type; //通道类型。
@property (nonatomic,copy) NSString * return_url; //异步通知地址。
@property (nonatomic,copy) NSString * notify_url; //异步通知地址。
@property (nonatomic,copy) NSString * body; //商品描述

- (NSDictionary *)dictionaryRepresentation;

@end
