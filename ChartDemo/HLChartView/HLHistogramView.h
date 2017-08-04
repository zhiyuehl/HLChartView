//
//  HLHistogramView.h
//  AnimationDemo
//
//  Created by tederen on 2017/7/28.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLHistogramData.h"

@interface HLHistogramView : UIView

/**
 y轴值，可适应多级柱状图，必传
 */
@property(nonatomic,strong) NSArray<NSArray<HLHistogramData *> *> *yValueLabels;

/**
 x坐标，xLabels.count == yValueLabels.count
 */
@property(nonatomic,strong) NSArray *xLabels;

/**
 y值的颜色。default to data color
 */
@property(nonatomic,strong) UIColor *yValuesColor;

/**
 y轴左边颜色，default to gray color
 */
@property(nonatomic,strong) UIColor *yLablesColor;

/**
 x轴坐标颜色，default to gray color
 */
@property(nonatomic,strong) UIColor *xLabelsColor;

/**
 上部空出高度，可设置标题和图例等，default to 20
 */
@property(nonatomic,assign) CGFloat topGap;

/**
 y坐标宽度，default to 30
 */
@property(nonatomic,assign) CGFloat yLabelWidth;

/**
 多级柱状图组之间的距离，default to 0.0f
 */
@property(nonatomic,assign) CGFloat xHistogramMinGap;

/**
 组与组的距离,default to 25.0f
 */
@property(nonatomic,assign) CGFloat xHistogramMaxGap;

/**
 柱的宽度.default to 20.0f
 */
@property(nonatomic,assign) CGFloat histogramWidth;

/**
 x坐标高度，default to 50.f
 */
@property(nonatomic,assign) CGFloat xLabelsHeight;

/**
 y轴几个刻度坐标，default to 5
 */
@property(nonatomic,assign) NSInteger ySepLabelCount;

/**
 动画，default to yes
 */
@property(nonatomic,assign) BOOL isAnimatedDisplay;

/**
 Y轴坐标，default to no
 */
@property(nonatomic,assign) BOOL isHideYLabels;

/**
 y值。defalut to no
 */
@property(nonatomic,assign) BOOL isHideYValues;

/**
 绘制,最后调用
 */
- (void)strokeStart;


@end
