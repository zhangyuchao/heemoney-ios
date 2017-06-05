## 汇元聚合支付iOS SDK接入指南


汇元聚合支付SDK对接资源包中Libs目录下为SDK文件，HYMergeSDKDemo是简单的接入示例，仅供参考。 iOS SDK 适用于:

+ 支付宝钱包
+ 微信APP支付
+ 百度钱包支付
+ QQ钱包支付
+ Apple Pay 
+ 银联手机控件支付


### 一、支付流程

![DFD.png](https://github.com/zhangyuchao/heemoney-ios/blob/master/Image/DFD.png)


**交互步骤：**

1. 商户客户端向商户服务器发送支付请求，携带商品信息，商户服务器按汇元聚合支付统一下单接口的要求进行组织参数，发送预支付请求。

2. 汇元聚合支付后台收到商户的预支付请求后，按照通道类型，向相关通道发起下单请求，通道下单后，将预支付要素返回商户后台。
3. 商户App将支付参数通过汇元聚合支付SDK提供的接口传入SDK。
4. 汇元聚合支付SDK对传入的参数校验后，按照通道类型唤起对应的支付页面。用户输入密码，选择确认支付之后完成支付操作。
5. 支付完成后，由支付通道将支付结果同步返回商户APP，用于展示本次支付状态**（同步回调结果只作为界面展示的依据，不能作为订单的最终支付结果，最终支付结果应以异步回调为准）。**
6. 支付通道将支付结果异步返回汇元聚合支付后台。
7. 汇元聚合支付后台将支付结果异步返回商户后台。



### 二、iOS安装
汇元聚合支付SDK兼容到iOS 6.1及以上版本，请在Xcode 7.0版本之上编译。

####Xcode工程配置

1. 导入SDK资源包。包括聚合SDK部分（HYMergepayManager.h、HYPayReq.h、HYPayResp.h、libMergepaySDK.a）和支付通道SDK部分（Channel下具体根据使用到的通道导入，如果未使用的可以不导入）。

2. 依赖Frameworks:

   必须导入的Frameworks:

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

 	百度钱包所需

		AddressBook.framework
		AddressBookUI.framework
		AudioToolbox.framework
		CoreAudio.framework
		CoreGraphics.framework
		ImageIO.framework
		MapKit.framework
		MessageUI.framework
		MobileCoreServices.framework

 	Apple Pay 所需：

		PassKit.framework
	

3. 到AppDelegate.m中 设置支付结果回调如下代码:
 
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


4. 添加编译宏 

	在target--> build settings---> other linker flags --->添加 -ObjC 。如果设置此宏之后，出现静态库类冲突问题，请使用-force_load + libMergepaySDK.a路径(设置路径可以直接将静态库拖到设置项，路径即可自动补全了 ~_~!!)。

5. 设置 LSApplicationQueriesSchemes 
		
	+ 如果对接微信，请添加weixin 和 wechat ；
	+ 如果对接支付宝，请添加alipay和alipays
	+ 如果对接银联，请添加 uppaysdk 和uppaywallet
	+ 如果对接QQ钱包 请添加 mqqwallet


6. 设置URLScheme 

	 + 如果对接微信支付，请在target--->Info--->URL Types 下添加微信的回调标识，直接添加微信APPID就可以。
	 + 如果对接支付宝，请添加一个复杂的标识，防止和其他APP重名。具体请参照Demo设置。

###三、SDK接口介绍
 汇元聚合支付SDK包含三个头文件，分别为 HYMergepayManager.h 、HYPayReq.h、HYPayResp.h。HYMergepayManager为汇元聚合支付SDK的容器类，负责发起支付请求和接受支付结果响应。 HYPayReq 为支付请求类，负责接收不同支付通道参数的配置。HYPayResp为支付结果响应体类，包括支付状态码、提示信息、错误描述等信息。

**1.HYMergepayManager.h**

	
+ 支付结果的回调，此协议要求必须实现。

		@protocol HYMergepayDelegate <NSObject>
		@required
			-(void)onMergepayResp:(HYPayResp *)resp;
		@end

	 
+ 发送支付请求，req 为本次支付的请求对象

		+ (BOOL)sendHYReq:(HYPayReq *)req delegate:(id<HYMergepayDelegate>) delegate;


+ 设置当前支付环境 ，默认为NO，如果sandbox 为YES，则下单接口也必须是sandbox环境。

	 	+(void)setSandboxMode:(BOOL)sandbox;

+ 获取当前支付环境

		 +(BOOL)getCurrentMode;
		 
+ 判断手机是否支持Apple Pay；商户可以根据此方法返回的值来决定是否显示Apple Pay的支付图标。 cardType  0 表示不区分卡类型；1 表示只支持借记卡；2 表示支持信用卡；

		 +(BOOL)canMakeApplePayments:(NSUInteger)cardType;
+ 跳转到Apple Pay 系统绑卡页面

		 +(void)openPaymentSetup;
	 
+ 获取当前SDK版本接口版本号

	 	 +(NSString *)getHYApiVersion;
	 	
+ 设置是否打印log 日志到控制台

		 +(void)setWillPrintLog:(BOOL)flag;

+ 支付钱包和商户APP之间的通讯。需要在 application:openURL:sourceApplication:annotation:中调用。成功返回YES，失败返回NO。

		+(BOOL)handleOpenUrl:(NSURL *)url;
+ 调用手机摄像头，扫描二维码

        +(void)openQRScanningWithViewController:(UIViewController *)viewController completeBlock:(void(^)(NSString *content))completeBlock;
 
+ 获取终端信息

         + (NSString *)getTerminalInfos;

	
**2.HYPayReq.h**

+ 调用支付的app注册在info.plist中的scheme,支付宝、银联手机控件支付、Apple Pay 、QQPay支付必填

	  	@property (nonatomic, retain) NSString *scheme; 
+ 唤起支付钱包支付页面的根控制器，银联手机控件支付、Apple Pay、百度支付 必填。

    	@property (nonatomic, retain) UIViewController *viewController;
    	
+ 商户服务器调用汇元聚合支付统一下单接口成功后，由汇收银后台返回的支付要素，商户服务器应该按原样格式返回给商户APP，此支付要素必须为json 字符串。

    	@property (nonatomic,retain) NSString * charge;

**3.HYPayResp.h**


+ 支付结果状态码，部分状态码请参考Enum HYErrCode,默认为HYErrCodeCommon，商户APP可以通过此参数进行，支付结果展示。

  	     @property (nonatomic, assign) NSInteger resultCode;
  		
+ 支付结状态果描述字符串。默认为@""。商户APP可以通过此参数进行，支付结果展示。

		 @property (nonatomic, retain) NSString *resultMsg;

+ 支付结果错误详细说明。如果支付结果为非成功状态时，商户APP可用此值作为详细说明。

		 @property (nonatomic, retain) NSString *errDetail;
		 
+ 支付结果附加参数，部分支付通道包含订单信息、签名结果。

		@property (nonatomic, retain) NSDictionary *paySource;


###四、快速集成

**客户端从服务器端拿到 charge 对象后，调用下面的方法:**

 	HYPayReq *payReq = [[HYPayReq alloc] init];
    payReq.scheme = @"HYMergeSDKDemo";//URL Scheme,在Info.plist中配置; 支付宝必有参数;此参数不能有下划线等特殊字符，否则handleOpenURL方法不会被回调
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.charge = jsonStr;      //支付要素。
    [HYMergepayManager sendHYReq:payReq delegate:self];
            


**支付结束后，支付结果的回调**

	- (void)onMergepayResp:(HYPayResp *)resp{
	    if (resp.resultCode == HYPayResultSuccess) {
	        
	        //直接到支付结果页面。
	        NSLog(@"OK");
	    }
	    else {
	        //直接弹框提示支付错误信息。
	        NSLog(@"detail error: %@",resp.resultMsg);
	    }
	}


###五、注意事项
1. 为了用户操作完成后能够跳转回你的应用，请务必添加 URL Schemes：在 Xcode 中，选择你的工程设置项，选中 TARGETS 一栏，在 Info 标签栏的 URL Types 添加 URL Schemes，如果使用微信，填入微信平台上注册的应用程序 id（为 wx 开头的字符串）。如果不使用微信，则自定义，建议起名稍复杂一些，尽量避免与其他程序冲突。允许英文字母和数字，首字母必须是英文字母，不允许特殊字符。

2. 使用微信支付必须要求用户安装微信客户端。

3. 针对使用 Xcode 7 编译失败，遇到错误信息为:

		XXXXXXX does not contain bitcode. You must rebuild it with bitcode enabled (Xcode setting ENABLE_BITCODE), obtain an updated library from the vendor, or disable bitcode for this target.

	请到 Xcode 项目的 Build Settings 标签页搜索 bitcode，将 Enable Bitcode 设置为 NO 即可。


####六、常见问题总结

更多请参见汇收银 [帮助中心](https://github.com/Heemoney/heemoney-ios)。

 **1.其他第三方静态库(如支付宝、微信等)的文件中的类名产生冲突 duplicate symbols for architecture XXX**

在 Build Settings 搜索 Other Linker Flags，将之前添加的宏 -ObjC 修改为 -force_load+空格+控件路径 ，如: -force_load $(PROJECT_DIR)/libUPAPayPlugin.a**

**2. 解决error:An SSL error has occurred and a secure connection to the server cannot be made.**

请到`info.plist`文件中添加 `App Transport Security Settings` 具体参考Demo中的设置。


