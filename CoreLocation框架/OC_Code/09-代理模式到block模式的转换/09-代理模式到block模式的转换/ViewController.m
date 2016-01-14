//
//  ViewController.m
//  09-代理模式到block模式的转换
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import "XMGLocationTool.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [[XMGLocationTool sharedXMGLocationTool] getCurrentLocation:^(CLLocation *location, CLPlacemark *pl, NSString *erroMsg) {
        if ([erroMsg length] == 0) {
            NSLog(@"%@----%@", location, pl.name);
        }else
        {
            NSLog(@"%@", erroMsg);
        }
    }];
    
}

@end
