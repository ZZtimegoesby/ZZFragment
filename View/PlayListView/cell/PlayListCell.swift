//
//  PlayListCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/30.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class PlayListCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
