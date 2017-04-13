//
//  Common.swift
//  HuaChuMall
//
//  Created by Young on 2017/3/29.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

/// 默认颜色
let kDefault_Color = UIColor(hexColorString: "e00031")
let kDefault_BackgroundColor = UIColor(hexColorString: "f2f2f2")

/// 尺寸常量
let kKeyWindow = UIApplication.shared.keyWindow!
let kScreen_Bounds = UIScreen.main.bounds
let kScreen_Width = UIScreen.main.bounds.size.width
let kScreen_Height = UIScreen.main.bounds.size.height
let kNavigation_Height : CGFloat = 64
let kTabBar_Height : CGFloat = 49
let kNormal_Height : CGFloat = 38
let kSingle_Line_Width : CGFloat = 1 / UIScreen.main.scale
let kScreen_Scale : CGFloat = kScreen_Width / 750.0

/// 正方形占位图
let kPlaceholder_Image_Sq = UIImage(named: "placeholder_sq")
/// 长  16:9
let kPlaceholder_Image_Re = UIImage(named: "placeholder_re")
