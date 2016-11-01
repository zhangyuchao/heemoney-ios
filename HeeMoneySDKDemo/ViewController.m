//
//  ViewController.m
//  HeeMoneySDKSource
//
//  Created by Jiangrx on 6/3/16.
//  Copyright © 2016 汇元网. All rights reserved.
//

#define Image    @"IMAGE"
#define Title    @"TITLE"

#import "ViewController.h"
#import "HYPayChannelCell.h"
#import "MBProgressHUD.h"
#import "HYUtils.h"
#import "HeeMoney.h"


#define is_formal_host  1
#define is_sendbox      0

#if is_formal_host

    #define kAgent_id        @"2072782"
    #define kApp_id          @"app_TlJnShE0Wz24Aq57"
    #if is_sendbox
        #define kPayURL     @"http://192.168.2.95/PayHeemoney/Test/Sdk/Pay.aspx" //生产环境下的单地址。
    #else
        #define kPayURL     @"http://211.154.166.253/DemoHeemoney/Sdk/Pay.aspx"
    #endif
#else

    #define kAgent_id        @"1970535"
    #define kApp_id          @"app_JWsWp1q1nIgtjA4E"
    #if is_sendbox
        #define kPayURL     @"http://192.168.2.95/PayHeemoney/Test/Sdk/Test.aspx" //沙盒环境下模拟下单地址。
    #else
        #define kPayURL     @"http://192.168.2.95/PayHeemoney/Test/Sdk/Pay.aspx" // 用于生产环境下的单地址。
    #endif
#endif
//
@interface ViewController () <HeeMoneyDelegate,UITableViewDelegate,UITableViewDataSource>
{
    PayChannel _currentChannel;
    NSArray *_channels;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [HeeMoney setWillPrintLog:YES];
    
    self.title = @"支付";
    _channels = @[
                   @{@"sub":@(PayChannelWxApp), @"img":@"wx", @"title":@"微信支付"},
                   @{@"sub":@(PayChannelAliApp), @"img":@"ali", @"title":@"支付宝"},
                   @{@"sub":@(PayChannelUnApp), @"img":@"un", @"title":@"银联在线"},
                   @{@"sub":@(PayChannelBaiduApp), @"img":@"baidu", @"title":@"百度钱包"},
                   @{@"sub":@(PayChannelApplePay), @"img":@"apple", @"title":@"ApplePay"},
                   @{@"sub":@(PayChannelQQWallet), @"img":@"qqPay", @"title":@"QQ钱包"}
                ];

    UITableView * tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    
}

#pragma mark --- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _channels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"HYPayChannelCell";
    HYPayChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[HYPayChannelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary *row = _channels[indexPath.row];
    cell.image = [UIImage imageNamed:row[@"img"]];
    cell.text = row[@"title"];
    
    return cell;
}
#pragma mark --- UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"线上支付";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray * cells = [tableView visibleCells];
    for (UITableViewCell * cell in cells) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    UITableViewCell * selectedCell = [cells objectAtIndex:indexPath.row];
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    _currentChannel = [_channels[indexPath.row][@"sub"] integerValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return 64.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    view.userInteractionEnabled = YES;
    UIButton * footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.backgroundColor = [UIColor orangeColor];
    footerButton.layer.cornerRadius = 4.0f;
    [footerButton addTarget:self action:@selector(doPayChannel) forControlEvents:UIControlEventTouchUpInside];
    footerButton.frame = CGRectMake(10.0f, 20.0f, self.view.frame.size.width - 20.0f, 44.0f);
    [footerButton setTitle:@"确认支付" forState:UIControlStateNormal];
    [view addSubview:footerButton];
    return view;
}

- (void)doPayChannel
{
    if (_currentChannel == PayChannelNone) {
        [HYUtils alertMsg:@"请选择支付类型"];
        return;
    }
    MBProgressHUD * hudView = [HYUtils startWaiting:@"请稍后.." onViewController:self];
    NSDictionary * dic = @{
                           @"version":@"1",
                           @"app_id":kApp_id,
                           @"bill_timeout":@"6",
                           @"channel_provider":[HYUtils getChannelProvider:_currentChannel],
                           @"channel_code":[HYUtils getChannelString:_currentChannel],
                           @"charset":@"gb2312",
                           @"currency":@"CNY",
                           @"mch_id":kAgent_id,
                           @"out_trade_no":[HYUtils getTimeStamp],
                           @"sign_type":@"MD5",
                           @"subject":@"iPhone 7p",
                           @"timestamp":[HYUtils getTimeStamp],
                           @"total_amt_fen":@"10",
                           @"user_ip":@"127.0.0.1",
                           @"return_url":@"https://www.heepay.com",
                           @"notify_url":@"https://www.heepay.com"
                           };
    NSString * encodeParams = [HYUtils jsonStringFromObject:dic];
    NSLog(@"统一下单接口入参: %@",encodeParams);
    NSLog(@"send to: %@",kPayURL);
    
    NSMutableURLRequest * postRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:kPayURL]];
    [postRequest setHTTPBody:[NSData dataWithBytes:[encodeParams UTF8String] length:strlen([encodeParams UTF8String])]];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json; charset=gb2312" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error){
                NSLog(@"error:%@",[error localizedDescription]);
            }
            else {
                NSString * jsonStr = [[NSString alloc] initWithBytes:[data bytes] length:data.length encoding:NSUTF8StringEncoding];
                [hudView removeFromSuperview];
                NSLog(@"jsonStr: %@",jsonStr);
                /**
                 按住键盘上的option键，点击参数名称，可以查看参数说明
                 **/
                HYPayReq *payReq = [[HYPayReq alloc] init];
                payReq.scheme = @"HeeMoneySDKSource";//URL Scheme,在Info.plist中配置; 支付宝必有参数
                payReq.viewController = self; //银联支付和Sandbox环境必填
                payReq.charge = jsonStr;      //支付要素。
                [HeeMoney sendHYReq:payReq delegate:self];
            }
        });
    }];
    
    [task resume];
}

#pragma mark - HYPay回调
- (void)onHeeMoneyResp:(HYPayResp *)resp{
    
    if (resp.type == HYObjsTypePayResp){

        NSLog(@"resp.resultCode == %@",@(resp.resultCode));
        [HYUtils alertMsg:resp.resultMsg];
    }
}

@end
