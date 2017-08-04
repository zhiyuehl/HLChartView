//
//  HLLineChartView.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/20.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "HLLineChartView.h"


#define YLabelHeight 20.f

#define Gap 10.f

//x坐标轴x值
#define XLabelPointX(i) (self.xLabelsWidth/2+self.xLabelsWidth*i + Gap*(i+1))

//y坐标轴y值
#define YLabelPointY(i) (self.topGap+self.sepYLength*i)

//圆点半径
#define CircleDotRadius 3.f
//动画时长
#define OneValueAniamtedTime 0.2f

@interface HLLineChartView ()

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,assign) NSInteger maxYValue;  //y轴最大值

@property(nonatomic,assign) CGFloat maxXLength;  //x轴滚动最大长度

@property(nonatomic,assign) CGFloat sepYLength;  //y轴每一格长度


@end

@implementation HLLineChartView


#pragma mark ------------------------init

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
    self.yLablesColor = [UIColor grayColor];
    self.xLabelsColor = [UIColor grayColor];
    self.chartBackgroundColor = [UIColor whiteColor];
    self.yValuesColor = [UIColor redColor];
    
    self.isShowGradientColor = YES;
    self.isShowXSepratorLine = YES;
    self.isShowYSepratorLine = YES;
    self.isAnimatedDisplay = YES;
    self.isHideXLables = NO;
    self.isHideYLabels = NO;
    self.isHideYValues = NO;
    
    self.xLabelsWidth = 50.f;
    self.xLabelsHeight = 50.f;
    self.ySepLabelCount = 5;
    self.yLabelWidth = 30.0f;
    
    self.topGap = 20.0f;
    
    self.lineChartType = HLLineChartTypeCurve;
    
    self.backgroundColor = self.chartBackgroundColor;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
}


#pragma mark ------------------------stroke

- (void)strokeStart
{
    //先移除所有的子视图和layer
    NSMutableArray *arr1 = self.subviews.mutableCopy;
    for (UIView *view in arr1) {
        [view removeFromSuperview];
    }
    NSMutableArray *arr2 = self.layer.sublayers.mutableCopy;
    for (CALayer *layer in arr2) {
        [layer removeFromSuperlayer];
        [layer removeAllAnimations];
    }
    
    if (self.yValueLabels.count == 0 || self.xLabels.count == 0) {
        return;
    }
    
    CGFloat yLength = self.height-self.xLabelsHeight-self.topGap;
    //y轴每一格长度
    self.sepYLength = yLength/self.ySepLabelCount;

    CGFloat maxY = 0.0;
    for (NSInteger i = 0; i < self.yValueLabels.count; i ++) {
        HLLineChartData *data = self.yValueLabels[i];
        for (int j = 0; j < data.valuesArray.count-1; j ++) {
            if ([data.valuesArray[j] floatValue] < [data.valuesArray[j+1] floatValue]) {
                maxY = [data.valuesArray[j+1] floatValue];
            }
        }
    }
    
    //y轴最大值
    self.maxYValue = (ceil(maxY/self.ySepLabelCount))*self.ySepLabelCount;
    
    
    //yLabels
    if (!self.isHideYLabels) {
        [self strokeYLabels];
    }
    
    [self addSubview:self.scrollView];
    //x轴滚动最大长度
    self.maxXLength = (self.xLabelsWidth+Gap)*(self.xLabels.count)+self.xLabelsWidth/2;
    
    //xLabels
    if (!self.isHideXLables) {
        [self strokeXLabels];
    }
    
    //y轴分割线
    [self strokeYSepratorLine];
    
    //X轴分割线
    [self strokeXSepratorLine];
    
    //yValues
    [self strokeYValues];
    
    
    
}
//绘图
- (void)strokeYValues
{
    //收集所有的点
    NSMutableArray *pointsArray = @[].mutableCopy;
    
    for (int i = 0; i < self.yValueLabels.count; i ++) {
        NSMutableArray *arr = @[].mutableCopy;
        HLLineChartData *data = self.yValueLabels[i];
        for (int j = 0; j < data.valuesArray.count; j ++) {
            CGFloat yValues = [data.valuesArray[j] floatValue];
            //x点坐标
            CGFloat xPoint =  XLabelPointX(j);
            //y点坐标
            CGFloat yPoint = self.height-self.xLabelsHeight-(yValues/self.maxYValue * self.sepYLength*self.ySepLabelCount);
            CGPoint point = CGPointMake(xPoint, yPoint);
            
            [arr addObject:[NSValue valueWithCGPoint:point]];
        }
        [pointsArray addObject:arr];
    }
    
    
    //开始绘制
    for (int j = 0; j < pointsArray.count; j ++) {
        //path
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.f;
        NSArray *values = pointsArray[j];
        if (values.count == 0) {
            continue;
        }
        NSValue *value = values[0];
        [path moveToPoint:[value CGPointValue]];
        
        for (NSInteger i = 0; i < values.count; i ++) {
            if (i == 0) {
                continue;
            }
            NSValue *pointValue = values[i];
            //当前点
            CGPoint currentPoint = [pointValue CGPointValue];
            
            if (self.lineChartType == HLLineChartTypeBrokenLine) {
                //折线
                [path addLineToPoint:currentPoint];
            }else if (self.lineChartType == HLLineChartTypeCurve) {
                //曲线
                //上一个点
                CGPoint lastPoint = [values[i-1] CGPointValue];
                
                [path addCurveToPoint:currentPoint controlPoint1:CGPointMake((currentPoint.x+lastPoint.x)/2, lastPoint.y) controlPoint2:CGPointMake((currentPoint.x+lastPoint.x)/2, currentPoint.y)];
            }
        }
        HLLineChartData *data = self.yValueLabels[j];

        //layer
        CAShapeLayer *shaperLayer = [CAShapeLayer layer];
        shaperLayer.path = path.CGPath;
        shaperLayer.strokeColor = data.lineColor.CGColor;
        shaperLayer.fillColor = [UIColor clearColor].CGColor;
        shaperLayer.fillMode = kCAFillModeForwards;
        shaperLayer.lineWidth = data.lineWidth;
        [self.scrollView.layer addSublayer:shaperLayer];
        
        //动画
        if (self.isAnimatedDisplay) {
            CABasicAnimation *animation1 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            animation1.fromValue = @0;
            animation1.toValue = @1;
            animation1.duration = OneValueAniamtedTime*values.count;
            [shaperLayer addAnimation:animation1 forKey:nil];
        }
        //渐变
        if (self.isShowGradientColor) {
                
                CGPoint startPoint = [values.firstObject CGPointValue];
                CGPoint endPoint = [values.lastObject CGPointValue];
                [path addLineToPoint:CGPointMake(endPoint.x, self.height-self.xLabelsHeight)];
                [path addLineToPoint:CGPointMake(startPoint.x, self.height-self.xLabelsHeight)];
                [path addLineToPoint:startPoint];
                
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.path = path.CGPath;
                
                CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                gradientLayer.frame = CGRectMake(startPoint.x, 0, 0, self.height);
                gradientLayer.startPoint = CGPointMake(0, 0);
                gradientLayer.endPoint = CGPointMake(0, 1);
                gradientLayer.colors = @[(__bridge id)[data.lineColor colorWithAlphaComponent:0.5].CGColor,(__bridge id)[data.lineColor colorWithAlphaComponent:0].CGColor];
                
                CALayer *layer = [CALayer layer];
                [layer addSublayer:gradientLayer];
                layer.mask = maskLayer;
                
                [self.scrollView.layer addSublayer:layer];
                
                CABasicAnimation *anmi1 = [CABasicAnimation animation];
                anmi1.keyPath = @"bounds.size.width";
                anmi1.duration = OneValueAniamtedTime*(values.count+1);
                anmi1.toValue = @(self.maxXLength*2-2*self.xLabelsWidth);
                anmi1.fillMode = kCAFillModeForwards;
                anmi1.removedOnCompletion = NO;
                if (self.isAnimatedDisplay) {
                    [gradientLayer addAnimation:anmi1 forKey:nil];
                }
            }

    }
    //yValues圆点和值
    [self strokeCircleDotWithPointArray:pointsArray];

    
}

//yValues圆点和值
- (void)strokeCircleDotWithPointArray:(NSArray *)pointArray
{
    for (int j = 0; j <pointArray.count; j ++) {
        HLLineChartData *data = self.yValueLabels[j];
        NSArray *arr = pointArray[j];
        
        for (int i = 0; i < arr.count; i ++) {
            CGPoint point = [arr[i] CGPointValue];
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path addArcWithCenter:point radius:data.circleSize startAngle:0 endAngle:M_PI*2 clockwise:YES];

            CAShapeLayer *shaperLayer = [CAShapeLayer layer];
            
            if (data.circleType == HLLineDataCircleTypePoint) { //圆点
                shaperLayer.path = path.CGPath;
                shaperLayer.fillColor = data.lineColor.CGColor;
                shaperLayer.fillMode = kCAFillModeForwards;
            }else if (data.circleType == HLLineDataCircleTypeCircle) {  //圆环
                shaperLayer.path = path.CGPath;
                shaperLayer.fillColor = [UIColor whiteColor].CGColor;
                shaperLayer.fillMode = kCAFillModeForwards;
                shaperLayer.lineWidth = data.lineWidth;
                shaperLayer.strokeColor = data.lineColor.CGColor;
            }
            
            
            [self.scrollView.layer addSublayer:shaperLayer];
            
            if (self.isHideYValues) {
                continue;
            }
            HLLineChartData *data = self.yValueLabels[j];
            CATextLayer *yValue = [CATextLayer layer];
            yValue.string = [NSString stringWithFormat:@"%@",data.valuesArray[i]];
            yValue.fontSize = data.yValueFont;
            yValue.foregroundColor = data.yValuesColor.CGColor;
            yValue.bounds = CGRectMake(0, 0, self.yLabelWidth-5, 16);
            yValue.position = CGPointMake(point.x, point.y-8);
            yValue.alignmentMode = kCAAlignmentCenter;
            yValue.contentsScale = [UIScreen mainScreen].scale;//不设置会导致字体模糊
            yValue.wrapped = YES;
            [self.scrollView.layer addSublayer:yValue];
        }
    }
}



//x轴和分割线
- (void)strokeYSepratorLine
{
    for (int i = 0; i < self.ySepLabelCount+1; i ++) {
        if (!self.isShowYSepratorLine && i != self.ySepLabelCount) {
            return;
        }
        
        //y点
        CGFloat y =  YLabelPointY(i);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0,y)];
        [path addLineToPoint:CGPointMake(self.maxXLength-self.xLabelsWidth/2, y)];
        path.lineWidth = 1.f;
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        if (i < self.ySepLabelCount) {
            shapeLayer.lineDashPhase = 1;
            shapeLayer.lineDashPattern = @[@3,@3];
        }
        
        [self.scrollView.layer addSublayer:shapeLayer];
    }

}

//y轴和分割线
- (void)strokeXSepratorLine
{
    //y轴
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(self.yLabelWidth,self.height-self.xLabelsHeight)];
    [path addLineToPoint:CGPointMake(self.yLabelWidth, self.topGap)];
    path.lineWidth = 1.f;
    
    CAShapeLayer *yShapeLayer = [CAShapeLayer layer];
    yShapeLayer.path = path.CGPath;
    yShapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:yShapeLayer];
    
    if (!self.isShowXSepratorLine) {
        return;
    }
    //分割线
    for (int i = 0; i < self.xLabels.count; i ++) {
        //x点坐标
        CGFloat x =  XLabelPointX(i);
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(x,self.height-self.xLabelsHeight)];
        [path addLineToPoint:CGPointMake(x, self.topGap)];
        path.lineWidth = 1.f;
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
        shapeLayer.lineDashPhase = 1;
        shapeLayer.lineDashPattern = @[@3,@3];
        
        [self.scrollView.layer addSublayer:shapeLayer];
    }
    
    
}
//xLabels
- (void)strokeXLabels
{
    for (NSInteger i = 0; i < self.xLabels.count; i ++) {
        //x点坐标
        CGFloat x =  XLabelPointX(i);
        
        CATextLayer *xText = [CATextLayer layer];
        xText.string = self.xLabels[i];
        xText.fontSize = 11;
        xText.alignmentMode = kCAAlignmentCenter;
        xText.foregroundColor = self.xLabelsColor.CGColor;
        xText.position = CGPointMake(x, self.height-self.xLabelsHeight/2);
        xText.bounds = CGRectMake(0, 0, self.xLabelsWidth, self.xLabelsHeight);
        xText.contentsScale = [UIScreen mainScreen].scale;//不设置会导致字体模糊
        xText.wrapped = YES;
        xText.truncationMode = kCATruncationEnd;
        [self.scrollView.layer addSublayer:xText];
    }
    self.scrollView.contentSize = CGSizeMake(self.maxXLength, 0);
    
}

//yLabels
- (void)strokeYLabels
{
    for (int i = 0; i < self.ySepLabelCount+1; i ++) {
        //y点
        CGFloat y =  YLabelPointY(i);
        
        CATextLayer *yText = [CATextLayer layer];
        yText.string = [NSString stringWithFormat:@"%ld",self.maxYValue - self.maxYValue/self.ySepLabelCount*i];
        yText.fontSize = 12;
        yText.foregroundColor = self.yLablesColor.CGColor;
        yText.bounds = CGRectMake(0, 0, self.yLabelWidth-5, YLabelHeight);
        yText.position = CGPointMake(self.yLabelWidth/2, y);
        yText.alignmentMode = kCAAlignmentRight;
        yText.contentsScale = [UIScreen mainScreen].scale;//不设置会导致字体模糊
        yText.wrapped = YES;
        [self.layer addSublayer:yText];
    }
}




#pragma mark ------------------------setter

- (void)setChartBackgroundColor:(UIColor *)chartBackgroundColor
{
    _chartBackgroundColor = chartBackgroundColor;
    
    self.backgroundColor = _chartBackgroundColor;
}


#pragma mark ------------------------getter

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.yLabelWidth, 0, self.width-self.yLabelWidth-Gap, self.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
    }
    return _scrollView;
}










@end
