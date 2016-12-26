//
//  ArticleModel.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/8.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import CoreData

class ArticleModel: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ArticleModel> {
        return NSFetchRequest<ArticleModel>(entityName: "ArticleModel");
    }
    
    @NSManaged public var content: String?
    @NSManaged public var coverimg: Data?
    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var userinfo: Userinfo?
    
    @NSManaged public var userName: String?
    @NSManaged public var type: String?
}
