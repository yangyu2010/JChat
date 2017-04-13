//
//  String-Extension.swift
//  HuaChuMall
//
//  Created by evestorm on 2017/4/7.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

extension String {
    /// 获取文字Size
    ///
    /// - Parameter text: 文字String
    /// - Returns: CGSize
    func getTextSize(font: UIFont, maxW: CGFloat) -> CGSize {
        let statusLabelText : NSString = self as NSString
        return statusLabelText.boundingRect(with: CGSize(width: maxW, height: 0.0), options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName:font], context: nil).size
    }
}
