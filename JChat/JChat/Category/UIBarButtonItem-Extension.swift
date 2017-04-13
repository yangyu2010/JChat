//
//  UIBarButtonItem-Extension.swift
//  HuaChuMall
//
//  Created by Young on 2017/3/29.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

extension UIBarButtonItem {

    convenience init(target : Any?, action : Selector, imageName : String, highImageName : String) {
        
        let btn = UIButton(type: .custom)
        btn.sizeToFit()
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn .setImage(UIImage(named: imageName), for: .normal)
        btn.setImage(UIImage(named: highImageName), for: .highlighted)
        
        self.init(customView: btn)
    }
    
    convenience init(target : Any?, action : Selector, imageName : String, highImageName : String = "", size : CGSize = CGSize.zero)  {
        // 1.创建UIButton
        let btn = UIButton()
        btn.addTarget(target, action: action, for: .touchUpInside)

        // 2.设置btn的图片
        btn.setImage(UIImage(named: imageName), for: UIControlState())
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: .highlighted)
        }
        
        // 3.设置btn的尺寸
        if size == CGSize.zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        // 4.创建UIBarButtonItem
        self.init(customView : btn)
    }
    
    convenience init(target : Any?, action : Selector, title : String, fontSize : CGFloat, titleColor : UIColor = .white, size : CGSize = CGSize.zero) {
        
        let btn = UIButton()
        btn.addTarget(target, action: action, for: .touchUpInside)

        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: fontSize)
        btn.setTitleColor(titleColor, for: .normal)
        
        if size == CGSize.zero {
            btn.sizeToFit()
        } else {
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        self.init(customView: btn)
    }
}
