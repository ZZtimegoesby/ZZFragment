//
//  FreedomWirteCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/26.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import AlamofireImage

class FreedomWirteCell: UITableViewCell {

    @IBOutlet weak var imgWidthLayout: NSLayoutConstraint!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var img: UIImageView!
    
    var model: FreedomWriteModel? {
        
        didSet {
            
            if model!.firstimage! != "" {
                
                img.af_setImage(withURL: URL.init(string: (model?.firstimage)!)!, placeholderImage: #imageLiteral(resourceName: "groupDefaultBanner"), filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.3), runImageTransitionIfCached: true, completion: {(response) in
                    
                    if response.result.isSuccess {
                        
                        self.model?.imageData = UIImagePNGRepresentation(response.result.value!)
                    }
                })
                
            } else {
                
                imgWidthLayout.constant = 0
            }
                        
            icon.af_setImage(withURL: URL.init(string: (model?.userinfo?.icon)!)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .crossDissolve(0.2), runImageTransitionIfCached: true, completion: nil)
            
            name.text = (model?.userinfo?.uname)!
            time.text = model!.addtime_f!
            title.text = model!.title!
            
            if model!.shortcontent! != "" {
                
                desc.text = model!.shortcontent!
            }
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
