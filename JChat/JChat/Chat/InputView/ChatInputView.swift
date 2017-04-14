//
//  ChatInputView.swift
//  JChat
//
//  Created by Young on 2017/4/13.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

enum ChatInputViewActionType {
    case send
    case add
}

protocol ChatInputViewDelegate : class {
    func chatInputViewAction(_ inputView : ChatInputView, actionType : ChatInputViewActionType, isUP : Bool)
}

class ChatInputView: UIView {

    @IBOutlet weak var textView: ChatTextView!
    @IBOutlet weak var addBtn: UIButton!
    
    weak var delegate : ChatInputViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textView.delegate = self
    }

    @IBAction func addClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        delegate?.chatInputViewAction(self, actionType: .add, isUP: sender.isSelected)
    }
    
}

extension ChatInputView : UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text as NSString).isEqual(to: "\n") {
            print("发送按钮")
            delegate?.chatInputViewAction(self, actionType: .send, isUP: false)
            return false
        }
        return true
    }
}


extension ChatInputView {

    class func creatView() -> ChatInputView {
        return Bundle.main.loadNibNamed("ChatInputView", owner: nil, options: nil)?.first as! ChatInputView
    }
}
