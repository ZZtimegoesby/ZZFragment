//
//  FMHotListCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/22.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class FMHotListCell: UICollectionViewCell {

    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var model: FMHotListModel? {
        
        didSet {
            
            descLabel.text = model!.title!
            
            authorLabel.text = "by:" + model!.userinfo!.uname!
            
            img.af_setImage(withURL: URL.init(string: (model?.coverimg!)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultCover"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
