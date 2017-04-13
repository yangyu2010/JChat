//
//  MessageListCell.swift
//  JChat
//
//  Created by Young on 2017/4/11.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

class MessageListCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nickNameLab: UILabel!
    @IBOutlet weak var lastContentLab: UILabel!
    @IBOutlet weak var timeLab: UILabel!
    @IBOutlet weak var unReadCountLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    var conversation : JMSGConversation? {
        didSet {
            guard let conversation = conversation else { return }
            
            // 昵称
            nickNameLab.text = conversation.title
            
            // 最后一条消息
            lastContentLab.text = conversation.latestMessageContentText()
                       
            // 头像
            conversation.avatarData { (data, objectID, error) in
                if (error == nil) && (data != nil) {
                    self.icon.image = UIImage(data: data!)
                }else {
                    self.icon.image = UIImage(named: "placeholder_sq")
                }
            }
            
            // 未读数
            if let count = conversation.unreadCount?.intValue {
                if count > 0 {
                    unReadCountLab.isHidden = false
                    unReadCountLab.text = "\(count)"
                }else {
                    unReadCountLab.isHidden = true
                }
            }

            // 时间
            if var time = conversation.latestMessage?.timestamp.doubleValue {
                if time > 1999999999 {
                    time /= 1000
                }
                timeLab.text = NSString.getFriendlyDateString(time, forConversation: true)
            }else {
                timeLab.text = "时间为空"
            }
            
        
        }
    }
}
