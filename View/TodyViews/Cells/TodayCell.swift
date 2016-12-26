//
//  TodayCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/17.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import AlamofireImage

class TodayCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    var model: TodayModel? {
        
        didSet {
            
            nameLabel.text = (model?.name)! + "·" + (model?.enname)!
            
            img.af_setImage(withURL: URL.init(string: model!.coverimg!)!, placeholderImage: #imageLiteral(resourceName: "personPageNothing"), filter: nil, progress: nil, progressQueue: .main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true) { (response) in
                
                if response.result.isSuccess {
                    
                    self.model?.imageData = UIImagePNGRepresentation(response.result.value!)
                }
            }
            
            titleLabel.text = (model?.title)!
            descLabel.text = (model?.content)!
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
