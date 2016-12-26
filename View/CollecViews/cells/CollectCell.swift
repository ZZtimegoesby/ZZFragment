//
//  CollectCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/10.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class CollectCell: UITableViewCell {

    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var authorDesc: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var model: ArticleModel! {
        
        didSet {
            
            name.text = (model.userinfo?.uname)!
            authorDesc.text = (model.userinfo?.desc)!
            icon.image = UIImage(data: (model.userinfo?.icon)!)
            
            if model.coverimg == nil {
                
                imgWidthConstraint.constant = 0
            } else {
                
                img.image = UIImage(data: model.coverimg!)
            }
            title.text = (model.title)!
            desc.text = (model.content)!
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
