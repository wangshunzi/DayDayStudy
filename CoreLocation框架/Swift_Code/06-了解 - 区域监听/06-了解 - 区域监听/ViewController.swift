//
//  ViewController.swift
//  06-了解 - 区域监听
//
//  Created by 王顺子 on 15/12/5.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var noticeLabel: UILabel!

    // MARK: 懒加载
    lazy var locationM : CLLocationManager = {

        let tempLocationM : CLLocationManager = CLLocationManager()
        tempLocationM.delegate = self


        // 注意: 区域监听, 需要请求用户的定位授权. 因为系统必须知道你在哪, 才能判定, 你是否在区域内部
        if Float(UIDevice.currentDevice().systemVersion) >= 8.0
        {
            tempLocationM.requestAlwaysAuthorization()
        }

        return tempLocationM
    }()



    override func viewDidLoad() {
        super.viewDidLoad()


        // 判定是否可以监听区域
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion)
        {
            return;
        }


        // 指定区域中心
        let center : CLLocationCoordinate2D = CLLocationCoordinate2DMake(21.123, 121.234)

        // 指定区域半径
        var distance : CLLocationDistance = 1000.0
        // 注意: 区域半径不能大于最大监听半径
        if distance > locationM.maximumRegionMonitoringDistance
        {
            distance = locationM.maximumRegionMonitoringDistance
        }


        // 创建一个区域
        let region : CLCircularRegion = CLCircularRegion(center: center, radius: distance, identifier: "小码哥")

        // 开始监听区域
        locationM.startMonitoringForRegion(region)

        // 请求区域状态
        locationM.requestStateForRegion(region)
    }



    // MARK: CLLocationManagerDelegate 代理方法

    // 进入某个区域时调用
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        self.noticeLabel.text = "进入区域" + region.identifier
    }

    // 离开某个区域时调用
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        self.noticeLabel.text = "离开区域" + region.identifier
    }


    // 当请求区域状态的时候调用
    func locationManager(manager: CLLocationManager, didDetermineState state: CLRegionState, forRegion region: CLRegion) {
        if state == CLRegionState.Inside
        {
            self.noticeLabel.text = "进入区域" + region.identifier
        }
        else
        {
            self.noticeLabel.text = "离开区域" + region.identifier
        }
    }






}

