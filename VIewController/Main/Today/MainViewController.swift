//
//  MainViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/15.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class MainViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    var collectionView: UICollectionView!
    var navView: TodayNavigationBar!
    lazy var titleArr = {
        
        return ["", "碎片"]
    }()
    
    lazy var todayVC: TodayViewController = TodayViewController()
    lazy var framentVC: FramentViewController = FramentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        createNav()
        createCollectionView()
        
        self.view.addSubview(navBar)
    }
    
    func changeLeftLabelText(text: () -> String!) -> Void {
        
        leftLabel.text = text()
        titleArr[0] = text()
    }
    
    func createCollectionView() -> Void {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize.init(width: width, height: height)
        layout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = ToolsWays.createCollectionView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), layout: layout, delegate: self, dataSource: self, color: UIColor.white, cellWithReuseIdentifier: nil)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "todayCell")
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(collectionView)
    }
    
    override func createNav() {
        super.createNav()
        
        navView = TodayNavigationBar(frame: CGRect.init(x: width - 115, y: 20, width: 115, height: 40), firstImage: #imageLiteral(resourceName: "todaySegment"), firstSelectImage: #imageLiteral(resourceName: "todaySegmentSelected"), secondImage: #imageLiteral(resourceName: "fragmentSegment"), secondSelectImage: #imageLiteral(resourceName: "fragmentSegmentSelected"))
        
        navView.todayButton.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
        navView.fragmentButton.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
        
        navBar.addSubview(navView)
    }
    
//MARK: ---- 导航栏按钮点击方法 -------
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
        
        leftLabel.text = titleArr[button.tag - 10]
        
        let index = IndexPath(item: button.tag - 10, section: 0)
        
        collectionView.scrollToItem(at: index, at: .left, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath)
        
        if indexPath.item == 0 {
            
            cell.contentView.addSubview(todayVC.view)
            self.addChildViewController(todayVC)
        } else {
            
            cell.contentView.addSubview(framentVC.view)
            self.addChildViewController(framentVC)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.1) {
            
            self.navBar.frame.origin.y = 0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = collectionView.contentOffset.x / width
        let button = navView.buttonArray[Int(index)]
        
        for btn in navView.buttonArray {
            
            btn.isSelected = false
        }
        button.isSelected = true
        
        leftLabel.text = titleArr[button.tag - 10]
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.navView.actionView.frame = CGRect(x: self.navView.actionView.frame.origin.x, y: 39, width: button.center.x - self.navView.actionView.center.x + 8, height: 2)
            
        }) { (true) in
            
            UIView.animate(withDuration: 0.12, animations: {
                
                self.navView.actionView.frame.origin.x = button.center.x - 4
                self.navView.actionView.frame.size = CGSize(width: 8, height: 2)
            })
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
