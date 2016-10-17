//
//  HYResultViewController.m
//  HeeMoneySDKDemo
//
//  Created by  huiyuan on 16/8/30.
//  Copyright © 2016年  huiyuan. All rights reserved.
//

#import "HYResultViewController.h"

@interface HYResultViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *resultImage;

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UILabel *resultPrice;

@end

@implementation HYResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildUI];
}

-(void)buildUI{
    
    self.resultImage.image = [UIImage imageNamed:@"chkok"];
    self.resultLabel.text = @"支付成功";
    self.resultPrice.numberOfLines = 0;
    self.resultPrice.text = [NSString stringWithFormat:@"您已成功支付%.2f元,配送员将尽快给你送达.",0.01 * [_goods.price floatValue]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
