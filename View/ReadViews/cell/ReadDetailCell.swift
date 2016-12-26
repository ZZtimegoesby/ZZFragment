//
//  ReadDetailCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/26.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class ReadDetailCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var model: ReadDetailModel? {
        
        didSet {
            
            titleLabel.text = model!.title!
            descLabel.text = model!.content!
            img.af_setImage(withURL: URL.init(string: (model?.coverimg)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultBanner"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true, completion: {(response) in
                
                if response.result.isSuccess {
                    
                    self.model?.imageData = UIImagePNGRepresentation(response.result.value!)
                }
            })
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
