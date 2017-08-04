# HLChartView
a collection of t highly custom chart (histogram, pie chart, line chart) 


how to use ?
cocoapods

```
pod 'HLChartView'
```

### chart gif 

![](https://github.com/zhiyuehl/Animation-And-Chart/raw/master/QQ20170803-165718-HD.gif)  


### chart : highly custom chart, if there is some bug, please inform me，thanks

### line chart 
```
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

```

### bar chart 
```
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
```

### pie chart
```
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

```
