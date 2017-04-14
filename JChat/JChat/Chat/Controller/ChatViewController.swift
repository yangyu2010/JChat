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
import IQKeyboardManagerSwift

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
        moreView.delegate = self
        return moreView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /// 设置ui
        setupUI()
        
        /// 添加通知
        addNotification()
        
        /// 监听会话
        JMessage.add(self, with: self.conversation)
        
        /// 请求数据
        getPageMessage()
    }
    
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.sharedManager().enable = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.sharedManager().enable = true
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

// MARK: method处理键盘事件
extension ChatViewController {
    
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame(note:)), name: .UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: .UIKeyboardDidShow, object: nil)
    }
    
    /// 监听键盘事件 改变table 和 输入框的位置
    @objc fileprivate func keyboardWillChangeFrame(note : NSNotification) {
        
        let dict = note.userInfo!
        let duration =  dict[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let endFrame = (dict[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //偏移输入框和table
        UIView.animate(withDuration: duration) {
            self.chatInputView.y = endFrame.origin.y - kTabBar_Height
            self.messageTable.y = -kScreen_Height + endFrame.origin.y
        }

    }
    
    /// 如果moreView当前显示在, 点击输入框, 这个时候去隐藏moreView
    @objc fileprivate func keyboardDidShow() {
    
        if self.chatInputView.addBtn.isSelected {
            self.chatInputView.addBtn.isSelected = false
            inputViewChangedFrame(isUP: false)
        }
    }
    
    /// moreView的显示与隐藏
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

// MARK: 发送接收消息
extension ChatViewController {

    fileprivate func sendTextMessage(_ messageText: String) {
        let textContent = JMSGTextContent(text: messageText)
        guard let textMessage = conversation.createMessage(with: textContent) else { return }
        conversation.send(textMessage)
        messagesArr.append(textMessage)
        tableViewReloadData()
    }
    
    
}


// MARK: 数据
extension ChatViewController {

    fileprivate func getPageMessage() {
        
        let messagesArr = conversation.messageArrayFromNewest(withOffset: nil, limit: nil)
        
        self.messagesArr += messagesArr.reversed()

        tableViewReloadData()
    }
    
    fileprivate func tableViewReloadData() {
        tableViewScrollToBottom()
        messageTable.reloadData()
    }
    
    fileprivate func tableViewScrollToBottom() {

        messageTable.setContentOffset(CGPoint(x: 0, y: CGFloat(MAXFLOAT)), animated: false)
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

// MARK: 输入框代理
extension ChatViewController : ChatInputViewDelegate {
    func chatInputViewAction(_ inputView: ChatInputView, actionType: ChatInputViewActionType, isUP: Bool) {
        if actionType == .add {
            inputViewChangedFrame(isUP: isUP)
        }else if actionType == .send {
            sendTextMessage(inputView.textView.text)
        }
    }
    
}

// MARK: moreView代理
extension ChatViewController : ChatMoreViewDelegate {

    func chatMoreViewClick(_ moreView: ChatMoreView, type: ChatMoreViewActionType) {
        
        if type == .photo {
            
            if !UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                //ShowTip.showHudTip(tipStr: "相册不可用")
                return
            }
            
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.isEditing = true
            present(picker, animated: true, completion: nil)
            
        }else {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            picker.isEditing = true
            present(picker, animated: true, completion: nil)
        }
    }
}

// MARK: 相机代理
extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        
        print(image)
        
//        imagesArr.append(image)
//        picCollecV.imagesArr = imagesArr
        picker.dismiss(animated: true, completion: nil)
        
    }

}

// MARK: 消息监听
extension ChatViewController : JMessageDelegate {

    func onReceive(_ message: JMSGMessage!, error: Error!) {
        if error != nil {
            return
        }
        
//        if message.contentType == .text {
//            
//        }
        
        messagesArr.append(message)
        tableViewReloadData()
    }
}

