//
//  HLHistogramView.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/28.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "HLHistogramView.h"
#import "UIView+SetRect.h"

//动画时长
#define OneValueAniamtedTime 0.8f
//y坐标高度
#define YLabelHeight 20.f

//柱状左右间距
#define Gap 10.f

//y坐标轴y值
#define YLabelPointY(i) (self.topGap+self.sepYLength*i)

@interface HLHistogramView ()

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,assign) NSInteger maxYValue;  //y轴最大值

@property(nonatomic,assign) CGFloat maxXLength;  //x轴滚动最大长度

@property(nonatomic,assign) CGFloat sepYLength;  //y轴每一格长度

@property(nonatomic,strong) NSMutableArray *startXArray;

@end

@implementation HLHistogramView

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
    self.xLabelsColor = [UIColor grayColor];
    
    self.xHistogramMinGap = 0.0f;
    self.xHistogramMaxGap = 25.0f;
    self.histogramWidth = 20.0f;
    self.xLabelsHeight = 50.0f;
    self.ySepLabelCount = 5;
    self.yLabelWidth = 30.f;
    
    self.topGap = 20.0f;
    
    self.isAnimatedDisplay = YES;
    self.isHideYLabels = NO;
    self.isHideYValues = NO;
    
    self.yLablesColor = [UIColor grayColor];
    
    self.maxXLength = Gap*2;
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
    
    if (self.xLabels.count != self.yValueLabels.count) {
        return;
    }
    
    
    CGFloat yLength = self.height-self.xLabelsHeight-self.topGap;
    //y轴每一格长度
    self.sepYLength = yLength/self.ySepLabelCount;
    
    //获取数据中的最大值
    __block CGFloat maxY = 0.0f;
    //x轴滚动最大长度
    [self.yValueLabels enumerateObjectsUsingBlock:^(NSArray<HLHistogramData *> * _Nonnull arr, NSUInteger idx1, BOOL * _Nonnull stop1) {
        
        [arr enumerateObjectsUsingBlock:^(HLHistogramData * _Nonnull data, NSUInteger idx2, BOOL * _Nonnull stop2) {
            if ([data.value floatValue] > maxY) {
                maxY = [data.value floatValue];
            }
        }];
        
    }];
    //y轴刻度最大值
    self.maxYValue = (ceil(maxY/self.ySepLabelCount))*self.ySepLabelCount;
    
    //每个data的高度和x轴中心点
    __block CGFloat startGroupX = 2*Gap;
    __block CGFloat startX = 0.f;
    
    self.startXArray = @[].mutableCopy;
    
    [self.yValueLabels enumerateObjectsUsingBlock:^(NSArray<HLHistogramData *> * _Nonnull arr, NSUInteger idx1, BOOL * _Nonnull stop1) {
        
        NSMutableArray *startXArr = @[].mutableCopy;
        
        CGFloat width = self.histogramWidth*arr.count + self.xHistogramMinGap*(arr.count-1);
        startX = startGroupX;
        [arr enumerateObjectsUsingBlock:^(HLHistogramData * _Nonnull data, NSUInteger idx2, BOOL * _Nonnull stop2) {
            data.height = [data.value floatValue] / self.maxYValue * self.sepYLength * self.ySepLabelCount;
            
            [startXArr addObject:@(startX+self.histogramWidth/2 + idx2*(self.histogramWidth+_xHistogramMinGap))];
        }];
        startGroupX += (width+self.xHistogramMaxGap);
        [self.startXArray addObject:startXArr];
    }];
    
    if (!self.isHideYLabels) {
        [self strokeYLabels];
    }
    
    [self addSubview:self.scrollView];
    
    ////x轴滚动最大长度
    for (int i = 0; i < self.yValueLabels.count; i ++) {
        NSArray *arr = self.yValueLabels[i];
        self.maxXLength += (arr.count*self.histogramWidth + self.xHistogramMinGap*(arr.count-1)+self.xHistogramMaxGap);
    }
    self.scrollView.contentSize = CGSizeMake(self.maxXLength, 0);

    //xy轴
    [self strokXShaft];
    [self strokeYShaft];
    
    //x坐标
    [self strokeXLabels];
    
    // 绘制柱状图
    [self strokeHistogram];
    
    
}

/**
 绘制柱状
 */
- (void)strokeHistogram
{
    [self.yValueLabels enumerateObjectsUsingBlock:^(NSArray<HLHistogramData *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        [obj enumerateObjectsUsingBlock:^(HLHistogramData * _Nonnull obj2, NSUInteger idx2, BOOL * _Nonnull stop2) {
            NSArray *arr = self.startXArray[idx];
            CGFloat startX = [arr[idx2] floatValue];
            CGPoint startPoint = CGPointMake(startX, self.height-self.xLabelsHeight);
            
            CAShapeLayer *shapeLayer = [self shapeLayerWithStartPoint:startPoint histogramData:obj2 width:self.histogramWidth];
            [self.scrollView.layer addSublayer:shapeLayer];
            //动画
            if (self.isAnimatedDisplay) {
                [self animationHistogramWithShapeLayer:shapeLayer histogramData:obj2];
            }
            //y值
            if (!self.isHideYValues) {
                CATextLayer *textLayer = [self textLayerWithStartPoint:startPoint histogramData:obj2 width:self.histogramWidth];
                [self.scrollView.layer addSublayer:textLayer];
            }
        }];
        
    }];
    
}

- (CATextLayer *)textLayerWithStartPoint:(CGPoint)startPoint histogramData:(HLHistogramData *)histogramData width:(CGFloat)width
{
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = histogramData.value;
    textLayer.fontSize = 10;
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.foregroundColor = histogramData.histogramColor.CGColor;
    textLayer.position = CGPointMake(startPoint.x, startPoint.y-histogramData.height-5-1);
    textLayer.bounds = CGRectMake(0, 0, width, 10);
    textLayer.contentsScale = [UIScreen mainScreen].scale;//不设置会导致字体模糊
    textLayer.wrapped = YES;
    textLayer.truncationMode = kCATruncationEnd;
    
    return textLayer;
}



- (void)animationHistogramWithShapeLayer:(CAShapeLayer *)layer histogramData:(HLHistogramData *)histogramData
{
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    anima.fromValue = @0;
    anima.toValue = @1;
    anima.duration = OneValueAniamtedTime*histogramData.height/self.maxYValue;
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [layer addAnimation:anima forKey:nil];
    
}



- (CAShapeLayer *)shapeLayerWithStartPoint:(CGPoint)startPoint histogramData:(HLHistogramData *)histogramData width:(CGFloat)width
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    [path addLineToPoint:CGPointMake(startPoint.x, startPoint.y-histogramData.height)];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.lineWidth = width;
    shapeLayer.strokeColor = histogramData.histogramColor.CGColor;
    
    return shapeLayer;
}


/**
 x坐标
 */
- (void)strokeXLabels
{
    __block CGFloat startX = Gap*2;

    [self.yValueLabels enumerateObjectsUsingBlock:^(NSArray<HLHistogramData *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGFloat width = self.histogramWidth*obj.count + self.xHistogramMinGap*(obj.count-1);
        
        CATextLayer *xText = [CATextLayer layer];
        xText.string = self.xLabels[idx];
        xText.fontSize = 11;
        xText.alignmentMode = kCAAlignmentCenter;
        xText.foregroundColor = self.xLabelsColor.CGColor;
        xText.position = CGPointMake(startX+width/2, self.height-self.xLabelsHeight/2);
        xText.bounds = CGRectMake(0, 0, width, self.xLabelsHeight);
        xText.contentsScale = [UIScreen mainScreen].scale;//不设置会导致字体模糊
        xText.wrapped = YES;
        xText.truncationMode = kCATruncationEnd;
        [self.scrollView.layer addSublayer:xText];
        
        startX += (width+self.xHistogramMaxGap);
        
    }];
}

/**
 y轴
 */
- (void)strokeYShaft
{
    //y轴
    UIBezierPath *yPath = [UIBezierPath bezierPath];
    [yPath moveToPoint:CGPointMake(self.yLabelWidth,self.height-self.xLabelsHeight)];
    [yPath addLineToPoint:CGPointMake(self.yLabelWidth, self.topGap)];
    yPath.lineWidth = 1.f;
    
    CAShapeLayer *yShapeLayer = [CAShapeLayer layer];
    yShapeLayer.path = yPath.CGPath;
    yShapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [self.layer addSublayer:yShapeLayer];
}

/**
 x轴
 */
- (void)strokXShaft
{
    
    //x轴
    UIBezierPath *xPath = [UIBezierPath bezierPath];
    [xPath moveToPoint:CGPointMake(0,self.height-self.xLabelsHeight)];
    [xPath addLineToPoint:CGPointMake(self.maxXLength, self.height-self.xLabelsHeight)];
    xPath.lineWidth = 1.f;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = xPath.CGPath;
    shapeLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    [self.scrollView.layer addSublayer:shapeLayer];
    

}


/**
 y轴坐标
 */
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
