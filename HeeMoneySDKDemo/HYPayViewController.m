//
//  HYPayViewController.m
//  HeeMoneySDKDemo
//
//  Created by  huiyuan on 16/8/17.
//  Copyright © 2016年  huiyuan. All rights reserved.
//

#import "HYPayViewController.h"
#import "HYPayChannelCell.h"
#import "HeeMoney.h"
#import "HYPayReq.h"
#import "SVProgressHUD.h"
#import "HYResultViewController.h"

#define kPayURL           @"http://192.168.2.95/PayHeemoney/Test/Sdk/Pay.aspx" // 用于生产环境下的下单地址。
#define kSandboxURL       @"http://192.168.2.95/PayHeemoney/Test/Sdk/Test.aspx" //沙盒环境下模拟下单地

#define Image    @"IMAGE"
#define Title    @"TITLT"
#define Type     @"PayType"

@interface HYPayViewController ()<HeeMoneyDelegate>
{
    NSMutableArray *dataSourceArr;
    NSInteger selectedRow;
}
@end

@implementation HYPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"------%@------",_goods.price);
    
    dataSourceArr = [NSMutableArray arrayWithArray:@[@{Image:@"wx",Title:@"微信支付",Type:@(PayChannelWxApp)},
                         @{Image:@"ali",Title:@"支付宝",Type:@(PayChannelAliApp)},
                         @{Image:@"qq",Title:@"QQ钱包",Type:@(PayChannelQQWallet)},
                         @{Image:@"applePay",Title:@"ApplePay",Type:@(PayChannelApplePay)},
                         @{Image:@"union",Title:@"银联在线",Type:@(PayChannelUnApp)},
                         @{Image:@"baidu",Title:@"百度钱包",Type:@(PayChannelBaiduApp)}
                         ]
                     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    //设置HeeMoney的代理
    [HeeMoney setHeeMoneyDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return dataSourceArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        UIImage *cellImage = [UIImage imageNamed:_goods.img];
        CGSize itemSize = CGSizeMake(50, 50);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO ,0.0);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        [cellImage drawInRect:imageRect];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        cell.textLabel.text = [NSString stringWithFormat:@"%.2f元",0.01 * [_goods.price floatValue]];
        cell.textLabel.font = [UIFont systemFontOfSize:22];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        HYPayChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYPayChannelCell"];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"HYPayChannelCell" owner:self options:nil] objectAtIndex:0];
        }
        
        NSDictionary *dic = [dataSourceArr objectAtIndex:indexPath.row];
        cell.CImg.image = [UIImage imageNamed:[dic objectForKey:Image]];
        cell.title.text = [dic objectForKey:Title];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark --- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return 100;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [view addSubview:button];
        button.frame = CGRectMake(20, 10, self.view.frame.size.width - 40, 60);
        [button setTitle:@"确认支付" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor orangeColor]];
        button.layer.cornerRadius = 4;
        button.layer.masksToBounds = YES;
        
        [button addTarget:self action:@selector(dealPay:) forControlEvents:UIControlEventTouchUpInside];
        
        return view;
    }
    return nil;
}

-(void)dealPay:(UIButton *)button{
    NSLog(@"----确认支付----");
    NSLog(@"%ld",selectedRow);
    
    [SVProgressHUD showWithStatus:@"加载中，请稍后。"];
    
    NSDictionary *dic = dataSourceArr[selectedRow];
    PayChannel channel = [dic[Type] integerValue];
    switch (channel) {
        case PayChannelWxApp:
        case PayChannelAliApp:
        case PayChannelUnApp:
        case PayChannelBaiduApp:
        case PayChannelApplePay:
        case PayChannelQQWallet:
            [self doPayChannel:channel];
            break;
            
        default:
            break;
    }
    
}

-(void)doPayChannel:(PayChannel)channel{
    NSDictionary * dic = @{
                           @"version":@"1",
                           @"app_id":@"app_JWsWp1q1nIgtjA4E",
                           @"bill_timeout":@"6",
                           @"channel_provider":[self getChannelProvider:channel],
                           @"channel_code":[self getChannelString:channel],
                           @"charset":@"gb2312",
                           @"currency":@"CNY",
                           @"mch_id":@"1970535",
                           @"out_trade_no":[self genBillNo],
                           @"sign_type":@"MD5",
                           @"subject":_goods.name,
                           @"timestamp":[self getTimeStamp],
                           @"total_amt_fen":_goods.price,
                           @"user_ip":@"127.0.0.1",
                           @"return_url":@"https://www.heepay.com",
                           @"notify_url":@"https://www.heepay.com"
                           };
    NSString * encodeParams = [self jsonStringFromObject:dic];
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
                /**
                 按住键盘上的option键，点击参数名称，可以查看参数说明
                 **/
                HYPayReq *payReq = [[HYPayReq alloc] init];
                payReq.scheme = @"HeeMoneySDKSource";//URL Scheme,在Info.plist中配置; 支付宝必有参数
                payReq.viewController = self; //银联支付和Sandbox环境必填
                payReq.charge = jsonStr;      //支付要素。
                [HeeMoney sendHYReq:payReq];
            }
        });
    }];
    
    [task resume];

}

#pragma mark - HYPay回调
- (void)onHeeMoneyResp:(HYBaseResp *)resp{
    switch (resp.type) {
        case HYObjsTypePayResp:
        {
            // 支付请求响应
            HYPayResp *tempResp = (HYPayResp *)resp;
            if (tempResp.resultCode == 0) {
                
                //跳转到支付结果页面查看支付结果
                [self performSegueWithIdentifier:@"doResult" sender:self];
                
                //[self showAlertView:resp.resultMsg];
            } else {
                [SVProgressHUD dismiss];
                [self showAlertView:tempResp.errDetail];
            }
        }
        default:
            break;
    }
}

/*获取时间戳*/
- (NSString *)getTimeStamp
{
    long long t = [[NSDate date] timeIntervalSince1970] * 1000 + 8 * 3600 * 1000;
    NSLog(@"%lld",t);
    NSString * timeStamp = [NSString stringWithFormat:@"%lld",t];
    
    return timeStamp;
}


#pragma mark ---- 生成订单号
-(NSString *)genBillNo{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [formatter stringFromDate:[NSDate date]];
}

- (void)showAlertView:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (NSString *)getChannelString:(PayChannel)channel {
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
            cType = @"ApplePay";
            break;
#pragma mark PayChannel_QQWallet
        case PayChannelQQWallet:
            cType = @"QQ_APP";
            break;
    }
    return cType;
}

//获取通道类型。
- (NSString *)getChannelProvider:(PayChannel)channel
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
            cType = @"ApplePay";
            break;
#pragma mark PayChannel_QQWallet
        case PayChannelQQWallet:
            cType = @"QQPay";
        default:
            break;
    }
    return cType;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    selectedRow = indexPath.row;
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"doResult"]) {
        HYResultViewController *controller = segue.destinationViewController;
        controller.goods = _goods;
    }
}

- (NSString *)jsonStringFromObject:(id)object
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
