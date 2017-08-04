//
//  HLPieChartView.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/21.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "HLPieChartView.h"
#import "HLPieLengendView.h"


#define LengendViewGap 5.f

@interface HLPieChartView ()

//动画执行时长，default to 0.8
@property(nonatomic,assign) NSTimeInterval animationAllTime;

/**
 标题，默认上方。如果不设置则图例会靠近最上
 */
@property(nonatomic,strong)   UILabel *pieTitleLabel;

/**
 图例的宽高
 */
@property(nonatomic,assign) CGFloat lengendWidth;
@property(nonatomic,assign) CGFloat lengendHeight;

@end


@implementation HLPieChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialBase];
    }
    return self;
}


- (void)initialBase
{
    self.showLengendView = YES;
    self.isAnimatedDisplay = YES;
    
    self.lengendPosition = HLPieLengendPositionTop;
    self.pieDetailTextType = HLPieDetailTextTypeProportion;
//    self.pieType = HLPieViewTypeRoundCake;
    
    self.lengendTextColor = [UIColor blackColor];
    
    self.lengendHeightOrWidth = 50.f;
    self.animationAllTime = 0.8;
    self.lengendWidth = 60;
    self.lengendHeight = 20;
    
    //外圈半径
    self.outerCircleRadius = self.width > self.height ? (self.height - self.lengendHeightOrWidth)/2 : (self.width - self.lengendHeightOrWidth)/2;

}

#pragma mark ------------------------stroke
//绘制饼
- (void)strokeStart
{
    //先移除所有的子视图和layer
    NSMutableArray *arr1 = self.subviews.mutableCopy;
    for (UIView *view in arr1) {
        if (view == self.pieTitleLabel) {
            continue;
        }
        [view removeFromSuperview];
    }
    NSMutableArray *arr2 = self.layer.sublayers.mutableCopy;
    for (CALayer *layer in arr2) {
        if (layer == self.pieTitleLabel.layer) {
            continue;
        }
        [layer removeFromSuperlayer];
        [layer removeAllAnimations];
    }
    
    if (self.pieDatas.count == 0) {
        return;
    }
    //总值
     __block CGFloat allValue = 0.f;
    [self.pieDatas enumerateObjectsUsingBlock:^(HLPieChartData * _Nonnull pieData, NSUInteger idx, BOOL * _Nonnull stop) {
        allValue += [pieData.value floatValue];
        pieData.lengendTextColor = self.lengendTextColor;
    }];
    //总值为0，
    if (allValue == 0) {
        return;
    }
    
    [self.pieDatas enumerateObjectsUsingBlock:^(HLPieChartData * _Nonnull pieData, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat percent = [pieData.value floatValue] / allValue;
        pieData.percent = percent;
        pieData.percentStr = [NSString stringWithFormat:@"%.1lf%%",percent*100];
    }];
    
    //cicle
    __block CGFloat startPercent = 0.f;
    __block CGFloat endPercent = 0.f;
    [self.pieDatas enumerateObjectsUsingBlock:^(HLPieChartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //结束百分比。与y轴正方向比较0（M_PI_2*3）
        endPercent = obj.percent + startPercent;
        CAShapeLayer *shapeLayer = [self shaperLayerWithStartPercent:startPercent endPercent:endPercent circleRadius:self.outerCircleRadius filleColor:obj.pieChartColor];
        
        //animated
        if (self.isAnimatedDisplay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationAllTime*startPercent * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.layer addSublayer:shapeLayer];
            });
            [self animatedDisplayWithLayer:shapeLayer duration:self.animationAllTime*(endPercent-startPercent)];
        }else {
            [self.layer addSublayer:shapeLayer];
        }
        [self showDetailTextWithChartData:obj startPercent:startPercent endPercent:endPercent];
        //起始百分比
        startPercent += obj.percent;
    }];
    
    //lengendView
    if (self.showLengendView) {
        [self strokeLengendView];
    }
    
}

//展示每部分详情文字
- (void)showDetailTextWithChartData:(HLPieChartData *)chartData
                         startPercent:(CGFloat)startPercent
                           endPercent:(CGFloat)endPercent
{
    if (self.pieDetailTextType == HLPieDetailTextTypeNono) {
        return;
    }else {
        
        CGFloat startAngle = startPercent*M_PI*2;
        CGFloat endAngle = endPercent*M_PI*2;
        CGFloat positionAngle = (endAngle - startAngle)/2 + startAngle;
        
        CGPoint circleCenter = CGPointMake(self.width/2, self.height/2);
        CGFloat lineWidth = self.outerCircleRadius-self.interCircleRadius;
        CGFloat radius = self.interCircleRadius+lineWidth/2;
        //求得label的中心点位置
        CGPoint position = CGPointMake(radius*sin(positionAngle),radius*cos(positionAngle));
        
        UILabel *detailText = [[UILabel alloc]init];
        detailText.textColor = [UIColor whiteColor];
        detailText.center = CGPointMake(circleCenter.x + position.x, circleCenter.y - position.y);
        detailText.textAlignment = NSTextAlignmentCenter;
        //如果没有图例的话，就在详情上展示
        if (self.showLengendView) {
            if (self.pieDetailTextType == HLPieDetailTextTypeProportion) {
                detailText.text = chartData.percentStr;
            }else {
                detailText.text = chartData.value;
            }
            detailText.bounds = CGRectMake(0, 0, lineWidth, 20);
            detailText.font = [UIFont systemFontOfSize:11];
        }else {
            if (self.pieDetailTextType == HLPieDetailTextTypeProportion) {
                detailText.text = [NSString stringWithFormat:@"%@\n%@",chartData.percentStr,chartData.detailText];
            }else {
                detailText.text = [NSString stringWithFormat:@"%@\n%@",chartData.value,chartData.detailText];
            }
            detailText.numberOfLines = 2;
            detailText.bounds = CGRectMake(0, 0, lineWidth, 40);
            detailText.font = [UIFont systemFontOfSize:10];
        }
        
        if (self.isAnimatedDisplay) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.animationAllTime*(startPercent + (endPercent-startPercent)/2) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self addSubview:detailText];
                detailText.alpha = 0;
                [UIView animateWithDuration:0.3 animations:^{
                    detailText.alpha = 1;
                }];
            });
        }else {
            [self addSubview:detailText];
        }
    }
}


//图例
- (void)strokeLengendView
{
    switch (self.lengendPosition) {
        case HLPieLengendPositionTop:
        case HLPieLengendPositionBottom:
        {
            CGFloat startX = (self.width - (self.lengendWidth*self.pieDatas.count + LengendViewGap*(self.pieDatas.count-1)))/2;
            CGFloat startY = self.lengendPosition == HLPieLengendPositionTop ? 10 : (self.height-self.lengendHeight-10);
            //标题存在
            if (_pieTitleLabel && self.lengendPosition == HLPieLengendPositionTop) {
                startY = 50;
            }
            
            [self.pieDatas enumerateObjectsUsingBlock:^(HLPieChartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *lengendText = obj.detailText;
                UIColor *lengendColor = obj.pieChartColor;
                UIColor *lengendTextColor = obj.lengendTextColor;
                
                HLPieLengendView *lengendView = [[HLPieLengendView alloc]initWithFrame:CGRectMake(startX + (self.lengendWidth+LengendViewGap)*idx, startY, self.lengendWidth, self.lengendHeight) lengendViewWithLengendText:lengendText lengendColor:lengendColor lengendTextColor:lengendTextColor];
                [self addSubview:lengendView];
                
            }];
        }
            break;
        case HLPieLengendPositionRightTop:
        case HLPieLengendPositionLeftTop:
        {
            CGFloat startX = self.lengendPosition == HLPieLengendPositionLeftTop ? 10 : (self.width-self.lengendWidth-10);
            CGFloat startY = 10;
            
            [self.pieDatas enumerateObjectsUsingBlock:^(HLPieChartData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *lengendText = obj.detailText;
                UIColor *lengendColor = obj.pieChartColor;
                UIColor *lengendTextColor = obj.lengendTextColor;
                
                HLPieLengendView *lengendView = [[HLPieLengendView alloc]initWithFrame:CGRectMake(startX , startY + (self.lengendHeight+LengendViewGap)*idx, self.lengendWidth, self.lengendHeight) lengendViewWithLengendText:lengendText lengendColor:lengendColor lengendTextColor:lengendTextColor];
                [self addSubview:lengendView];
                
            }];
        }
            break;
            
        default:
            break;
    }
}


/**
 动画

 @param layer layer
 @param duration 时长
 */
- (void)animatedDisplayWithLayer:(CALayer *)layer duration:(CGFloat)duration
{
    CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation1.fromValue = @0;
    animation1.toValue = @1;
    animation1.duration = duration;
    animation1.removedOnCompletion = NO;
    animation1.fillMode = kCAFillModeForwards;
    [layer addAnimation:animation1 forKey:nil];
}


/**
 绘制圆

 @param startPercent 开始的比例 0.0~1.0,按M_PI_2*3顺时针开始
 @param endPercent 结束的比例 0.0~1.0,按M_PI_2*3顺时针开始
 @param circleRadius 大的半径，如果有self.interCircleRadius，则会自动减去中间小圆
 @param fillColor 填充颜色
 @return layer
 */
- (CAShapeLayer *)shaperLayerWithStartPercent:(CGFloat)startPercent
                                   endPercent:(CGFloat)endPercent
                                 circleRadius:(CGFloat)circleRadius
                                   filleColor:(UIColor *)fillColor
{
    CGFloat startAngle = M_PI_2*3 + startPercent*M_PI*2;
    CGFloat endAngle = M_PI_2*3 + endPercent*M_PI*2;
        
    CGPoint circleCenter = CGPointMake(self.width/2, self.height/2);
    CGFloat lineWidth = circleRadius-self.interCircleRadius;
    CGFloat radius = self.interCircleRadius+lineWidth/2;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:circleCenter radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = fillColor.CGColor;
    shapeLayer.lineWidth = lineWidth;
    return shapeLayer;
}

#pragma mark ------------------------setter

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    self.pieTitleLabel.font = titleFont;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    self.pieTitleLabel.textColor = titleColor;
}

- (void)setTitleText:(NSString *)titleText
{
    _titleText = titleText;
    self.pieTitleLabel.text = titleText;
    [self addSubview:self.pieTitleLabel];
}


#pragma mark ------------------------getter

- (UILabel *)pieTitleLabel
{
    if (!_pieTitleLabel) {
        _pieTitleLabel = [[UILabel alloc]init];
        _pieTitleLabel.width = self.width-60;
        _pieTitleLabel.y = 10;
        _pieTitleLabel.x = 30;
        _pieTitleLabel.height = 30;
        _pieTitleLabel.textColor = [UIColor blackColor];
        _pieTitleLabel.textAlignment = NSTextAlignmentCenter;
        _pieTitleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _pieTitleLabel;
}



@end


















