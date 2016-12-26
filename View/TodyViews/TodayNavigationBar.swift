//
//  TodayNavigationBar.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class TodayNavigationBar: UIView {

    var actionView: UIView!
    var buttonArray: [UIButton] = []
    var todayButton: UIButton!
    var fragmentButton: UIButton!
    
    init(frame: CGRect, firstImage: UIImage, firstSelectImage: UIImage, secondImage: UIImage, secondSelectImage: UIImage) {
        super.init(frame: frame)
        
        todayButton = ToolsWays.createButton(frame: CGRect.init(x: 18, y: 2, width: 32, height: 30), title: nil, titleColor: nil, image: firstImage, selectImage: firstSelectImage)
        
        todayButton.tag = 10
        todayButton.isSelected = true
        
        fragmentButton = ToolsWays.createButton(frame: CGRect.init(x: 75, y: 2, width: 32, height: 30), title: nil, titleColor: nil, image: secondImage, selectImage: secondSelectImage)
        
        fragmentButton.tag = 11
        
        self.backgroundColor = UIColor.white
        
        actionView = ToolsWays.createView(frame: CGRect.init(x: todayButton.center.x - 4, y: 39, width: 8, height: 2), backgroundCollor: UIColor.black)
        
        buttonArray.append(todayButton)
        buttonArray.append(fragmentButton)
        
        self.addSubview(actionView)
        self.addSubview(todayButton)
        self.addSubview(fragmentButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
