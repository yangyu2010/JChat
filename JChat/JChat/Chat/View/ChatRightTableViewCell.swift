//
//  ChatRightTableViewCell.swift
//  JChat
//
//  Created by Young on 2017/4/13.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

class ChatRightTableViewCell: ChatBaseCell {

    @IBOutlet weak var messageLabWidthCons: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        messageLabWidthCons.constant = kScreen_Width  - (15 + 50 + 16) * 2

    }
    
}
