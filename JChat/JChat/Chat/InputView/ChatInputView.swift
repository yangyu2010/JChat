//
//  ChatInputView.swift
//  JChat
//
//  Created by Young on 2017/4/13.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

class ChatInputView: UIView {

    @IBOutlet weak var textView: ChatTextView!

    @IBAction func addClick(_ sender: UIButton) {
        
        
    }
    
}


extension ChatInputView {

    class func creatView() -> ChatInputView {
        return Bundle.main.loadNibNamed("ChatInputView", owner: nil, options: nil)?.first as! ChatInputView
    }
}
