//
//  XMGLocationTool.h
//  09-代理模式到block模式的转换
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Singleton.h"

typedef void(^ResultBlock)(CLLocation *location, CLPlacemark *pl, NSString *erroMsg);


@interface XMGLocationTool : NSObject
single_interface(XMGLocationTool)

- (void)getCurrentLocation:(ResultBlock)resultBlock;



@end
