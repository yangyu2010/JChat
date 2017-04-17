//
//  ChatRightImageCell.swift
//  JChat
//
//  Created by Young on 2017/4/17.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

class ChatRightImageCell: ChatBaseCell {

    @IBOutlet weak var contentImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var message: JMSGMessage? {
        didSet {
            super.message = message
            
            if message?.contentType == .image {
                guard let content = message?.content as? JMSGImageContent else { return  }
                content.thumbImageData({[weak self] (data, objectId, error) in
                    if data != nil {
                        self?.contentImg.image = UIImage(data: data!)
                    }
                })
            }
        }
    }
    
}
