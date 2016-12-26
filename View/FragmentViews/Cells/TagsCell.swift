//
//  TagsCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/20.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import AlamofireImage

class TagsCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var recommendImg: UIImageView!
    var model: tagsModel? {
        
        didSet {
            
            titleLabel.text = model?.tag!
            
            backImg.af_setImage(withURL: URL.init(string: (model?.img)!)!, placeholderImage: #imageLiteral(resourceName: "imagePlaceHolder"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
            if model?.top == 1 {
                
                recommendImg.isHidden = false
            }
            countLabel.text = "\(model!.count!)条"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
