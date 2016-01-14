//
//  ViewController.m
//  07-掌握-CoreLocation框架的基本使用—(反)地理编07-掌握-CoreLocation框架的基本使用—(反)地理编码
//
//  Created by 1 on 15/12/21.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *addressTV;
@property (weak, nonatomic) IBOutlet UITextField *latitudeTF;
@property (weak, nonatomic) IBOutlet UITextField *longitudeTF;


/** 地理编码器*/
@property(nonatomic ,strong) CLGeocoder *geoC;

@end

@implementation ViewController


/**
 *  geoC懒加载方法
 */
- (CLGeocoder *)geoC
{
    if (!_geoC) {
        _geoC = [[CLGeocoder alloc] init];
    }
    return _geoC;
}


/**
 *  地理编码 
 *  地址---> 经纬度
 */
- (IBAction)geoCode
{
    
    
    NSString *addressStr = self.addressTV.text;
    if ([addressStr length] == 0) {
        return;
    }
    
    [self.geoC geocodeAddressString:addressStr completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if(error == nil)
        {
            // shengda  盛大 胜达 盛达
            // CLPlacemark 地标对象 // 按照相关性排序
            // location : 位置对象
            //  name : 详细地址全程
            CLPlacemark *pl = [placemarks firstObject];
            
            self.addressTV.text = pl.name;
            self.latitudeTF.text = @(pl.location.coordinate.latitude).stringValue;
            self.longitudeTF.text = @(pl.location.coordinate.longitude).stringValue;
            
        }
        
    }];
}

/**
 *  反地理编码
 *  经纬度---> 地址
 */
- (IBAction)reverseGeoCode
{
    
    // 获取经纬度
    double latitude = [self.latitudeTF.text doubleValue];
    double longitude = [self.longitudeTF.text doubleValue];
    
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    
    
    // 反地理编码
    [self.geoC reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error)
     {
         if(error == nil)
         {
             // shengda  盛大 胜达 盛达
             // CLPlacemark 地标对象 // 按照相关性排序
             // location : 位置对象
             //  name : 详细地址全程
             CLPlacemark *pl = [placemarks firstObject];
             
             self.addressTV.text = pl.name;
             self.latitudeTF.text = @(pl.location.coordinate.latitude).stringValue;
             self.longitudeTF.text = @(pl.location.coordinate.longitude).stringValue;
             
         }

    }];
    
    
    
}





@end
