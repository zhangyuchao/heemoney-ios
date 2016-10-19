## 汇收银iOS SDK接入指南


iOS SDK的lib文件夹下为SDK文件，example文件夹里是简单的接入示例，仅供参考。iOS SDK适用于:

+ 支付宝钱包
+ 微信APP支付
+ QQ钱包支付
+ 银联手机控件支付 
+ Apple Pay 
+ 百度钱包支付 

### 一、支付流程

![汇收银交互流程图](https://github.com/JiangrxMaomao/heemoney-ios/raw/master/DFD.png)

**交互步骤：**

1. 商户客户端向商户服务器发送支付请求，携带商品信息，商户服务器按汇收银统一下单接口的要求进行组织参数，发送预支付请求。

2. 汇收银后台收到商户的预支付请求后，按照通道类型，向相关通道发起下单请求，通道下单后，将相关预支付要素返回商户后台。
3. 商户App将支付相关参数通过汇收银SDK提供的接口传入SDK。
4. 汇收银SDK对传入的参数校验后，按照通道类型唤起对应的支付页面。用户输入密码，选择确认支付之后完成支付操作。
5. 支付完成后，由支付通道将支付结果同步返回商户APP，用于展示本次支付状态**（同步回调结果只作为界面展示的依据，不能作为订单的最终支付结果，最终支付结果应以异步回调为准）。**
6. 支付通道将支付结果异步返回汇收银后台。
7. 汇收银后台将支付结果异步返回商户后台。



### 二、iOS安装
iOS SDK 要求 iOS 6.0 及以上版本，请在Xcode 7.0版本之上编译。


####Xcode工程配置

1. 下载[iOS SDK](https://www.baidu.com)到本地，里面包含lib和example两个目录。example目录是实例项目，你需要将lib目录下的文件添加到你的项目。

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
	

3. 如果不需要某些渠道，删除 lib/Channels 下的相应目录即可。

4. 添加 Other Linker Flags：在 Build Settings 搜索 Other Linker Flags，添加 -ObjC 。




###三、SDK接口介绍
汇收银SDK包含三个头文件，分别为 HeeMoney.h 、HYPayReq.h、HYPayResp.h。HeeMoney为汇收银SDK的容器类，负责发起支付请求和接受支付结果响应。 HYPayReq 为支付请求类，负责接收不同支付通道参数的配置。HYPayResp为支付结果响应体类，包括支付状态码、提示信息、错误描述等信息。

**1.HeeMoney.h**

	
+ 支付结果的回调，此协议要求必须实现。

		@protocol HeeMoneyDelegate <NSObject>
		@required
			-(void)onHeeMoneyResp:(HYBaseResp *)resp;
		@

	 
+ 发送支付请求，req 为本次支付的请求对象

		+(BOOL)sendHYReq:(HYBaseReq *)req delegate:(id<HeeMoneyDelegate>) delegate;


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

		
	
**2.HYPayReq.h**

+ 调用支付的app注册在info.plist中的scheme,支付宝、银联手机控件支付、Apple Pay 、QQP支付必填

	  	@property (nonatomic, retain) NSString *scheme; 
+ 唤起支付钱包支付页面的根控制器，银联手机控件支付、Apple Pay、百度支付 必填。

    	@property (nonatomic, retain) UIViewController *viewController;
    	
+ 商户服务器调用汇收银统一下单接口成功后，由汇收银后台返回的支付要素，商户服务器应该按原样格式返回给商户APP，此支付要素必须为json 字符串。

    	@property (nonatomic,retain) NSString * charge;

+ 发起支付。

	     -(void)payReq;

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
    payReq.scheme = @"HeeMoneySDKSource";//URL Scheme,在Info.plist中配置; 支付宝必有参数
    payReq.viewController = self; //银联支付和Sandbox环境必填
    payReq.charge = jsonStr;      //支付要素。
    [HeeMoney sendHYReq:payReq];
            


**支付结束后，支付结果的回调**

	- (void)onHeeMoneyResp:(HYBaseResp *)resp
	{
    
    	if (resp.type == HYObjsTypePayResp){
        	// 支付请求响应
       		 HYPayResp *tempResp = (HYPayResp *)resp;
       		 if (tempResp.resultCode == 0) {
   		    	//支付成功。
            	[self showAlertView:resp.resultMsg];
       		 } else {
        	    //支付失败
           		 [self showAlertView:tempResp.errDetail];
       		 }
    	}
	}


###五、接收并处理交易结果

渠道为百度钱包或者渠道为支付宝但未安装支付宝钱包时，交易结果会在调起插件时的 Completion 中返回。渠道为微信、支付宝(安装了支付宝钱包)、银联或者测试模式时，请实现 UIApplicationDelegate 的方法：
	 
	 - application:openURL:xxxx: 
	 

#####iOS 8 及以下

	- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    	if (![HeeMoney handleOpenUrl:url]) {
   	     //handle其他类型的url
  	  }
   	 return YES;
	}



#####iOS 9 及以上

	//iOS9之后官方推荐用此方法
	- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
  	  if (![HeeMoney handleOpenUrl:url]) {
   	     //handle其他类型的url
  	  }
  	  return YES;
	}
###六、注意事项
1. 为了用户操作完成后能够跳转回你的应用，请务必添加 URL Schemes：在 Xcode 中，选择你的工程设置项，选中 TARGETS 一栏，在 Info 标签栏的 URL Types 添加 URL Schemes，如果使用微信，填入微信平台上注册的应用程序 id（为 wx 开头的字符串）。如果不使用微信，则自定义，建议起名稍复杂一些，尽量避免与其他程序冲突。允许英文字母和数字，首字母必须是英文字母，不允许特殊字符。

2. 2.1.0 及以上版本，可打开 Debug 模式打印出 log ，方便调试。开启方法：`[HeeMoney setWillPrintLog:YES];`。

3. 使用微信支付必须要求用户安装微信客户端。

4. 由于百度钱包 SDK 不支持 iOS 模拟器，目前带有百度钱包的 HeeMoney SDK 只能运行于真机。


#####适配 iOS 9 注意事项

1. 针对 iOS 9 系统更新， 为了使你接入的微信支付与支付宝支付兼容 iOS 9 ,请按照以下引导进行操作： 应用需要在 Info.plist 中将要使用的 URL Schemes 列为白名单，才可正常检查其他应用是否安装。受此影响，当你使用 Xcode 7 及 iOS 9 编译发布新版本 App，并且用到了判断是否安装相应的 App （支付宝钱包、微信）的接口时，需要在 Info.plist 里添加如下代码：

		<key>LSApplicationQueriesSchemes</key>
		<array>
  		  <string>weixin</string>
  		  <string>wechat</string>
  		  <string>alipay</string>
		</array>

**请注意： 未升级到微信 6.2.5 及以上版本的用户，在 iOS 9 下使用到微信相关功能时，仍可能无法成功 。**

2. 针对 iOS 9 限制 http 协议的访问，如果 App 需要访问 http://， 则需要在 Info.plist 添加如下代码:

		<key>NSAppTransportSecurity</key>
		<dict>
 		   <key>NSAllowsArbitraryLoads</key>
  		   <true/>
		</dict>

3. 针对使用 Xcode 7 编译失败，遇到错误信息为:

		XXXXXXX does not contain bitcode. You must rebuild it with bitcode enabled (Xcode setting ENABLE_BITCODE), obtain an updated library from the vendor, or disable bitcode for this target.

	请到 Xcode 项目的 Build Settings 标签页搜索 bitcode，将 Enable Bitcode 设置为 NO 即可。


####七、常见问题总结

更多请参见汇收银 [帮助中心](https://www.baidu.com)。

 **1.其他第三方静态库(如支付宝、微信等)的文件中的类名产生冲突 duplicate symbols for architecture XXX**

在 Build Settings 搜索 Other Linker Flags，将之前添加的宏 -ObjC 修改为 -force_load+空格+控件路径 ，如: -force_load $(PROJECT_DIR)/libUPAPayPlugin.a**
