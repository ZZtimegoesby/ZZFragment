//
//  MusicModel.swift
//  ZZFragment
//
//  Created by qianfeng on 16/12/7.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import CoreData

class MusicModel: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MusicModel> {
        return NSFetchRequest<MusicModel>(entityName: "MusicModel");
    }
    
    @NSManaged public var singer: String?
    @NSManaged public var img: Data?
    @NSManaged public var musicID: String?
    @NSManaged public var playinfo: Playinfo?
    @NSManaged public var musicUrl: String?

    @NSManaged public var userName: String?
}
