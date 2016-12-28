//
//  TodayMusicCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/17.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import AlamofireImage

class TodayMusicCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var model: TodayModel? {
        
        didSet {
            
            nameLabel.text = (model?.name)! + "·" + (model?.enname)!
            titleLabel.text = (model?.title)!
            img.af_setImage(withURL: URL.init(string: (model!.playInfo?.imgUrl)!)!, placeholderImage: #imageLiteral(resourceName: "personPageNothing"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
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
