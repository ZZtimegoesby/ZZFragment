//
//  TodayCellFooterView.swift
//  ZZFragment
//
//  Created by zhangzheng on 16/12/26.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class TodayCellFooterView: UITableViewCell {

    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var like: UILabel!
    @IBOutlet weak var visit: UILabel!
    
    var model: TodayModel? {
        
        didSet {
            
            author.text = "By：" + (model?.userinfo?.uname)!
            like.text = "\(model!.like!)"
            visit.text = "\(model!.view!)"
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
