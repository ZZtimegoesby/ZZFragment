//
//  ReadCollectionView.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class ReadCollectionView: UICollectionView {

    let width = UIScreen.main.bounds.width
    var sliderController: SliderGalleryController!
    
    init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, VC: ReadViewController) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.dataSource = VC
        self.delegate = VC
        
        self.backgroundColor = UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1)
        self.showsVerticalScrollIndicator = false
        
        self.register(UINib.init(nibName: "ReadlistCell", bundle: nil), forCellWithReuseIdentifier: "ReadlistCell")
        self.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "readHeader")
        self.register(UINib.init(nibName: "ReadFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ReadFooterView")
        self.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        
        VC.view.addSubview(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createSliderView(vc: ReadViewController, view: UIView) -> Void {
        
        sliderController = SliderGalleryController()
        
        for model in vc.picArray {
            
            sliderController.dataSource.append(model.img!)
        }
        
        sliderController.placeholderImage = #imageLiteral(resourceName: "groupDefaultBanner")
        sliderController.size = CGSize(width: width, height: width * 241 / 516 + 20)
        sliderController.PageControlFrame = CGRect.init(x: width-80, y: sliderController.size.height - 25, width: 80, height: 20)
        
        sliderController.view.frame = CGRect.init(x: 0, y: 0, width: width, height: width * 241 / 516 + 20)
        
        vc.addChildViewController(sliderController)
        view.addSubview(sliderController.view)
    }

}
