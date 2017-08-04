//
//  HLPieChartView.h
//  AnimationDemo
//
//  Created by tederen on 2017/7/21.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLPieChartData.h"
#import "UIView+SetRect.h"

typedef NS_ENUM(NSUInteger, HLPieLengendPosition) {
    HLPieLengendPositionTop,
    HLPieLengendPositionBottom,
    HLPieLengendPositionRightTop,
    HLPieLengendPositionLeftTop,
};


typedef NS_ENUM(NSUInteger, HLPieDetailTextType) {
    HLPieDetailTextTypeValue,     //数值展示
    HLPieDetailTextTypeProportion,   //比例展示
    HLPieDetailTextTypeNono,  //不展示
};



@interface HLPieChartView : UIView

/**
 数据源
 */
@property(nonatomic,strong) NSArray<HLPieChartData *> *pieDatas;

/**
 default to yes
 */
@property(nonatomic,assign) BOOL showLengendView;

/**
 图例的宽或高，relate to lengendPosition,default to 50
 */
@property(nonatomic,assign) CGFloat lengendHeightOrWidth;

/**
 大半径，relate to lengendPosition, default to self.width or self.height - lengendHeightOrWidth
 */
@property(nonatomic,assign) CGFloat outerCircleRadius;

/**
 小半径，default to 0.f, like a ring circle ，HLPieViewTypeRoundRing
 */
@property(nonatomic,assign) CGFloat interCircleRadius;

/**
 图例位置，default to HLPieLengendPositionTop
 */
@property(nonatomic,assign) HLPieLengendPosition lengendPosition;

/**
 显示的详情文本类型，default to HLPieDetailTextTypeProportion
 */
@property(nonatomic,assign) HLPieDetailTextType pieDetailTextType;

/**
 图例文本颜色,default to blackColor
 */
@property(nonatomic,strong) UIColor *lengendTextColor;

/**
 是否动画，default to yes
 */
@property(nonatomic,assign) BOOL isAnimatedDisplay;

/**
 标题属性，不设置则不会显示标题
 */
@property(nonatomic,strong) UIFont *titleFont;
@property(nonatomic,copy)   NSString *titleText;
@property(nonatomic,strong) UIColor *titleColor;


/**
 绘制,最后调用
 */
- (void)strokeStart;




@end
