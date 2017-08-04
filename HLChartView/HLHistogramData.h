//
//  HLHistogramData.h
//  AnimationDemo
//
//  Created by tederen on 2017/7/28.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLHistogramData : NSObject

/**
 值
 */
@property(nonatomic,copy)   NSString *value;

/**
 柱状颜色
 */
@property(nonatomic,strong) UIColor *histogramColor;

/**
 高度
 */
@property(nonatomic,assign) CGFloat height;


+ (instancetype)histogramDataWithValue:(NSString *)value
                        histogramColor:(UIColor *)histogramColor;



@end
