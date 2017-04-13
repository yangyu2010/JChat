//
//  ChatTextField.swift
//  JChat
//
//  Created by Young on 2017/4/13.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

class ChatTextView: UITextView {

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
                
        layer.masksToBounds = true
        layer.cornerRadius = 8.0
        layer.borderWidth = kSingle_Line_Width
        layer.borderColor = UIColor(hexColorString: "d4d4d4")?.cgColor
        
        returnKeyType = .send
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        super.canPerformAction(action, withSender: sender)
        
        return  (action == #selector(self.paste(_:))) || (action == #selector(self.resignFirstResponder))
    }
    
    override var canResignFirstResponder: Bool {
        return true
    }
    
    
    override func paste(_ sender: Any?) {
        let pasteboard = UIPasteboard.general
        let textAttachment = NSTextAttachment()
        if pasteboard.string != nil {
            super.paste(sender)
            return
        }
        
        if pasteboard.image != nil {
            textAttachment.image = pasteboard.image
            //JChatAlertViewManager.sharedInstance.showPastedImageMessageAlert(pasteboard.image!)
            // 发送图片
        }
    }
}
