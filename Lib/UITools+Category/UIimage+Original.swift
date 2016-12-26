//
//  UIimage+Original.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

extension UIImage {
    
    func original() -> UIImage {
        
        return self.withRenderingMode(.alwaysOriginal)
    }
    
}
