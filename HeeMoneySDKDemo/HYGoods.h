//
//  HYGoods.h
//  HeeMoneySDKDemo
//
//  Created by  huiyuan on 16/8/22.
//  Copyright © 2016年  huiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYGoods : NSObject 

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *price;

@property (nonatomic, strong) NSString *des;

@property (nonatomic, strong) NSString *img;

+ (NSArray *)demoData;

@end
