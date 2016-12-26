//
//  GroupCollectionViewCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/31.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var desc: UILabel!
    
    var model: latestposts? {
        
        didSet {
                
            img.af_setImage(withURL: URL.init(string: (model?.coverimg)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultCover"), filter: nil, progress: nil, progressQueue: .main, imageTransition: UIImageView.ImageTransition.flipFromLeft(0.1), runImageTransitionIfCached: true, completion: nil)
            
            title.text = (model?.title)!
            
            desc.text = (model?.content)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
