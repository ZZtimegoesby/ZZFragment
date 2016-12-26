//
//  GroupCollectionViewCell2.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/23.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class GroupCollectionViewCell2: UICollectionViewCell {

    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
    
    var model: latestposts? {
        
        didSet {
            
            title.text = (model?.title)!
            
            desc.text = (model?.content)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
