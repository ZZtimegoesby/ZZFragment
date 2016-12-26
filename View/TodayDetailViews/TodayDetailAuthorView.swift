//
//  TodayDetailAuthorView.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/20.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class TodayDetailAuthorView: UIView {

    var icon: UIImageView!
    var nameLabel: UILabel!
    var descLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        
        icon = UIImageView.init(frame: CGRect.init(x: 10, y: 10, width: 40, height: 40))
        
        icon.layer.cornerRadius = 20
        icon.clipsToBounds = true
        
        self.addSubview(icon)
        
        let blackView = ToolsWays.createView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 1), backgroundCollor: UIColor.gray)
        
        nameLabel = ToolsWays.createLabel(frame: CGRect.init(x: icon.frame.origin.x + 60, y: 10, width: 200, height: 20), labelText: nil, textColor: UIColor.black, font: UIFont.systemFont(ofSize: 15))
        
        descLabel = ToolsWays.createLabel(frame: CGRect.init(x: nameLabel.frame.origin.x, y: 34, width:
            320, height: 20), labelText: nil, textColor: UIColor.gray, font: UIFont.systemFont(ofSize: 13))
        
        self.addSubview(blackView)
        self.addSubview(nameLabel)
        self.addSubview(descLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
