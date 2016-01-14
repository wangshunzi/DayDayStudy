//
//  ViewController.swift
//  01-掌握 - iOS8.0之前的定位
//
//  Created by 王顺子 on 15/12/5.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import CoreLocation

// 在swift 里面遵守协议, 是使用 逗号 ","
class ViewController: UIViewController, CLLocationManagerDelegate {

    // MARK: 懒加载位置管理者
    lazy var locationM : CLLocationManager = {

        /// 1. 创建位置管理者
        let tempLocationM = CLLocationManager()
        /// 2. 设置代理
        tempLocationM.delegate = self


        /// 3. 额外设置
        // 3.1 如果针对于导航应用, 需要每隔多远更新一次用户位置, 可以通过设置特定属性来实现
        // 代表每隔100米获取一次用户的位置信息, 并通过代理告诉外界
        tempLocationM.distanceFilter = 100


        // 3.2 设置定位的精确度
        // 精确度越高, 获取到得位置精准度越高, 但是越耗电, 定位时间越长
//         kCLLocationAccuracyBestForNavigation  最适合导航
//         kCLLocationAccuracyBest;  最好的
//         kCLLocationAccuracyNearestTenMeters; 附近10米
//         kCLLocationAccuracyHundredMeters; 附近100米
//         kCLLocationAccuracyKilometer;  附近1000 米
//         kCLLocationAccuracyThreeKilometers; 附近3000米
        tempLocationM.desiredAccuracy = kCLLocationAccuracyBest


        // 4. 后台定位
        // 在iOS8.0之前, 只需要勾选后台模式就可以
        // target -> Capabilities -> 开启Background Modes -> 勾选 location updates

        return tempLocationM
    }()


    /// 重写系统touchesBegan方法
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {


        /// 3. 调用方法, 开始更新用户位置信息
        locationM.startUpdatingLocation()


    }


    // MARK: CLLocationManagerDelegate 代理方法

    /// 1. 获取到用户位置之后调用
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.last)

        // 场景1: 如果只需要获取一次用户位置, 那么在此处获取到位置之后, 可以停止更新用户位置
//        manager.stopUpdatingLocation()


        // 场景2: 如果针对于导航应用, 需要每隔多远更新一次用户位置, 可以通过设置特定属性来实现(见懒加载方法内部)


    }



}

