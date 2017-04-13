//
//  UITextField-Extension.swift
//  HuaChuMall
//
//  Created by Young on 2017/3/31.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

class SearchBar: UITextField {

    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
       
        return CGRect(x: 10, y: 6, width: 16, height: 20)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width - 30, height: bounds.height)

    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width - 30, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        return CGRect(x: bounds.origin.x + 30, y: bounds.origin.y, width: bounds.width - 30, height: bounds.height)
    }
}


extension SearchBar {

    convenience init(placeholder: String?) {
        
        self.init(frame: CGRect(x: 0, y: 0, width: kScreen_Width - 60, height: 30))
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        self.placeholder = placeholder
        backgroundColor = kDefault_BackgroundColor
        textColor = UIColor(hexColorString: "bbbbbb")
        font = UIFont.systemFont(ofSize: 13.0)
        tintColor = UIColor(hexColorString: "bbbbbb")
        returnKeyType = .search
        keyboardType = .default
        
        let searchIcon = UIImageView(image: UIImage(named: "search"))
        searchIcon.sizeToFit()
        
        leftView = searchIcon
        leftViewMode = .always
        clearButtonMode = .whileEditing
        
    }
    
    
    
}
