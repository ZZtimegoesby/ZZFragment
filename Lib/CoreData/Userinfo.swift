//
//  Userinfo.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/10.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import CoreData

class Userinfo: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Userinfo> {
        return NSFetchRequest<Userinfo>(entityName: "Userinfo");
    }
    
    @NSManaged public var uname: String?
    @NSManaged public var icon: Data?
    @NSManaged public var desc: String?
    @NSManaged public var articles: ArticleModel?
    @NSManaged public var playinfo: Playinfo?
}
