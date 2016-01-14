//
//  ViewController.m
//  08-掌握-CoreLocation框架的基本使用—定位的第三方框架
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "INTULocationManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // 1. 创建一个位置管理者
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
//     2. 开始请求位置信息
//     delayUntilAuthorized 确定超时时间, 从什么时间开始计算
    // YES, 从用户选择授权之后开始计算
    // No , 从执行这行代码开始计算
   INTULocationRequestID requestID = [locMgr requestLocationWithDesiredAccuracy:INTULocationAccuracyRoom
                                       timeout:3.0
                          delayUntilAuthorized:NO
                                         block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                             if (status == INTULocationStatusSuccess) {
                                                 NSLog(@"定位成功--%@", currentLocation);
                                             }
                                             else
                                             {
                                                 NSLog(@"定位失败--%zd", status);
                                             }
                                             
                                         }];
//    [[INTULocationManager sharedInstance] forceCompleteLocationRequest:requestID];
//    [[INTULocationManager sharedInstance] cancelLocationRequest:requestID];
    
//    [self continues];
}


- (void)continues
{
    INTULocationManager *locMgr = [INTULocationManager sharedInstance];
    INTULocationRequestID requestID = [locMgr subscribeToLocationUpdatesWithDesiredAccuracy:INTULocationAccuracyHouse
                                                    block:^(CLLocation *currentLocation, INTULocationAccuracy achievedAccuracy, INTULocationStatus status) {
                                                        if (status == INTULocationStatusSuccess) {
                                                           
                                                            NSLog(@"--定位成功--%@", currentLocation);
                                                        }
                                                        else {
                                                            NSLog(@"dingweishibai");
                                                        }
                                                    }];
    
    // 强制完成位置请求, 适用于单词请求, 持续性请求不行
    
    
}


@end
