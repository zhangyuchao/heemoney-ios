//
//  ViewController.m
//  HYMergeSDKDemo
//
//  Created by 降瑞雪 on 2017/5/24.
//  Copyright © 2017年 汇元网. All rights reserved.
/*
    对接流程:
 
    1.导入SDK资源包。包括聚合SDK部分（HYMergepayManager.h、HYPayReq.h、HYPayResp.h、libMergepaySDK.a）和支付通道SDK部分（Channel下具体根据使用到的通道导入，如果未使用的可以不导入）
    2.配置工程设置。
        2.1 到AppDelegate.m中 设置支付结果回调如下代码:
 
             - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
             if (![HYMergepayManager handleOpenUrl:url]) {
             //handle其他类型的url
             }
             return YES;
             }
             
             //iOS9之后官方推荐用此方法
             - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
             if (![HYMergepayManager handleOpenUrl:url]) {
             //handle其他类型的url
             }
             return YES;
             }
 
        2.2 添加编译宏 target--> build settings---> other linker flags --->添加 -ObjC 。如果设置此宏之后，出现静态库类冲突问题，请使用-force_load + libMergepaySDK.a路径(设置路径可以直接将静态库拖到设置项，路径即可自动补全了 ~_~!!).
        
        2.3 解决error : An SSL error has occurred and a secure connection to the server cannot be made.
            请到info.plist文件中添加 App Transport Security Settings设置项。具体参考Demo中的设置。
        
        2.4 设置 LSApplicationQueriesSchemes 
            如果对接微信，请添加weixin 和 wechat ；
            如果对接支付宝，请添加alipay
            如果对接银联，请添加 uppaysdk 和uppaywallet
            如果对接QQ钱包 请添加 mqqwallet
 
        2.5 设置URLScheme 
            如果对接微信支付，请在target--->Info--->URL Types 下添加微信的回调标识，直接添加微信APPID就可以。
            如果对接支付宝，请添加一个复杂的标识，防止和其他APP重名。具体请参照Demo设置。
 
 
    3.导入依赖系统框架。
    
        必须导 的Frameworks:
         CFNetwork.framework
         SystemConfiguration.framework
         Security.framework
         QuartzCore.framework
         CoreTelephony.framework
         CoreMotion.framework
         AVFoundation.framework
         CoreLocation.framework
         AssetsLibrary.framework
         LocalAuthentication.framework
         CoreMedia.framework
         libc++.tbd
         libz.tbd
         libsqlite3.0.tbd
         libstdc++.tbd
         libz1.2.5.tbd
 
        百度支付需要导入:
 
         AddressBook.framework
         AddressBookUI.framework
         AudioToolbox.framework
         CoreAudio.framework
         CoreGraphics.framework
         ImageIO.framework
         MapKit.framework
         MessageUI.framework
         MobileCoreServices.framework
 
    4.撸对接代码
 
        3.1 唤起SDK主要代码
             HYPayReq *payReq = [[HYPayReq alloc] init];
             payReq.scheme = @"alipay_HYMergeSDKDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数
             payReq.viewController = self; //银联支付和Sandbox环境必填
             payReq.charge = charge;      //支付要素。
             [HYMergepayManager sendHYReq:payReq delegate:self];
        
        3.2 支付结果回调
             - (void)onMergepayResp:(HYPayResp *)resp
             {
                 if (resp.resultCode == HYPayResultSuccess) {
                    NSLog(@"OK");
                 }
                else {
                    NSLog(@"detail error: %@",resp.resultMsg);
                }
             }
 */

#import "ViewController.h"
#import "HYMergepayManager.h"
#import "HYPayReq.h"
#import "HYPayResp.h"
#import "WebRequest.h"
#import "MBProgressHUD.h"

@interface ViewController ()<HYMergepayDelegate>

@property (weak, nonatomic) IBOutlet UITextField *paymentFeeTF;

@end

@implementation ViewController

- (IBAction)onClick:(UIButton *)sender {

    
    [HYMergepayManager setWillPrintLog:true];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [WebRequest sendRequestWithPaymentFee:self.paymentFeeTF.text paymentType:sender.tag completeBlock:^(NSString *charge, BOOL hasError) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (hasError) {
            NSLog(@"error : %@",charge);
        }
        else{
            
            HYPayReq *payReq = [[HYPayReq alloc] init];
            payReq.scheme = @"HYMergeSDKDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数;此参数不能有下划线等特殊字符，否则handleOpenURL方法不会被回调
            payReq.viewController = self; //当前viewController
            payReq.charge = charge;      //支付要素，调用汇元网下单接口的返回的所有jsonString.
            [HYMergepayManager sendHYReq:payReq delegate:self];
        }
    }];
    
}

- (void)onMergepayResp:(HYPayResp *)resp
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (resp.resultCode == HYPayResultSuccess) {
        
        //直接到支付结果页面。
        NSLog(@"OK");
    }
    else {
        //直接弹框提示支付错误信息。
        NSLog(@"detail error: %@",resp.resultMsg);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
