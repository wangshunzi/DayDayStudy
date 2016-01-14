//
//  ViewController.m
//  01-掌握-CoreLocation框架的基本使用—定位（iOS8.0-）
//
//  Created by 1 on 15/12/21.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

/** 位置管理者*/
@property(nonatomic ,strong) CLLocationManager *locationM;


@end

@implementation ViewController

#pragma mark - 懒加载
/**
 *  位置管理者懒加载方法
 */
- (CLLocationManager *)locationM
{
    if (!_locationM) {
        // 1. 创建位置管理者
        _locationM = [[CLLocationManager alloc] init];
        // 1.1 代理, block , 通知, 拉模式
        _locationM.delegate = self;
        
        // 设置过滤距离(每隔100米定位一次)
        // 111km/100m  1
        // 当前位置距离上次位置之间的物理距离大于这个值, 就会通过代理告诉外界
//        _locationM.distanceFilter = 100;
        
        
        // 定位精确度
        /**
         *   kCLLocationAccuracyBestForNavigation // 最适合导航
             kCLLocationAccuracyBest; // 最好的
             kCLLocationAccuracyNearestTenMeters; // 附近10米
             kCLLocationAccuracyHundredMeters; // 附近100米
             kCLLocationAccuracyKilometer; // 附近1000米
             kCLLocationAccuracyThreeKilometers; // 附近3000米
         */
        // 如果精确度越高, 定位越精准, 但是越耗电, 而且定位时间越长
        _locationM.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationM;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{


    
    // 2. 使用位置管理者获取用户位置信息
    // 小经验: 如果使用CLLocationManager 对象实现一些服务 , 可以使用start开始某个服务, stop, 结束这个服务
    // ing, 一旦调用了这个方法, 就会再后台不断的获取用户位置信息, 然后告诉外界
    // 默认情况下, 只能在前台获取用户位置信息, 如果想要在后台获取位置,需要勾选后台模式  locaiton updates
    
    // 标准定位服务(gps/WiFi/ 基站)
    // 程序关闭,就没法获取位置
    [self.locationM startUpdatingLocation];
    
    
    // 监听重大位置改变的服务(基站, 要求有电话模块)
    // 当app被完全关闭时,也可以接收到位置通知,并让app进入到后台处理
    // 定位精度相比于上面,精度不大,所以耗电小,而且定位更新频率依据基站密度而定
    [self.locationM startMonitoringSignificantLocationChanges];
    
}


#pragma mark - CLLocationManagerDelegate

/**
 *  当获取到用户位置信息时调用
 *
 *  @param manager   位置管理者
 *  @param locations 位置数组
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"获取到位置了");
    
    // 1. 获取一次位置信息, 然后做业务逻辑
    [manager stopUpdatingLocation];
    
    
    // 2. 多次获取位置, 导航
    
    
}


@end
