//
//  GroupSectionFooterView.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/31.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class GroupSectionFooterView: UITableViewCell {

    @IBOutlet weak var lastUpdata: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var model: GroupModel? {
        
        didSet {
            
            lastUpdata.text = "最后更新时间：  " + (model?.lastupdate_f)!
            desc.text = "小组签名：\r" + (model?.desc!)!
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
