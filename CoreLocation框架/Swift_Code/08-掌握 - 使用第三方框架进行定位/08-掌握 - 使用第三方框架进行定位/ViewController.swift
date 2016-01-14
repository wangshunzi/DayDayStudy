//
//  ViewController.swift
//  08-掌握 - 使用第三方框架进行定位
//
//  Created by 王顺子 on 15/12/5.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit


class ViewController: UIViewController {



    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        
        let requestID:INTULocationRequestID =  INTULocationManager.sharedInstance().requestLocationWithDesiredAccuracy(INTULocationAccuracy.Room, timeout: 3) { (location:CLLocation!, locationAccuracy:INTULocationAccuracy, status:INTULocationStatus) -> Void in
            if status == INTULocationStatus.Success
            {
                print("---\(location)")
            }
        }


        // 取消位置请求 (不会调用block)
//        INTULocationManager.sharedInstance().cancelLocationRequest(requestID)

        // 强制完成位置请求(会调用block)
        INTULocationManager.sharedInstance().forceCompleteLocationRequest(requestID)
    }


}

