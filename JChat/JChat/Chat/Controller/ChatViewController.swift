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

fileprivate let kChatTableViewCellID = "kChatTableViewCellID"

class ChatViewController: UIViewController {

    // 当前聊天的会话
    var conversation : JMSGConversation!
    
    // 整个消息数组
    fileprivate lazy var messagesArr : [JMSGMessage] = [JMSGMessage]()
    
    fileprivate lazy var messageTable : UITableView = {
        let messageTable = UITableView(frame: self.view.bounds, style: .plain)
        messageTable.dataSource = self
        messageTable.register(UINib(nibName: "ChatLeftTableViewCell", bundle: nil), forCellReuseIdentifier: kChatTableViewCellID)
        messageTable.separatorStyle = .none
        return messageTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getPageMessage()
    }

}

// MARK: ui 
extension ChatViewController {
    
    fileprivate func setupUI() {
    
        view.backgroundColor = .white
        view.addSubview(messageTable)
        messageTable.rowHeight = UITableViewAutomaticDimension
        messageTable.estimatedRowHeight = 150.0
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: kChatTableViewCellID, for: indexPath) as! ChatLeftTableViewCell
        cell.message = messagesArr[indexPath.item];

        return cell
    }
}




