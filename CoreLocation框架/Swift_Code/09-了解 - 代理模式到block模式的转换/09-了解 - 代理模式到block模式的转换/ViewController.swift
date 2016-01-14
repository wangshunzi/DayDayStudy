//
//  ViewController.swift
//  09-了解 - 代理模式到block模式的转换
//
//  Created by 王顺子 on 15/12/5.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {

        XMGLocationTool.shareInstance().getCurrentLocation {
            (location, placemark, error) -> Void in

            print(location)

        }

    }



}

