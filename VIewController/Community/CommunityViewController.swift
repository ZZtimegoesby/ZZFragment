//
//  CommunityViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class CommunityViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var navView: TodayNavigationBar!
    var collectionView: UICollectionView!
    
    lazy var topicVC: TopicViewController = TopicViewController()
    
    lazy var groupVC: GroupViewController = GroupViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        changeNav(image: nil)
        
        leftLabel.text = "社区"
        
        self.view.addSubview(navBar)
    }
    
    override func changeNav(image: UIImage?) {
        
        navView = TodayNavigationBar(frame: CGRect.init(x: width - 115, y: 20, width: 115, height: 40), firstImage: #imageLiteral(resourceName: "groupPost"), firstSelectImage: #imageLiteral(resourceName: "groupPostSelected"), secondImage: #imageLiteral(resourceName: "groupNarBar"), secondSelectImage: #imageLiteral(resourceName: "groupNavBarSelected"))
        
        navView.todayButton.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
        navView.fragmentButton.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
        
        navBar.addSubview(navView)
    }
    
    func buttonClick(button: UIButton) -> Void {
        
        for btn in navView.buttonArray {
            
            btn.isSelected = false
        }
        button.isSelected = true
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.navView.actionView.frame = CGRect(x: self.navView.actionView.frame.origin.x, y: 39, width: button.center.x - self.navView.actionView.center.x + 8, height: 2)
        }) { (true) in
            
            UIView.animate(withDuration: 0.12, animations: {
                
                self.navView.actionView.frame.origin.x = button.center.x - 4
                self.navView.actionView.frame.size = CGSize(width: 8, height: 2)
            })
        }
        
        let index = IndexPath(item: button.tag - 10, section: 0)
        
        collectionView.scrollToItem(at: index, at: .left, animated: true)
    }
    
    func createCollectionView() -> Void {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize.init(width: width, height: height)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = ToolsWays.createCollectionView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), layout: layout, delegate: self, dataSource: self, color: UIColor.white, cellWithReuseIdentifier: nil)
        
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "commCell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "commCell", for: indexPath)
        
        if indexPath.item == 0 {
            
            cell.contentView.addSubview(topicVC.view)
            self.addChildViewController(topicVC)
        } else {
            
            cell.contentView.addSubview(groupVC.view)
            self.addChildViewController(groupVC)
        }
        
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = collectionView.contentOffset.x / width
        let button = navView.buttonArray[Int(index)]
        
        for btn in navView.buttonArray {
            
            btn.isSelected = false
        }
        button.isSelected = true
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.navView.actionView.frame = CGRect(x: self.navView.actionView.frame.origin.x, y: 39, width: button.center.x - self.navView.actionView.center.x + 8, height: 2)
        }) { (true) in
            
            UIView.animate(withDuration: 0.12, animations: {
                
                self.navView.actionView.frame.origin.x = button.center.x - 4
                self.navView.actionView.frame.size = CGSize(width: 8, height: 2)
            })
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        UIView.animate(withDuration: 0.05, animations: {
            
            self.navBar.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64)
        })
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
