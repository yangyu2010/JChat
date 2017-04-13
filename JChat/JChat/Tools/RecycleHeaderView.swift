//
//  RecycleHeaderView.swift
//  HuaChuMall
//
//  Created by Young on 2017/3/30.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

fileprivate let kRecycleCellID = "kRecycleCellID"
fileprivate let kRecycleCellNumer : Int = 10000

class RecycleHeaderView: UIView {

    @IBOutlet weak var recycleView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // 设置该控件不随着父控件的拉伸而拉伸
        autoresizingMask = UIViewAutoresizing()
        
        recycleView.register(UINib(nibName: "RecycleViewCell", bundle: nil), forCellWithReuseIdentifier: kRecycleCellID)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let layout = recycleView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = recycleView.bounds.size

    }
    
    // MARK: -自定义属性
    var imgArr : [String]? {
        didSet {
            guard imgArr != nil else { return }
            
            // 1.刷新数据
            recycleView.reloadData()
            
            // 2.设置pageController的总个数
            pageControl.numberOfPages = imgArr!.count
            
            // 3.设置collectionView滚动到中间某个位置
            DispatchQueue.main.async {
                let path = IndexPath(item: self.imgArr!.count * kRecycleCellNumer / 2, section: 0)
                self.recycleView.scrollToItem(at: path, at: .left, animated: false)
            }
            
            // 4.添加定时器
            addTimer()
        }
    }
    
    /// 定时器
    fileprivate var timer : Timer?
}

// MARK: -数据源
extension RecycleHeaderView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (imgArr?.count ?? 0) * kRecycleCellNumer
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kRecycleCellID, for: indexPath) as! RecycleViewCell
        cell.iconImg.image = UIImage(named: imgArr![indexPath.item % imgArr!.count])
        return cell
    }
    
}

// MARK: -代理
extension RecycleHeaderView : UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width * 0.5
        
        let count = Int(offsetX / scrollView.bounds.width)
        
        pageControl.currentPage = count % imgArr!.count
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
}

// MARK: -处理timer
extension RecycleHeaderView {
    
    fileprivate func addTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.scrollToNext), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    fileprivate func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc fileprivate func scrollToNext() {
        let currentOffsetX = recycleView.contentOffset.x
        let offset = currentOffsetX + recycleView.bounds.width
        
        recycleView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
    }
}


extension RecycleHeaderView {
    
    class func creatView() -> RecycleHeaderView {
        
        return Bundle.main.loadNibNamed("RecycleHeaderView", owner: nil, options: nil)?.first as! RecycleHeaderView
    }
}
