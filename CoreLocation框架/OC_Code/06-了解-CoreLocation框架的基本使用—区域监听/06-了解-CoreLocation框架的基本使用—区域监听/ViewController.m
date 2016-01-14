//
//  ViewController.m
//  06-了解-CoreLocation框架的基本使用—区域监听
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

/** 位置管理者*/
@property(nonatomic ,strong) CLLocationManager *locationM;

@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;

@end

@implementation ViewController

/**
 *  位置管理者懒加载方法
 */
- (CLLocationManager *)locationM
{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
        
        // 主动请求前后台定位授权
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            [_locationM requestAlwaysAuthorization];
        }
    }
    return _locationM;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![CLLocationManager isMonitoringAvailableForClass:[CLCircularRegion class]]) {
        NSLog(@"该区域不能监听");
        return;
    }
    
    
    // -1. 创建一个区域中心, 半径
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(21.123, 121.234);
    CLLocationDistance distance = 1000;
    // -1.1 判定监听的区域半径是否在最大范围之内
    if (distance > self.locationM.maximumRegionMonitoringDistance) {
        distance = self.locationM.maximumRegionMonitoringDistance;
    }
    
    
    // 0. 创建一个区域
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center radius:distance identifier:@"小码哥八神"];
    
    // 1. 监听区域(只能监听进入或者离开区域的动作)
    [self.locationM startMonitoringForRegion:region];
    
    
    // 1.2 直接获取某个区域的当前状态
    [self.locationM requestStateForRegion:region];
    
    
}


#pragma mark - CLLocationManagerDelegate
/**
 *  进入指定区域时调用
 *
 *  @param manager 位置管理者
 *  @param region  区域
 */
-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    NSLog(@"进入区域---%@",region.identifier);
    self.noticeLabel.text = @"小码哥欢迎你, 给你技术";
}
/**
 *  离开指定区域时调用
 *
 *  @param manager 位置管理者
 *  @param region  区域
 */
-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    NSLog(@"离开区域---%@",region.identifier);
    self.noticeLabel.text = @"欢迎下次再来复读, 打死你";
}


/**
 *  当请求某个区域状态时调用
 *
 *  @param manager 位置管理者
 *  @param state   状态
 *  @param region  区域
 */
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    /**
     *  CLRegionStateUnknown,
     CLRegionStateInside,
     CLRegionStateOutside
     */
    if (state == CLRegionStateInside) {
         self.noticeLabel.text = @"小码哥欢迎你, 给你技术";
    }else if (state == CLRegionStateOutside)
    {
        self.noticeLabel.text = @"欢迎下次再来复读, 打死你";
    }
}



@end
