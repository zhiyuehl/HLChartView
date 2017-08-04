//
//  HistogramViewController.m
//  AnimationDemo
//
//  Created by tederen on 2017/7/28.
//  Copyright © 2017年 tederen. All rights reserved.
//

#import "HistogramViewController.h"
#import "HLHistogramView.h"

@interface HistogramViewController ()

@end

@implementation HistogramViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    HLHistogramData *data1 = [HLHistogramData histogramDataWithValue:@"100" histogramColor:[UIColor redColor]];
    HLHistogramData *data2 = [HLHistogramData histogramDataWithValue:@"30" histogramColor:[UIColor blueColor]];
    HLHistogramData *data3 = [HLHistogramData histogramDataWithValue:@"50" histogramColor:[UIColor greenColor]];
    HLHistogramData *data4 = [HLHistogramData histogramDataWithValue:@"120" histogramColor:[UIColor purpleColor]];
    
    HLHistogramData *data11 = [HLHistogramData histogramDataWithValue:@"80" histogramColor:[UIColor redColor]];
    HLHistogramData *data22 = [HLHistogramData histogramDataWithValue:@"20" histogramColor:[UIColor blueColor]];
    HLHistogramData *data33 = [HLHistogramData histogramDataWithValue:@"165" histogramColor:[UIColor greenColor]];
    HLHistogramData *data44 = [HLHistogramData histogramDataWithValue:@"60" histogramColor:[UIColor purpleColor]];
    
    
    HLHistogramView *histogramView = [[HLHistogramView alloc]initWithFrame:CGRectMake(0, 100, kScreen_Width, 300)];
    
    histogramView.yValueLabels = @[@[data1,data2,data3],@[data1,data2,data3,data4],@[data11,data22],@[data33,data44],@[data11,data22,data33,data44],@[data1,data2,data33,data44]];
    histogramView.xLabels = @[@"1月底层、架构、音视频、逆向",@"2月底视频逆向",@"3月底层、音视频、逆向",@"4月底层、音视频、逆向",@"5月底层、架构、音视频、逆向",@"6月底层"];
    
    
    histogramView.xHistogramMinGap = 0;
//    histogramView.xHistogramMaxGap = 40;
//    histogramView.histogramWidth = 30;
//    histogramView.ySepLabelCount = 6;
    
//    histogramView.yLabelWidth = 50;
    
    
    [histogramView strokeStart];
    
    [self.view addSubview:histogramView];
}



@end
