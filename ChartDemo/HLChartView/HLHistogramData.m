//
//  HLHistogramData.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/28.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "HLHistogramData.h"

@implementation HLHistogramData



+ (instancetype)histogramDataWithValue:(NSString *)value histogramColor:(UIColor *)histogramColor
{
    HLHistogramData *data = [[HLHistogramData alloc]init];
    
    data.value = value;
    data.histogramColor = histogramColor;
    
    return data;
}



@end
