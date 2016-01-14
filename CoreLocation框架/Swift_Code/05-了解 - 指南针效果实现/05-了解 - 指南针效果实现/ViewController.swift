//
//  ViewController.swift
//  05-了解 - 指南针效果实现
//
//  Created by 王顺子 on 15/12/5.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var compassView: UIImageView!


    // MARK: 懒加载
    lazy var locationM : CLLocationManager = {

        // 创建位置管理者对象
        let tempLocation : CLLocationManager = CLLocationManager()
        // 设置代理
        tempLocation.delegate = self
        return tempLocation

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 判断是否可以获取当前设备朝向
        if CLLocationManager.headingAvailable()
        {
            // 开始获取用户设备的朝向
            locationM.startUpdatingHeading()
        }

    }


    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {

        // 获取当前的手机朝向之前, 先判断数据是否有效
        if  newHeading.headingAccuracy < 0
        {
            return
        }

        // 1. 获取设备朝向(距离磁北的角度, 或者距离真北的角度)
        let angle = newHeading.magneticHeading

        // 1.1 转换成为弧度
        let radian = CGFloat(angle / 180.0 * M_PI)

        // 2. 反向旋转图片
        UIView.animateWithDuration(0.5) { () -> Void in
            self.compassView.transform = CGAffineTransformMakeRotation(-radian)
        };



    }



}

