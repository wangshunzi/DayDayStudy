//
//  XMGLocationTool.m
//  09-代理模式到block模式的转换
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "XMGLocationTool.h"
#import <UIKit/UIKit.h>

#define isIOS(version) ([[UIDevice currentDevice].systemVersion floatValue] >= version)

@interface XMGLocationTool()<CLLocationManagerDelegate>

@property (nonatomic, copy) ResultBlock resultBlock;

/** 位置管理者*/
@property(nonatomic ,strong) CLLocationManager *locationM;

/** 地理编码器*/
@property(nonatomic ,strong) CLGeocoder *geoC;


@end


@implementation XMGLocationTool
single_implementation(XMGLocationTool)

/**
 *  地理编码器懒加载方法
 */
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}


/**
 *  位置管理者懒加载方法
 */
- (CLLocationManager *)locationM
{
    if (!_locationM) {
        _locationM = [[CLLocationManager alloc] init];
        _locationM.delegate = self;
        
        if (isIOS(8.0))
        {
            // 在这里请求授权
            // 因为我们开发的工具类, 是给别的开发人员使用, 所以并不知道别的开发人员意图, 但是我们可以通过info.plist文件来判断其他开发者的意图
            
//            [_locationM requestAlwaysAuthorization];
            
            // 1. 获取info.plist字典,
            NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
            
            // 2. 获取前台定位描述和前后台定位描述, 然后, 判断
            // 2.1. 如果两个都为空, 提醒其他开发者, 需要手动配置两个key
            // 2.2 如果其他开发者, 配置的是前台定位描述, 请求前台定位授权
            // 2.3 如果其他开发者, 配置的是前后台定位描述, 请求前后台定位授权
            
            
            
            NSString *whenInUse = infoDic[@"NSLocationWhenInUseUsageDescription"];
            NSString *always = infoDic[@"NSLocationAlwaysUsageDescription"];
            if ([always length] > 0) {
                [_locationM requestAlwaysAuthorization];
            }
            else if ([whenInUse length] > 0)
            {
                [_locationM requestWhenInUseAuthorization];
                
                // 判断用户有没有勾选后台模式
                NSArray *backModes = infoDic[@"UIBackgroundModes"];
                if ([backModes containsObject:@"location"]) {
                    // ios9.0
                    if (isIOS(9.0)) {
                        _locationM.allowsBackgroundLocationUpdates = YES;
                    }
                    
                }else
                {
                    NSLog(@"温馨提示, 当前请求的授权是前台定位授权, 如果想要在后台获取用户位置, 需要勾选后台模式location updates");
                }
  
            }else
            {
                NSLog(@"温馨提示: 如果要在iOS8.0之后获取用户位置, 必须,在info.plist文件里面配置NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription");
            }
           
            
        }
        
    }
    return _locationM;
}


-(void)getCurrentLocation:(ResultBlock)resultBlock
{
    // 1. 记录block, 在合适的地方执行
    self.resultBlock = resultBlock;
    
    // 2. 开始定位
    if ([CLLocationManager locationServicesEnabled]) {
         [self.locationM startUpdatingLocation];
    }else
    {
        self.resultBlock(nil, nil,@"定位服务关闭");
    }
   
}


#pragma mark - CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *loc = [locations lastObject];
    
    // 反地理编码
    [self.geoC reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
       
        if (error) {
            self.resultBlock(loc, nil, error.localizedDescription);
        }else
        {
            CLPlacemark *pl = [placemarks firstObject];
            self.resultBlock(loc, pl, nil);
        }
        
        
    }];
    

    // 停止
    [self.locationM stopUpdatingLocation];
}


-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        // 系统预留字段, 暂时没有用
        case kCLAuthorizationStatusRestricted:
        {
            self.resultBlock(nil, nil, @"受限制");
            break;
        }
        case kCLAuthorizationStatusDenied:
        {
            
            // 判断是否支持定位, 或者定位服务是否开启
            if ([CLLocationManager locationServicesEnabled])
            {
                self.resultBlock(nil, nil, @"真正被拒绝");
            }
            break;
        }
    
            
        default:
            break;
    }

}





@end
