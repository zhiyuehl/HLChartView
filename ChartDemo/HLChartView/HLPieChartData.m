//
//  HLPieChartData.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/21.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "HLPieChartData.h"

@implementation HLPieChartData


+ (instancetype)pieDataWithValue:(NSString *)value pieChartColor:(UIColor *)pieChartColor detailText:(NSString *)detailText
{
    HLPieChartData *data = [[self alloc]init];
    data.value = value;
    data.pieChartColor = pieChartColor;
    data.detailText = detailText;
    data.lengendTextColor = [UIColor blackColor];
    return data;
}


@end
