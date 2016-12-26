//
//  PlayerAlartView.swift
//  ZZFragment
//
//  Created by qianfeng on 16/12/5.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class PlayerAlartView: UILabel {

    init(superView: UIView) {
        var frame = CGRect()
        
        frame.size = CGSize(width: 100, height: 35)
        frame.origin.x = superView.center.x - 50
        frame.origin.y = superView.center.y - 70
        
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        self.textColor = UIColor.white
        self.textAlignment = .center
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.isHidden = true
        self.font = UIFont.systemFont(ofSize: 14)
    }
    
    func show(text: String) -> Void {
        
        self.text = text
        self.isHidden = false
        
        // 解决按钮连续点击时，多次响应问题(只在最后一次点击时执行)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.viewHidden), object: nil)
        
        self.perform(#selector(self.viewHidden), with: nil, afterDelay: 1.5)
    }
    
    func viewHidden() -> Void {
        self.isHidden = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
