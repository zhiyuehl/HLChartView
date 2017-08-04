//
//  HLPieLengendView.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/24.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "HLPieLengendView.h"

#define LengendColorLayerHeight 6

@implementation HLPieLengendView

- (instancetype)initWithFrame:(CGRect)frame
   lengendViewWithLengendText:(NSString *)lengendText
                 lengendColor:(UIColor *)lengengColor
             lengendTextColor:(UIColor *)lengendTextColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = lengengColor.CGColor;
        layer.position = CGPointMake(LengendColorLayerHeight/2, self.frame.size.height/2);
        layer.bounds = CGRectMake(0, 0, LengendColorLayerHeight, LengendColorLayerHeight);
        [self.layer addSublayer:layer];
        
        UILabel *lengendLabel = [[UILabel alloc]init];
        lengendLabel.text = lengendText;
        lengendLabel.font = [UIFont systemFontOfSize:11];
        lengendLabel.textColor = lengendTextColor;
        lengendLabel.frame = CGRectMake(LengendColorLayerHeight+2, 0, self.frame.size.width-LengendColorLayerHeight-2, self.frame.size.height);
        lengendLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:lengendLabel];
        
    }
    return self;
}



@end
