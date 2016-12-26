//
//  Playinfo.swift
//  ZZFragment
//
//  Created by qianfeng on 16/12/8.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import CoreData

class Playinfo: NSManagedObject {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Playinfo> {
        return NSFetchRequest<Playinfo>(entityName: "Playinfo");
    }
    
    @NSManaged public var albumTitle: String?
    @NSManaged public var imgUrl: String?
    @NSManaged public var tingid: String?
    @NSManaged public var title: String?
    @NSManaged public var imgData: Data?
    @NSManaged public var userinfo: Userinfo?
    @NSManaged public var musicModel: MusicModel?
}
