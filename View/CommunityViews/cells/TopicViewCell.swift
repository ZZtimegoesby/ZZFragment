//
//  TopicViewCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/28.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class TopicViewCell: UITableViewCell {

    @IBOutlet weak var labelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var talkLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var visitLabel: UILabel!
    
    var model: TopicModel? {
        
        didSet {
            
            name.text = model!.userinfo!.uname
            
            icon.af_setImage(withURL: URL.init(string: (model?.userinfo?.icon)!)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
            
            if model!.coverimg! != "" {
                
                img.af_setImage(withURL: URL.init(string: (model?.coverimg)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultCover"), filter: nil, progress: nil, progressQueue: .main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.2), runImageTransitionIfCached: true, completion: {(response) in
                    
                    if response.result.isSuccess {
                        
                        self.model?.imageData = UIImagePNGRepresentation(response.result.value!)
                    }
                })
            }
            
            title.text = model!.title
            
            desc.text = model!.content
            
            time.text = model!.addtime_f
            talkLabel.text = "\((model!.counterList?.comment)!)"
            likeLabel.text = "\((model!.counterList?.like)!)"
            visitLabel.text = "\((model!.counterList?.view)!)"
            
            imgHeightConstraint.constant = (model?.imageHeight)!
            labelHeightConstraint.constant = (model?.LabelHeight)!
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
