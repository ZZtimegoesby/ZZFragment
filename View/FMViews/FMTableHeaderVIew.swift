//
//  FMTableHeaderVIew.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/22.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class FMTableHeaderVIew: UIView, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var sliderController: SliderGalleryController!
    var dataArray: [FMHotListModel] = []
    var collectionView: UICollectionView?
    
    init(frame: CGRect, viewContorller: FMViewController) {
        super.init(frame: frame)
        
        sliderController = SliderGalleryController()
        
        for model in viewContorller.sliderArray{
            
            sliderController.dataSource.append(model.img!)
        }
        
        sliderController.placeholderImage = #imageLiteral(resourceName: "groupDefaultBanner")
        sliderController.size = CGSize(width: frame.width, height: frame.width * 267 / 570)
        sliderController.PageControlFrame = CGRect.init(x: frame.width - 120, y: (sliderController.size.height) - 25, width: 120, height: 20)
        
        sliderController.view.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.width * 267 / 570)
        
        viewContorller.addChildViewController(sliderController)
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize.init(width: (frame.width - 40) / 3, height: (frame.width - 40) / 3 + 40)
        layout.sectionInset = UIEdgeInsets.init(top: 7, left: 10, bottom: 0, right: 10)
        
        collectionView = UICollectionView(frame: CGRect.init(x: 0, y: sliderController.view.frame.height, width: frame.width, height: 175), collectionViewLayout: layout)
        
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.isScrollEnabled = false
        
        collectionView?.register(UINib.init(nibName: "FMHotListCell", bundle: nil), forCellWithReuseIdentifier: "FMHotListCell")
        
        collectionView?.backgroundColor = UIColor.white
        
        self.addSubview(collectionView!)
        self.addSubview(sliderController.view)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FMHotListCell", for: indexPath) as! FMHotListCell
        
        cell.model = dataArray[indexPath.item]
        
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
