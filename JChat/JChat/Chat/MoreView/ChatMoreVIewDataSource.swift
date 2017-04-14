//
//  ChatMoreVIewDataSource.swift
//  JChat
//
//  Created by Young on 2017/4/14.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

struct ChatMoreModel {
    var title : String?
    var img : String?
}

class ChatMoreVIewDataSource {

    class func getMoreViewData() -> [ChatMoreModel] {
        
        let titles = ["相册", "拍照"]
        let imgs = ["message_photos", "message_camera"]
        
        var models = [ChatMoreModel]()
        for i in 0..<titles.count {
            var model = ChatMoreModel()
            model.title = titles[i]
            model.img = imgs[i]
            models.append(model)
        }
        
        return models
    }
}
