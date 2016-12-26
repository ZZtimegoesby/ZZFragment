//
//  FMListCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/21.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class FMListCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var playcount: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    
    var model: FMHotListModel? {
        
        didSet {
            
            img.af_setImage(withURL: URL.init(string: (model?.coverimg!)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultCover"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
            title.text = (model?.title)!
            author.text = String.init(format: "by:%@", (model!.userinfo?.uname)!)
            desc.text = model!.desc!
            
            if model?.isnew == 1 {
                
                newImage.isHidden = false
            }
            playcount.text = "\((model!.count)!)"
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
