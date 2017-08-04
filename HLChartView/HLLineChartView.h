//
//  HLLineChartView.h
//  AnimationDemo
//
//  Created by zhiyuehl on 2017/7/20.
//  Copyright © 2017年 zhiyuehl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SetRect.h"
#import "HLLineChartData.h"


typedef NS_ENUM(NSUInteger, HLLineChartType) {
    HLLineChartTypeBrokenLine,   //折线
    HLLineChartTypeCurve,        //曲线
};


@interface HLLineChartView : UIView

//！！若出现偏移，请在controller中设置self.automaticallyAdjustsScrollViewInsets = NO;

/**
 y轴值，必传
 */
@property(nonatomic,strong) NSArray<HLLineChartData *> *yValueLabels;

/**
 x轴坐标，必传
 */
@property(nonatomic,strong) NSArray<NSString *> *xLabels;

/**
 y轴左边颜色，default to gray color
 */
@property(nonatomic,strong) UIColor *yLablesColor;

/**
 y坐标宽度，default to 30
 */
@property(nonatomic,assign) CGFloat yLabelWidth;

/**
 上部空出高度，可设置标题和图例等，default to 20
 */
@property(nonatomic,assign) CGFloat topGap;

/**
 y值的颜色。default to lineColor
 */
@property(nonatomic,strong) UIColor *yValuesColor;

/**
 x轴坐标颜色，default to gray color
 */
@property(nonatomic,strong) UIColor *xLabelsColor;

/**
 背景颜色，default to white color
 */
@property(nonatomic,strong) UIColor *chartBackgroundColor;

/**
 曲线类型，default to HLLineChartTypeCurve
 */
@property(nonatomic,assign) HLLineChartType lineChartType;

/**
 y轴几个刻度坐标，default to 5
 */
@property(nonatomic,assign) NSInteger ySepLabelCount;

/**
 x坐标宽度，default to 50.f
 */
@property(nonatomic,assign) CGFloat xLabelsWidth;

/**
  x坐标高度，default to 50.f
 */
@property(nonatomic,assign) CGFloat xLabelsHeight;

/**
 渐变图层，default to yes，lineColor with 0.5 alpha, 必须只有一条线，yValueLabels.count == 1
 */
@property(nonatomic,assign) BOOL isShowGradientColor;

/**
 x网格线，default to yes ,dotted line
 */
@property(nonatomic,assign) BOOL isShowXSepratorLine;

/**
 y网格线，default to yes ,dotted line
 */
@property(nonatomic,assign) BOOL isShowYSepratorLine;

/**
 是否线条动画，default to yes
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
 X轴坐标，default to no
 */
@property(nonatomic,assign) BOOL isHideXLables;


/**
 绘制,最后调用
 */
- (void)strokeStart;



@end
