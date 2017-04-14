//
//  ChatMoreViewCell.swift
//  JChat
//
//  Created by Young on 2017/4/14.
//  Copyright © 2017年 YuYang. All rights reserved.
//

import UIKit

class ChatMoreViewCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var titleLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    var model : ChatMoreModel? {
        didSet {
            guard let model = model else { return }
            
            if let img = model.img {
                icon.image = UIImage(named: img)
            }
            titleLab.text = model.title
        }
    }
}
