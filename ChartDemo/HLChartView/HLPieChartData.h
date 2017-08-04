//
//  HLPieChartData.h
//  AnimationDemo
//
//  Created by tederen on 2017/7/21.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLPieChartData : NSObject

/**
 文字
 */
@property(nonatomic,copy)   NSString *detailText;

/**
 值
 */
@property(nonatomic,copy) NSString *value;

/**
 文本颜色，default to blackColor
 */
@property(nonatomic,strong) UIColor *lengendTextColor;

/**
 饼颜色
 */
@property(nonatomic,strong) UIColor *pieChartColor;

/**
 百分比
 */
@property(nonatomic,copy)   NSString *percentStr;

/**
 百分比
 */
@property(nonatomic,assign) CGFloat percent;


/**
 chart data

 @param value 数值
 @param pieChartColor 填充颜色
 @param detailText 字体颜色
 @return chart
 */
+ (instancetype)pieDataWithValue:(NSString *)value
                   pieChartColor:(UIColor *)pieChartColor
                      detailText:(NSString *)detailText;




@end
