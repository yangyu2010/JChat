//
//  YYTitleView.swift
//  DouYuZhiBo
//
//  Created by Young on 2017/2/15.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

protocol YYTitleViewDelegate : NSObjectProtocol {
    
    func yyTitleViewScrollToIndex(index: Int)
    
}

// 滑动底线的高度
fileprivate let kScrollLineViewH: CGFloat = 2.0
// 普通状态的颜色
fileprivate let kNomalColor: (CGFloat, CGFloat ,CGFloat) = (102, 102, 102)
//// 被选中的颜色
fileprivate let kSelectedColor: (CGFloat, CGFloat ,CGFloat) = (224, 0, 49)

class YYTitleView: UIView {

    // MARK: -自定义属性
    open var titles : [String]?
    
    fileprivate var originalIndex: Int = 0
    weak var delegate: YYTitleViewDelegate?
    
    // MARK: -懒加载
    fileprivate lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor.white
        return scroll
    }()
    
    fileprivate lazy var segmentView: UIView = {
        let vi = UIView()
        vi.backgroundColor = UIColor.white
        return vi
    }()
    
    fileprivate lazy var lineView: UIView = {
        let vi = UIView()
        vi.backgroundColor = kDefault_Color
        return vi
    }()
    
    fileprivate lazy var labelArr: [UILabel] = [UILabel]()
    
    
//    // MARK: -构造函数
//    init(frame: CGRect, titles: [String]) {
//        super.init(frame: frame)
//        
//        self.titles = titles
//        
//        //setupUI()
//    }

    init(titles: [String]) {
        super.init(frame: CGRect.zero)
        
        self.titles = titles
        
//        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
        
        print("YYTitleView -- layoutSubviews")
    }
}


// MARK: -设置UI
extension YYTitleView {

    fileprivate func setupUI() {
        
        guard let titles = titles else { return }
        
        // 1.添加scroll
        scrollView.frame = bounds
        addSubview(scrollView)

        let labY: CGFloat = 0
        let labW: CGFloat = scrollView.frame.width / CGFloat(titles.count)
        let labH: CGFloat = scrollView.frame.height
        
        // 2.添加底部分割线
        segmentView.frame = CGRect(x: 0, y: bounds.height - kSingle_Line_Width, width: bounds.width, height: kSingle_Line_Width)
        addSubview(segmentView)
        
        // 3.添加滑动的View
        lineView.frame = CGRect(x: 0, y: bounds.height - kScrollLineViewH, width: labW, height: kScrollLineViewH)
        addSubview(lineView)

        for (index,title) in titles.enumerated() {
            
            let lab = UILabel()
            lab.frame = CGRect(x: CGFloat(index) * labW, y: labY, width: labW, height: labH)
            lab.text = title
            lab.textAlignment = .center
            lab.font = UIFont.systemFont(ofSize: 16.0)
            lab.tag = index
            if index == 0 {
                lab.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
            }else {
                lab.textColor = UIColor(r: kNomalColor.0, g: kNomalColor.1, b: kNomalColor.2)
            }
            scrollView.addSubview(lab)
            labelArr.append(lab)
            
            // 添加手势
            lab.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(tap:)))
            lab.addGestureRecognizer(tap)
        }
    }
}

// MARK: -title点击事件
extension YYTitleView {

    @objc fileprivate func titleLabelClick(tap: UITapGestureRecognizer) {
        
        let currentLab = tap.view as? UILabel
        
        if currentLab?.tag == originalIndex { return }
        
        // 1.设置文字颜色
        let originalLab = labelArr[originalIndex]
        originalLab.textColor = UIColor(r: kNomalColor.0, g: kNomalColor.1, b: kNomalColor.2)
        currentLab?.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        
        // 2.取出当前是第几个
        if let currentIndex = currentLab?.tag,
            let currentLab = currentLab {
                
            originalIndex = currentIndex
            
            // 3.设置线滑动
            UIView.animate(withDuration: 0.3, animations: {
                self.lineView.frame.origin.x = CGFloat(currentIndex) * currentLab.frame.width
            })
            
            // 4.通知代理点击了第几个
            delegate?.yyTitleViewScrollToIndex(index: currentIndex)
        }
    }
}

// MARK: -设置滑动效果
extension YYTitleView {

    func setTitleView(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
    
        // 1.取出label
        let sourceLab = labelArr[sourceIndex]
        let targetLab = labelArr[targetIndex]
        
        // 2.处理滑块
        let moveTotalX = targetLab.frame.origin.x - sourceLab.frame.origin.x
        let moveX = moveTotalX * progress
        lineView.frame.origin.x = sourceLab.frame.origin.x + moveX
        
        // 3.处理字体颜色
        let colorDelta = (kSelectedColor.0 - kNomalColor.0, kSelectedColor.1 - kNomalColor.1, kSelectedColor.2 - kNomalColor.2)
        
        //print(colorDelta)
        
        sourceLab.textColor = UIColor(r: kSelectedColor.0 - colorDelta.0 * progress,
                                      g: kSelectedColor.1 - colorDelta.1 * progress,
                                      b: kSelectedColor.1 - colorDelta.1 * progress)
        targetLab.textColor = UIColor(r: kNomalColor.0 + colorDelta.0 * progress,
                                      g: kNomalColor.1 + colorDelta.1 * progress,
                                      b: kNomalColor.2 + colorDelta.2 * progress)
        
        originalIndex = targetIndex
    }
}




