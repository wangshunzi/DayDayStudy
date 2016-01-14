//
//  ViewController.m
//  02-掌握-CoreLocation框架的基本使用—定位（iOS8.0+适配）
//
//  Created by 1 on 15/12/21.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)


@interface ViewController ()<CLLocationManagerDelegate>
{
    CLLocation *_lastLocation;
}
/** 位置管理者*/
@property(nonatomic ,strong) CLLocationManager *locationM;


@end

@implementation ViewController

#pragma mark - 懒加载

/**
 *  位置管理者 懒加载方法
 */
- (CLLocationManager *)locationM
{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
        
        /** ios8.0+定位适配 */
        if (isIOS(8.0)) {
            // 请求前台定位授权
            // 如果当前的授权状态是用户为选择状态, 那么这个方法才会有效
            // 默认情况只能在前台获取用户位置信息
            // 如果想要在后台获取用户位置, 需要勾选后台模式, 但是, 当APP推到后台时, 会出现一个蓝条, 不断提醒用户
//            [_locationM requestWhenInUseAuthorization];
            
            // 如果实在iOS9.0之后, 此时如果在前台定位授权情况下去, 想要在后台获取用户位置, 不止要勾选后台模式, 还要设置以下属性为yes
            // 想要执行这个方法, 一定要注意, 需要勾选后台模式location updates, 如果没有勾选 ,后果自负
//            if (isIOS(9.0))
//            {
//                _locationM.allowsBackgroundLocationUpdates = YES;
//            }
            
            
            // 请求前后台定位授权
            // 如果当前的授权状态是用户为选择状态, 那么这个方法才会有效
            // 无论在前台, 还是后台, 都可以获取用户的位置信息, 而且不会出现蓝条, 根是否勾选了后台模式location udpates没有关系
            [_locationM requestAlwaysAuthorization];
        }
        
        // 2中适配方案
//        if ([_locationM respondsToSelector:@selector(requestAlwaysAuthorization)]) {
//            [_locationM requestAlwaysAuthorization];
//        }
        
    }
    return _locationM;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.locationM startUpdatingLocation];
    
    
    // 单次定位请求
    /**
     * 
      kCLLocationAccuracyBestForNavigation
      kCLLocationAccuracyBest;
      kCLLocationAccuracyNearestTenMeters;
      kCLLocationAccuracyHundredMeters;
      kCLLocationAccuracyKilometer;
      kCLLocationAccuracyThreeKilometers;
     */
    // 如果在有效时间内, 定位到精确度最高的位置数据,就直接通过代理告诉我们, 如果已经超时, 那就把当前已经定位到的位置信息通过代理告诉我们
    // 注意事项: 1. 不能与startUpdatelocation  2. 代理必须实现定位失败的方法
//    [self.locationM requestLocation];
}



#pragma mark - CLLocationManagerDelegate
/**
 *  定位到之后调用
 *
 *  @param manager   位置管理者
 *  @param locations 位置数组
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    // locations: 按时间先后顺序排序
    /**
     *  coordinate : 经纬度
     *  altitude : 海拔
     *  horizontalAccuracy : 水平精确度, 如果是负数, 就代表这个location位置无效
     *  verticalAccuracy : 垂直精确度, 如果是负数, 就代表海拔没有用
     *  course : 航向
     *   0.0 - 359.9 degrees, 0 being true North
     *  speed : 速度
     *  distanceFromLocation : 计算两个坐标之间的物理直线距离
     */

    CLLocation *loc = [locations lastObject];
    if (loc.horizontalAccuracy < 0) {
        return;
    }
    
    // 场景演示
    //   >场景演示:打印当前用户的行走方向,偏离角度以及对应的行走距离,
    //   例如:”北偏东 30度 方向,移动了 8 米”
    
    // 1. 行走方向(北偏东, 东偏南)
    NSArray *angleStrArr = @[@"北偏东", @"东偏南", @"南偏西", @"西偏北"];
    NSInteger index = (NSInteger)loc.course / 90;
    NSString *angStr = angleStrArr[index];
    
    // 2. 偏离角度(30)
    NSInteger angle = (NSInteger)loc.course % 90;
    
    if (angle == 0)
    {
        // "东"
        angStr = [@"正" stringByAppendingString:[angStr substringToIndex:1]];
    }
    
    
    // 3. 行走距离

    CLLocationDistance distance = 0;
    if (_lastLocation) {
        distance = [loc distanceFromLocation:_lastLocation];
    }
    _lastLocation = loc;
 
    // 4. 拼串打印
    //   例如:”北偏东 30度 方向,移动了 8 米”
    NSString *notice;
    if (angle == 0) {
         notice = [NSString stringWithFormat:@"%@方向, 行走了%f米", angStr, distance];
    }else
    {
         notice = [NSString stringWithFormat:@"%@%zd度方向, 行走了%f米", angStr,angle, distance];
    }
   
    NSLog(@"%@", notice);
    
    
    
//    NSLog(@"定位到了---%@", loc);
}


/**
 *  当前的授权状态发生改变时调用
 *
 *  @param manager 位置管理者
 *  @param status  授权状态
 */
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            NSLog(@"用户没有决定");
             break;
        }
        // 系统预留字段, 暂时没有用
        case kCLAuthorizationStatusRestricted:
        {
            NSLog(@"受限制");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
           
            // 判断是否支持定位, 或者定位服务是否开启
            if ([CLLocationManager locationServicesEnabled])
            {
                 NSLog(@"真正被拒绝");
                // iOS8.0- , 截图提醒用户整个操作流程
                // iO8.0+, 直接跳转到设置界面, 核心代码
                // 弹框, 让用户选择之后再跳转
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else
            {
                NSLog(@"定位服务关闭");
                
            }
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways:
        {
            NSLog(@"前后台定位授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        {
            NSLog(@"前台定位授权");
            break;
        }
           
            
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"定位失败");
}

@end
