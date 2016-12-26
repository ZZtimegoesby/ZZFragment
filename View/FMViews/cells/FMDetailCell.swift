//
//  FMDetailCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/22.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class FMDetailCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var newImg: UIImageView!
    @IBOutlet weak var listButton: UIButton!
    
    var model: FMDetailModel? {
        
        didSet {
            
            img.af_setImage(withURL: URL.init(string: (model?.coverimg)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultCover"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true) { (response) in
                
                if response.result.isSuccess {
                    
                    self.model?.imageData = UIImagePNGRepresentation(response.result.value!)
                    self.model?.playInfo?.imageData = UIImagePNGRepresentation(response.result.value!)
                }
            }
            titleLabel.text = model!.title!
            countLabel.text = model!.musicVisit!
            
            if model!.isnew! == 1 {
                
                newImg.isHidden = false
            }
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
