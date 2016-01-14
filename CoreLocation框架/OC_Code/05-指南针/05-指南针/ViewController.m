//
//  ViewController.m
//  05-指南针
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController ()<CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *compassView;

/** 位置管理者*/
@property(nonatomic ,strong) CLLocationManager *locationM;


@end

@implementation ViewController


/**
 *  位置管理懒加载方法
 */
- (CLLocationManager *)locationM
{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
    }
    return _locationM;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // 0. 判断当前磁力计传感器是否可用
    if (![CLLocationManager headingAvailable]) {
        return;
    }
    // 1. 获取当前设备朝向
    [self.locationM startUpdatingHeading];
    
    
    
}




#pragma mark - CLLocationManagerDelegate
/**
 *  当获取到设备朝向时
 *
 *  @param manager    位置管理者
 *  @param newHeading 头部信息
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    if (newHeading.headingAccuracy < 0)
    {
        return;
    }
    
    // 1. 获取设备距离磁北方向的角度(0.0---359.9)
    CLLocationDirection angle = newHeading.magneticHeading;
    
    // 1.1 角度---> 弧度
    CGFloat hudu = angle / 180.0 * M_PI;
    
    // 2. 旋转图片(弧度)
    [UIView animateWithDuration:0.5 animations:^{
        self.compassView.transform = CGAffineTransformMakeRotation(-hudu);
    }];
    
    
}






@end
