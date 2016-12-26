//
//  FragPictrueCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/19.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import AlamofireImage

class FragPictrueCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var talkLabel: UILabel!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    var model: FragmentModel? {
        
        didSet{
            
            nameLabel.text = model!.userinfo!.uname!
            
            icon.af_setImage(withURL: URL.init(string: model!.userinfo!.icon!)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
            
            if model!.coverimg! != "" {
                
                img.af_setImage(withURL: URL.init(string: (model?.coverimg)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultCover"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
            }
            
            timeLabel.text = model!.addtime_f
            descLabel.text = model!.content
            talkLabel.text = "\((model!.counterList!["comment"])!)"
            likeLabel.text = "\((model!.counterList!["like"])!)"
            
            imageHeightConstraint.constant = (model?.imgHeight)!
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
