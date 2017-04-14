//
//  ChatViewController.swift
//  JChat
//
//  Created by Young on 2017/4/11.
//  Copyright © 2017年 YuYang. All rights reserved.
/*
 // 直接发送消息对象
 //        let message = JMSGMessage.createSingleMessage(with: JMSGTextContent(text: "测试消息"), username: "test2")
 //        JMSGMessage.send(message)
 
 // 直接发送文字消息
 JMSGMessage.sendSingleTextMessage("测试消息2", toUser: "test2")
 
 // 发送图片
 guard let img = UIImage(named: "161024214104.jpg") else { return }
 guard let data = UIImageJPEGRepresentation(img, 1) else { return  }
 JMSGMessage.sendSingleImageMessage(data, toUser: "test3")
 
 
 */

import UIKit
import SnapKit
import Sugar

fileprivate let kChatTableViewLeftCellID = "kChatTableViewLeftCellID"
fileprivate let kChatTableViewRightCellID = "kChatTableViewRightCellID"
fileprivate let kMoreViewHeight : CGFloat = 80
fileprivate let kFrameChangeDuration : TimeInterval = 0.25

class ChatViewController: UIViewController {

    /// 当前聊天的会话
    var conversation : JMSGConversation!
    
    /// 记录键盘是否是上升
    fileprivate lazy var keyboardIsUP : Bool = false
    
    /// 整个消息数组
    fileprivate lazy var messagesArr : [JMSGMessage] = [JMSGMessage]()
    
    /// table
    fileprivate lazy var messageTable : UITableView = {
        let frame = CGRect(x: 0, y: 0, width: kScreen_Width, height: kScreen_Height - kTabBar_Height)
        let messageTable = UITableView(frame: frame, style: .plain)
        messageTable.dataSource = self
        messageTable.register(UINib(nibName: "ChatLeftTableViewCell", bundle: nil), forCellReuseIdentifier: kChatTableViewLeftCellID)
        messageTable.register(UINib(nibName: "ChatRightTableViewCell", bundle: nil), forCellReuseIdentifier: kChatTableViewRightCellID)
        messageTable.separatorStyle = .none
        messageTable.rowHeight = UITableViewAutomaticDimension
        messageTable.estimatedRowHeight = 150.0
        messageTable.backgroundColor = kDefault_BackgroundColor
        return messageTable
    }()
    
    /// input
    fileprivate lazy var chatInputView : ChatInputView = {
        let chatInputView = ChatInputView.creatView()
        chatInputView.frame = CGRect(x: 0, y: self.messageTable.frame.maxY, width: kScreen_Width, height: kTabBar_Height)
        chatInputView.delegate = self
        return chatInputView
    }()
    
    //footer
    fileprivate lazy var moreView : ChatMoreView = {
        let rect = CGRect(x: 0, y: kScreen_Height, width: kScreen_Width, height: kMoreViewHeight)
        let moreView = ChatMoreView(frame: rect)
        
        return moreView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getPageMessage()
        
        // 直接发送文字消息
        //JMSGMessage.sendSingleTextMessage("呵呵哈哈哈看花见花开很看好看很好好看", toUser: "test3")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
        
    }

}


// MARK: ui 
extension ChatViewController {
    
    fileprivate func setupUI() {
    
        view.backgroundColor = .white
        view.addSubview(messageTable)
        view.addSubview(chatInputView)
        view.addSubview(moreView)
        
        view.backgroundColor = kDefault_BackgroundColor
    }
}

// MARK: method
extension ChatViewController {

    @objc fileprivate func keyboardDidShow() {
       
        if chatInputView.addBtn.isSelected {
            chatInputView.addBtn.isSelected = false
            inputViewChangedFrame(isUP: false)
        }
    }
    
    fileprivate func inputViewChangedFrame(isUP : Bool) {
        
        UIView.animate(withDuration: kFrameChangeDuration) {
            if isUP {
                
                self.chatInputView.textView.resignFirstResponder()
                
                //升
                self.chatInputView.y = kScreen_Height - kTabBar_Height - kMoreViewHeight
                self.moreView.y = kScreen_Height - kMoreViewHeight
                self.messageTable.y =  -kMoreViewHeight
            }else {
                
                //降
                self.chatInputView.y = kScreen_Height - kTabBar_Height
                self.moreView.y = kScreen_Height
                self.messageTable.y = 0
            }
 
        }
    }
}

extension ChatViewController : ChatInputViewDelegate {
    func chatInputViewAction(_ inputView: ChatInputView, actionType: ChatInputViewActionType, isUP: Bool) {
        if actionType == .add {
            inputViewChangedFrame(isUP: isUP)
        }
    }

}

// MARK: 数据
extension ChatViewController {

    fileprivate func getPageMessage() {
        
        let messagesArr = conversation.messageArrayFromNewest(withOffset: nil, limit: nil)
        
        self.messagesArr += messagesArr
        
        messageTable.reloadData()
        
    }
}

// MARK: DataSource
extension ChatViewController : UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = messagesArr[indexPath.item]
        if message.isReceived {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: kChatTableViewLeftCellID, for: indexPath) as! ChatLeftTableViewCell
            cell.message = message
            return cell
            
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: kChatTableViewRightCellID, for: indexPath) as! ChatRightTableViewCell
            cell.message = message
            return cell
        }
        
        
    }
}




