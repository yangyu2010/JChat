//
//  ChatRightTableViewCell.swift
//  JChat
//
//  Created by Young on 2017/4/13.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

class ChatRightTableViewCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var messageLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    var message : JMSGMessage? {
        didSet {
            guard let message = message else { return }
            
            message.fromUser.thumbAvatarData { (data, objectID, error) in
                if let data = data {
                    self.icon.image = UIImage(data: data)
                }
            }
            
            if message.contentType == .text {
                guard let content = message.content as? JMSGTextContent else { return  }
                messageLab.text = content.text
            }
            
            //            backgroundColor = UIColor.randomColor()
        }
    }
    
}
