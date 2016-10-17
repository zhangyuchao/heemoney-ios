//
//  ViewController.m
//  HeeMoneySDKDemo
//
//  Created by  huiyuan on 16/8/16.
//  Copyright © 2016年  huiyuan. All rights reserved.
//

#import "ViewController.h"
#import "HYGoodsChannelCell.h"
#import "HYGoods.h"

#import "HYOrderTableViewController.h"


@interface ViewController ()
{
    HYGoods * _goods;
}
@property (nonatomic, strong) NSMutableArray *allGoods;

@end

@implementation ViewController

- (NSArray *)allGoods{
    if (!_allGoods) {
        _allGoods = [[HYGoods demoData] mutableCopy];
    }
    return _allGoods;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.allGoods.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *goodsIdentifier = @"HYGoodsChannelCell";
    HYGoodsChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:goodsIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    HYGoods *goods = self.allGoods[indexPath.row];
    cell.goodsName.text = goods.name;
    //cell.goodsPrice.text = goods.price;
    cell.goodsPrice.text = [NSString stringWithFormat:@"%.2f元",0.01 * [goods.price floatValue]];
    cell.goodsDes.text = goods.des;
    cell.goodsImage.image = [UIImage imageNamed:goods.img];
    return cell;
}

#pragma mark --- UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%ld行",indexPath.row);
    _goods = self.allGoods[indexPath.row];
    [self performSegueWithIdentifier:@"doOrder" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"doOrder"]) {
        HYOrderTableViewController * contoller = segue.destinationViewController;
        contoller.goods = _goods;
    }
}

@end
