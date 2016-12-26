//
//  GroupSectionHeaderView.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/31.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class GroupSectionHeaderView: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var counts: UILabel!
    @IBOutlet weak var tags: UILabel!
    
    var model: GroupModel? {
        
        didSet {
            
            title.text = "小组名：" + (model?.title)!
            
            img.af_setImage(withURL: URL.init(string: (model?.coverimg)!)!)
            
            for srt in (model?.tags)! {
                
                tags.text?.append((srt as! String) + "/")
            }
            
            counts.text = "\(model!.membernum!)位成员"
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
