//
//  UIImageExtension.swift
//  PocketPay
//
//  Created by Harin Sanghirun on 19/6/58.


import UIKit

extension UIImage {

    class func imageForCurrentDevice(named: String) -> UIImage {
        var imageName: String
        switch UIScreen.main.bounds.width {
        case 375.0: // iphone 6
            imageName = "\(named)-375"
        case 320.0: // iphone 5s and lower
            imageName = "\(named)-320"
        default: // iPhone 6+ and others
            imageName = named
        }
        return UIImage(named: imageName)!
    }

}
