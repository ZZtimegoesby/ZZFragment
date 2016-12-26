//
//  FMDetailHeaderCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/24.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class FMDetailHeaderCell: UITableViewCell {

    @IBOutlet weak var headImg: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var model: FMHeaderModel? {
        
        didSet {
            
            headImg.af_setImage(withURL: URL.init(string: (model?.coverimg!)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultBanner"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.curlDown(0.3), runImageTransitionIfCached: true, completion: nil)
            
            icon.af_setImage(withURL: URL.init(string: (model?.userinfo?.icon!)!)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.curlDown(0.3), runImageTransitionIfCached: true, completion: nil)
            
            nameLabel.text = (model?.userinfo?.uname)!
            countLabel.text = "\(model!.musicvisitnum!)"
            descLabel.text = model!.desc!
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
