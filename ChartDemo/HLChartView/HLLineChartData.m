//
//  HLLineChartData.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/28.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "HLLineChartData.h"

@implementation HLLineChartData


+ (instancetype)lineChartDataWithValuesArray:(NSArray *)valuesArray lineColor:(UIColor *)lineColor
{
    HLLineChartData *data = [[HLLineChartData alloc]init];
    data.valuesArray = valuesArray;
    data.lineColor = lineColor;
    data.yValuesColor = lineColor;
    data.lineWidth = 1.0f;
    data.yValueFont = 10.0f;
    data.circleSize = 3;
    data.circleType = HLLineDataCircleTypePoint;
    return data;
}


@end
