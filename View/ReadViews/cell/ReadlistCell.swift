//
//  ReadlistCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class ReadlistCell: UICollectionViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var model: ReadCellModel? {
        
        didSet {
            
            title.text = (model?.name)! + "·" + (model?.enname)!
            
            img.af_setImage(withURL: URL.init(string: (model?.coverimg!)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultCover"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
