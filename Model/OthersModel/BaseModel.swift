//
//  BaseModel.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/17.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import JSONModel

class BaseModel: JSONModel {
    
    var modeltype: String?
    var userinfo: userinfo?
    var imageData: Data?
    var title: String?
    
    override class func propertyIsOptional(_ propertyName: String!) -> Bool {
        
        return true
    }
}
