//
//  UIButton-Extension.swift
//  HuaChuMall
//
//  Created by Young on 2017/4/11.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

extension UIButton {

    convenience init(title : String) {
        
        self.init(type: .custom)
        
        setTitle(title, for: .normal)
        backgroundColor = .white
        setTitleColor(UIColor(hexColorString: "333333"), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        contentHorizontalAlignment = .left
        
        titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        setImage(UIImage(named: "Shopping_right"), for: .normal)
        
        imageEdgeInsets = UIEdgeInsets(top: 0, left: kScreen_Width - 15, bottom: 0, right: 0)
    }
    
}
