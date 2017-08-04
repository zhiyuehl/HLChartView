//
//  LineChartViewController.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/20.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "LineChartViewController.h"
#import "HLLineChartView.h"

@interface LineChartViewController ()

@end

@implementation LineChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    HLLineChartView *lineChartView = [[HLLineChartView alloc]initWithFrame:CGRectMake(0, 100, kScreen_Width, 300)];
    
    
    NSArray *arr1 = @[@"3",@"4.3",@"10.2",@"5",@"15",@"3",@"4.3",@"10.2",@"5",@"1"];
    NSArray *arr2 = @[@"2",@"6.3",@"6.2",@"15",@"10",@"2",@"14.3",@"5.2",@"11",@"4"];
    HLLineChartData *data1 = [HLLineChartData lineChartDataWithValuesArray:arr1 lineColor:[UIColor redColor]];
    data1.yValuesColor = [UIColor greenColor];
    data1.lineWidth = 3.0f;
    data1.circleSize = 5;
    data1.circleType = HLLineDataCircleTypeCircle;
    
    HLLineChartData *data2 = [HLLineChartData lineChartDataWithValuesArray:arr2 lineColor:[UIColor blueColor]];
    
    lineChartView.yValueLabels = @[data1,data2];
    
    lineChartView.xLabels = @[@"中通快递123",@"圆通快递1",@"顺丰快递1222222222222222222222222",@"邮政快递2111",@"韵达快递22222",@"中通快递11111",@"圆通快递",@"顺丰快递",@"邮政快递",@"韵达快递"];
    
    [self.view addSubview:lineChartView];
    
    
    lineChartView.yLablesColor = [UIColor greenColor];
    lineChartView.xLabelsColor = [UIColor blueColor];
//    lineChartView.lineChartType = HLLineChartTypeBrokenLine;
    lineChartView.ySepLabelCount = 10;
//    lineChartView.xLabelsWidth = 30;
//    lineChartView.xLabelsHeight = 20;
//    lineChartView.lineColor = [UIColor brownColor];
//    lineChartView.isHideYLabels = YES;
//    lineChartView.isHideXLables = YES;
    
    lineChartView.isShowGradientColor = NO;
//    lineChartView.isShowXSepratorLine = NO;
//    lineChartView.isShowYSepratorLine = NO;
//    lineChartView.isAnimatedDisplay = NO;
    
    
    [lineChartView strokeStart];
    
    
}



@end
