//
//  GroupViewCell.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/31.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class GroupViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var GpCellCollectionView: UICollectionView!
    
    var model: GroupModel? {
        
        didSet{
            
            icon.af_setImage(withURL: URL.init(string: (model?.userinfo?.icon)!)!)
            name.text = (model?.userinfo?.uname)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        GpCellCollectionView.delegate = self
        GpCellCollectionView.dataSource = self
        GpCellCollectionView.register(UINib.init(nibName: "GroupCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GroupCollectionViewCell")
        GpCellCollectionView.register(UINib.init(nibName: "GroupCollectionViewCell2", bundle: nil), forCellWithReuseIdentifier: "GroupCollectionViewCell2")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return (model?.latestModel.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tempModel = (self.model?.latestModel[indexPath.item])!
        
        if tempModel.coverimg! != "" {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectionViewCell", for: indexPath) as! GroupCollectionViewCell
            
            cell.model = tempModel
            
            return cell
            
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCollectionViewCell2", for: indexPath) as! GroupCollectionViewCell2
            
            cell.model = tempModel
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
