//
//  ChatMoreView.swift
//  JChat
//
//  Created by Young on 2017/4/14.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

enum ChatMoreViewActionType {
    case photo
    case camera
}

protocol ChatMoreViewDelegate : class {
    func chatMoreViewClick(_ moreView : ChatMoreView, type : ChatMoreViewActionType)
}

fileprivate let kChatMoreViewCollecCellWidth : CGFloat = 60.0
fileprivate let kChatMoreViewCollecCellID = "kChatMoreViewCollecCellID"

class ChatMoreView: UIView {
    
    weak var delegate : ChatMoreViewDelegate?

    fileprivate lazy var collecView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: kChatMoreViewCollecCellWidth, height: kChatMoreViewCollecCellWidth)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        let collecView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        collecView.register(UINib(nibName: "ChatMoreViewCell", bundle: nil), forCellWithReuseIdentifier: kChatMoreViewCollecCellID)
        collecView.backgroundColor = kDefault_BackgroundColor
        collecView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collecView.dataSource = self
        collecView.delegate = self
        return collecView
    }()
    
    fileprivate lazy var dataArr : [ChatMoreModel] = {
        var dataArr = [ChatMoreModel]()
        dataArr += ChatMoreVIewDataSource.getMoreViewData()
        return dataArr
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: ui
extension ChatMoreView {

    fileprivate func setupUI(){
        
        addSubview(collecView)
        
    }
}

extension ChatMoreView : UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kChatMoreViewCollecCellID, for: indexPath) as! ChatMoreViewCell
        cell.model = dataArr[indexPath.item]
        return cell
    }
}

extension ChatMoreView : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.chatMoreViewClick(self, type: .photo)
        
    }
}
