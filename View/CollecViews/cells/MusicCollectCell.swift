//
//  MusicCollectCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/12/7.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class MusicCollectCell: UITableViewCell {

    @IBOutlet weak var albumtitle: UILabel!
    @IBOutlet weak var singer: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var model: MusicModel! {
        
        didSet {
            
            albumtitle.text = "电台：" + (model.playinfo?.albumTitle!)!
            singer.text = model.singer!
            img.image = UIImage(data: model.img!)
            title.text = (model.playinfo?.title)!
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
