//
//  TodayTableView.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class TodayTableView: UITableView {

    var sliderController: SliderGalleryController?
    
    override init(frame: CGRect, style: UITableViewStyle) {
       super.init(frame: frame, style: style)
        
        self.showsVerticalScrollIndicator = false
        
        self.register(UINib.init(nibName: "TodayCell", bundle: nil), forCellReuseIdentifier: "TodayCell")
        self.register(UINib.init(nibName: "TodayMusicCell", bundle: nil), forCellReuseIdentifier: "TodayMusicCell")
        self.register(UINib.init(nibName: "TodayOtherCell", bundle: nil), forCellReuseIdentifier: "TodayOtherCell")
        self.register(UINib.init(nibName: "FragmentCell", bundle: nil), forCellReuseIdentifier: "FragmentCell")
        self.register(UINib.init(nibName: "FragPictrueCell", bundle: nil), forCellReuseIdentifier: "FragPictrueCell")
    }
    
    let width = UIScreen.main.bounds.width
    
    func createTabelViewHeaderView(VC: BaseViewController, arr: [MainSliderModel]) -> Void{
        
        sliderController = SliderGalleryController()
        
        for model in arr {
            
            sliderController?.dataSource.append(model.img!)
        }
        
        sliderController?.placeholderImage = #imageLiteral(resourceName: "groupDefaultBanner")
        sliderController?.size = CGSize(width: width, height: width * 267 / 570)
        sliderController?.PageControlFrame = CGRect.init(x: width-120, y: (sliderController?.size.height)! - 25, width: 120, height: 20)
        
        sliderController?.view.frame = CGRect.init(x: 0, y: 0, width: width, height: width * 267 / 570)
        
        VC.addChildViewController(sliderController!)
        
        self.tableHeaderView = sliderController?.view
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
