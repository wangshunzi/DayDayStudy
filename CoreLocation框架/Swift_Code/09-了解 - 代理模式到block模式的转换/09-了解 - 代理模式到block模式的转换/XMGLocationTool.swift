//
//  XMGLocationTool.swift
//  09-了解 - 代理模式到block模式的转换
//
//  Created by 王顺子 on 15/12/5.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import CoreLocation

class XMGLocationTool: NSObject, CLLocationManagerDelegate
{

    // 单例模式
    private static let shareObj:XMGLocationTool = XMGLocationTool()
    class func shareInstance() -> XMGLocationTool
    {
        return shareObj
    }

    // 记录代码块
    var resultBlock : ((location : CLLocation?, placemark : CLPlacemark?, error : String?) -> Void)?

    // 懒加载位置管理者
    lazy var locationManager : CLLocationManager =
    {

        let tempLocationManage : CLLocationManager = CLLocationManager()
        tempLocationManage.delegate = self

        // 请求授权
        if Float(UIDevice.currentDevice().systemVersion) >= 8.0
        {


            /// 判断请求什么样的授权

            // 1. 获取info文件的内容
            let infoDic = NSBundle.mainBundle().infoDictionary

            // 2. 获取定位的前台描述和前后台定位描述, 然后根据是否为空, 判断应该使用哪种授权方案
            let whenInUseDesc = infoDic!["NSLocationWhenInUseUsageDescription"]
            let alwaysDesc = infoDic!["NSLocationAlwaysUsageDescription"]

            // 前后台定位授权情况
            if alwaysDesc?.length > 0
            {
                tempLocationManage.requestAlwaysAuthorization()
            }
                // 前台定位授权情况
            else if whenInUseDesc?.length > 0
            {
                tempLocationManage.requestWhenInUseAuthorization()
                // 判断是否勾选了后台模式, 适配iOS9.0的前台定位授权状态下的, 后台定位
                let backModels = infoDic!["UIBackgroundModes"] as! NSArray
                if backModels.containsObject("location")
                {
                    if Float(UIDevice.currentDevice().systemVersion) >= 9.0
                    {
                        tempLocationManage.allowsBackgroundLocationUpdates = true
                    }
                }
            }
            else
            {
                print("在iOS8.0之后, 获取用户位置, 必须在info.plist文件中配置NSLocationWhenInUseUsageDescription 或者 NSLocationAlwaysUsageDescription")
            }

        }

        return tempLocationManage
    }()


    lazy var geoCoder : CLGeocoder =
    {

        let tempGeoCoder : CLGeocoder = CLGeocoder()

        return tempGeoCoder
    }()


    /// 获取当前的位置信息, 并通过闭包传递给外界
    func getCurrentLocation(result : (location : CLLocation?, placemark : CLPlacemark?, error : String?) -> Void)
    {
     

        // 记录闭包
        resultBlock = result

        // 开始获取用户位置
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.startUpdatingLocation()
        }
        else
        {
            resultBlock!(location: nil, placemark: nil, error: "不能定位!")
        }


    }




    /// MARK: CLLocationManagerDelegate

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        // 获取到位置对象之后, 进行反地理编码
        geoCoder.reverseGeocodeLocation(locations.last!) {
            (placemarks:[CLPlacemark]?, error:NSError?) -> Void in

            if error == nil
            {
                self.resultBlock!(location: locations.last, placemark: placemarks?.first, error: nil)
            }
            else
            {
                self.resultBlock!(location: locations.last, placemark: nil, error: nil)
            }
        }

        // 停止更新用户位置
        manager.stopUpdatingLocation()
        

    }








}
