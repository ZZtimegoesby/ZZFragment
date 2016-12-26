//
//  GroupViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/29.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    lazy var groupNewController = { () -> GroupShowViewController in
        
        let vc = GroupShowViewController()
        
        vc.sort = "addtime"
        
        return vc
    }()
    
    lazy var groupHotController = { () -> GroupShowViewController in
        
        let vc = GroupShowViewController()
        
        vc.sort = "hot"
        
        return vc
    }()
    
    var navView: TodayNavigationBar!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
    }
    
    func createCollectionView() -> Void {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        collectionView = ToolsWays.createCollectionView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), layout: layout, delegate: self, dataSource: self, color: UIColor.white, cellWithReuseIdentifier: nil)
        
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "VCcell")
        self.view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VCcell", for: indexPath)
        
        if indexPath.item == 0 {
            
            cell.contentView.addSubview(groupNewController.view)
            self.addChildViewController(groupNewController)
            
        } else {
            
            cell.contentView.addSubview(groupHotController.view)
            self.addChildViewController(groupHotController)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
