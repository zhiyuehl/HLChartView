//
//  HLLineChartData.h
//  AnimationDemo
//
//  Created by tederen on 2017/7/28.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HLLineDataCircleType) {
    HLLineDataCircleTypeCircle,  //环
    HLLineDataCircleTypePoint,  //点
};


@interface HLLineChartData : NSObject

/**
 y值
 */
@property(nonatomic,strong) NSArray<NSString *> *valuesArray;

/**
 线条颜色
 */
@property(nonatomic,strong) UIColor *lineColor;

/**
 线条宽度，default to 1.f
 */
@property(nonatomic,assign) CGFloat lineWidth;

/**
 y值的颜色，default to lineColor
 */
@property(nonatomic,strong) UIColor *yValuesColor;

/**
 y值的大小。default to 10
 */
@property(nonatomic,assign) CGFloat yValueFont;

/**
 点的大小半径，default to 3
 */
@property(nonatomic,assign) CGFloat circleSize;

/**
 点的样式，default to HLLineDataCircleTypePoint
 */
@property(nonatomic,assign) HLLineDataCircleType circleType;



+ (instancetype)lineChartDataWithValuesArray:(NSArray *)valuesArray
                                   lineColor:(UIColor *)lineColor;



@end
