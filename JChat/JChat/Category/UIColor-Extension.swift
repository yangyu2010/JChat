//
//  UIColor-Extension.swift
//  HuaChuMall
//
//  Created by Young on 2017/3/28.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init?(hexColorString colorString : String, alpha : CGFloat = 1.0) {
        
        guard colorString.characters.count >= 6 else {
            return nil
        }
        
        var tempHex = colorString.uppercased()
        
        if tempHex.hasPrefix("0x") || tempHex.hasPrefix("##") {
            tempHex = (tempHex as NSString).substring(from: 2)
        }
        if tempHex.hasPrefix("#") {
            tempHex = (tempHex as NSString).substring(from: 1)
        }
        
        var range = NSRange(location: 0, length:2)
        let rHex = (tempHex as NSString).substring(with: range)
        range.location = 2
        let gHex = (tempHex as NSString).substring(with: range)
        range.location = 4
        let bHex = (tempHex as NSString).substring(with: range)
        
        var r : CUnsignedInt = 0, g : CUnsignedInt = 0, b : CUnsignedInt = 0
        Scanner(string: rHex).scanHexInt32(&r)
        Scanner(string: gHex).scanHexInt32(&g)
        Scanner(string: bHex).scanHexInt32(&b)
        
        self.init(r: CGFloat(r), g: CGFloat(g), b: CGFloat(b), alpha: alpha)

    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha : CGFloat = 1.0) {
        
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: alpha)
        
    }
    
    class func randomColor() -> UIColor {
        
        return UIColor(r: CGFloat(arc4random_uniform(226)), g: CGFloat(arc4random_uniform(226)), b: CGFloat(arc4random_uniform(226)))
    }

}
