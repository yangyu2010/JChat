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

class ChatViewController: UIViewController {

    /// 当前聊天的会话
    var conversation : JMSGConversation!
    
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
        return chatInputView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getPageMessage()
        
        // 直接发送文字消息
        //JMSGMessage.sendSingleTextMessage("呵呵哈哈哈看花见花开很看好看很好好看", toUser: "test3")
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }

}


// MARK: ui 
extension ChatViewController {
    
    fileprivate func setupUI() {
    
        view.backgroundColor = .white
        view.addSubview(messageTable)
        view.addSubview(chatInputView)
//        view.backgroundColor = kDefault_BackgroundColor
    }
}

extension ChatViewController {

    @objc fileprivate func keyboardWillChangeFrame(note : NSNotification) {
        
        let dict = note.userInfo!
        
        let duration =  dict[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame = (dict[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue

        UIView.animate(withDuration: duration) {
            self.chatInputView.y = endFrame.origin.y - kTabBar_Height
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




