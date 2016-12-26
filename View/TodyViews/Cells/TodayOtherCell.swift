//
//  TodayOtherCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/17.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class TodayOtherCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var desclabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var model: TodayModel? {
        
        didSet {
            
            nameLabel.text = (model?.name)! + "·" + (model?.enname)!
            titleLabel.text = (model?.title)!
            desclabel.text = (model?.content)!
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
