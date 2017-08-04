//
//  HLPieLengendView.h
//  AnimationDemo
//
//  Created by tederen on 2017/7/24.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLPieLengendView : UIView


/**
 图例

 @param frame frame
 @param lengendText 文本
 @param lengengColor 图例颜色
 @param lengendTextColor 字体颜色
 @return lengend
 */
- (instancetype)initWithFrame:(CGRect)frame
   lengendViewWithLengendText:(NSString *)lengendText
                 lengendColor:(UIColor *)lengengColor
             lengendTextColor:(UIColor *)lengendTextColor;


@end
