//
//  PieChartViewController.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/21.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "PieChartViewController.h"
#import "HLPieChartView.h"

@interface PieChartViewController ()

@end

@implementation PieChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    HLPieChartData *data1 = [HLPieChartData pieDataWithValue:@"20" pieChartColor:[UIColor redColor] detailText:@"中通快递"];
    HLPieChartData *data2 = [HLPieChartData pieDataWithValue:@"10.2" pieChartColor:[UIColor blueColor] detailText:@"韵达快递"];
    HLPieChartData *data3 = [HLPieChartData pieDataWithValue:@"30.33" pieChartColor:[UIColor purpleColor] detailText:@"圆通快递"];
    HLPieChartData *data4 = [HLPieChartData pieDataWithValue:@"5" pieChartColor:[UIColor greenColor] detailText:@"顺丰快递"];
    HLPieChartData *data5 = [HLPieChartData pieDataWithValue:@"8" pieChartColor:[UIColor cyanColor] detailText:@"邮政快递"];

    HLPieChartView *pieChart = [[HLPieChartView alloc]initWithFrame:CGRectMake(0, 64, kScreen_Width, kScreen_Width)];
    pieChart.pieDatas = @[data1,data2,data3,data4,data5];
    pieChart.outerCircleRadius = 120;
    pieChart.interCircleRadius = 40;
//    pieChart.isAnimatedDisplay = NO;
    pieChart.lengendPosition = HLPieLengendPositionBottom;
//    pieChart.pieDetailTextType = HLPieDetailTextTypeValue;
//    pieChart.showLengendView = NO;
    pieChart.titleText = @"这是今天收到的快递";
    
    [pieChart strokeStart];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        pieChart.pieDatas = @[data1,data2,data3,data4,data5,data4,data5];
        [pieChart strokeStart];
    });
   

    pieChart.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:pieChart];
}



@end
