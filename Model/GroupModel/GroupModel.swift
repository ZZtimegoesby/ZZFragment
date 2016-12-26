//
//  GroupModel.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/31.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class GroupModel: BaseModel {

    var coverimg: String?
    var desc: String?
    var tags: NSArray?
    var groupid: String?
    var membernum: NSNumber?
    var lastupdate_f: String?
    
    lazy var latestModel: [latestposts] = []
}
