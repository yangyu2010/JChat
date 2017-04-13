//
//  NetworkTool.swift
//  HuaChuMall
//
//  Created by Young on 2017/3/29.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

enum MethodType {
    case get
    case post
}

class NetworkTool: NSObject {

//    class func requestData(type : MethodType, urlString : String, parameters : [String : Any]?, completionCallBack : @escaping (_ result : Any) -> ()) {
//    
//        let method = type == .get ? HTTPMethod.get : HTTPMethod.post
//        
//        Alamofire.request(urlString, method: method, parameters : parameters).responseJSON { (response) in
//            
//            guard let result = response.result.value else {
//                print(response.error!)
//                return
//            }
//            completionCallBack(result)
//        }
//    }
}
