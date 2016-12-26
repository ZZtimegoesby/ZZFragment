//
//  GuidePageView.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/22.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class GuidePageView: UIScrollView {

    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    init(frame: CGRect, imageArr: [UIImage]) {
        super.init(frame: frame)
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.isPagingEnabled = true
        self.bounces = false
        self.contentSize = CGSize(width: CGFloat(imageArr.count) * width, height: height)
        
        var i: CGFloat = 0
        
        for img in imageArr {
            
            let imageView = ToolsWays.createImageView(frame: CGRect.init(x: i * width, y: 0, width: width, height: height), image: img)
            
            imageView.isUserInteractionEnabled = true
            
            self.addSubview(imageView)
            
            if i == CGFloat(imageArr.count-1) {
                
                let button = ToolsWays.createButton(frame: CGRect.init(x: width/2 - 50, y: height - 100, width: 100, height: 30), title: "立即进入", titleColor: UIColor.blue, image: nil, selectImage: nil)
                
                button.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
                imageView.addSubview(button)
            }
            
            i += 1
        }
        
    }
    
    func btnClick() -> Void {
        
        UIView.animate(withDuration: 2.2, animations: {
            
            self.frame.origin.x = -self.width
            self.alpha = 0.5
        }) { (true) in
            
            self.removeFromSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
