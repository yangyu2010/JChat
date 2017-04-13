//
//  MessageListController.swift
//  JChat
//
//  Created by Young on 2017/4/11.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

fileprivate let kConversationTableCellID = "kConversationTableCellID"

class MessageListController: UIViewController {

    /// 装载所有会话的数组
    fileprivate lazy var conversationArr : [JMSGConversation] = [JMSGConversation]()
    
    fileprivate lazy var conversationTable : UITableView = {
        let frame = CGRect(x: 0, y: 0, width: kScreen_Width, height: kScreen_Height)
        let conversationTable = UITableView(frame: frame, style: .plain)
        conversationTable.register(UINib(nibName: "MessageListCell", bundle: nil), forCellReuseIdentifier: kConversationTableCellID)
        conversationTable.dataSource = self
        conversationTable.delegate = self
        conversationTable.separatorStyle = .singleLine
        conversationTable.tableFooterView = UIView()
        return conversationTable
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        getConversationList()
    }

    deinit {
        JMessage.remove(self, with: nil)
    }
    
}

// MARK: ui
extension MessageListController {

    fileprivate func setupUI(){
        
        view.backgroundColor = .white
        
        JMessage.add(self, with: nil)
        
        view.addSubview(conversationTable)
    }
}


extension MessageListController {

    fileprivate func getConversationList() {

        JMSGConversation.allConversations { (result, error) in
            if error == nil {
                self.conversationArr.removeAll()
                guard let result = result as? [JMSGConversation] else { return }
                self.conversationArr += result
                self.conversationTable.reloadData()
            }else {
                self.conversationArr.removeAll()
            }
        }
    }
}

// MARK: DataSource
extension MessageListController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kConversationTableCellID, for: indexPath) as! MessageListCell
        cell.conversation = conversationArr[indexPath.item]
        return cell
    }
    
}

// MARK: Delegate
extension MessageListController : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chattingVC = ChatViewController()
        chattingVC.conversation = conversationArr[indexPath.item]
        navigationController?.pushViewController(chattingVC, animated: true)
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let conversation = conversationArr[indexPath.item]
        guard let user = conversation.target as? JMSGUser else { return  }
        JMSGConversation.deleteSingleConversation(withUsername: user.username)
        conversationArr.remove(at: indexPath.item)
        conversationTable.deleteRows(at: [indexPath], with: .none)
    }
}

extension MessageListController : JMessageDelegate {

    func onReceive(_ message: JMSGMessage!, error: Error!) {
        getConversationList()
    }
    
    func onConversationChanged(_ conversation: JMSGConversation!) {
        getConversationList()
    }
}


