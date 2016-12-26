//
//  SingleVCs.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/4.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import AVFoundation

class SingleVCs: NSObject {

    static let mainVC = MainViewController()
    static let FMVC = FMViewController()
    static let readVC = ReadViewController()
    static let commVC = CommunityViewController()
    static let tagVC = TagsViewController()
    static var player = AVPlayer()
    
    private override init() {
    }
}
