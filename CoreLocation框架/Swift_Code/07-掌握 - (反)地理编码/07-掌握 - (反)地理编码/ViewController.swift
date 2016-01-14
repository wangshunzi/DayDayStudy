//
//  ViewController.swift
//  07-掌握 - (反)地理编码
//
//  Created by 王顺子 on 15/12/5.
//  Copyright © 2015年 小码哥. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {


    @IBOutlet weak var addressTV: UITextView!

    @IBOutlet weak var latitudeTF: UITextField!

    @IBOutlet weak var longitudeTF: UITextField!



    // MARK: 懒加载
    lazy var geoCoder : CLGeocoder =
    {
        let tempGeoCoder : CLGeocoder = CLGeocoder()

        return tempGeoCoder
    }()


    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }






    // MARK: 自定义方法

    // 地理编码: 地址 --> 经纬度
    @IBAction func geoCode()
    {

        let address = self.addressTV.text

        // 根据地址关键字进行地理编码
        geoCoder.geocodeAddressString(address) {
            (placeMarks, error) -> Void in

            /**
             *  CLPlacemark : 地标对象
                location : 地标对象对应的位置对象
                name : 地址全称
                thoroughfare : 街道名称
            */
            if error == nil
            {
                let placeMark = placeMarks?.first
                self.addressTV.text = placeMark?.name
                self.latitudeTF.text = String(placeMark!.location!.coordinate.latitude)
                self.longitudeTF.text = String(placeMark!.location!.coordinate.longitude)

            }

        }

    }


    // 地理编码: 经纬度 --> 地址
    @IBAction func reverseGeoCode()
    {

        // 容错处理, 判断是否有输入内容
        if self.latitudeTF.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0 || self.longitudeTF.text?.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 0
        {
            return
        }

        // 取出经纬度
        let latitude = Double(self.latitudeTF.text!)!
        let lognitude = Double(self.longitudeTF.text!)!

        // 根据经纬度创建位置对象
        let location:CLLocation = CLLocation(latitude: latitude, longitude: lognitude)

        // 根据位置对象, 记性反地理编码
        geoCoder .reverseGeocodeLocation(location) {
            (placeMarks, error) -> Void in

            if error == nil
            {
                let placeMark = placeMarks?.first
                self.addressTV.text = placeMark?.name
                self.latitudeTF.text = String(placeMark!.location!.coordinate.latitude)
                self.longitudeTF.text = String(placeMark!.location!.coordinate.longitude)

            }

        }

    }

}

