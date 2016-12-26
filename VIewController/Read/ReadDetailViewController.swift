//
//  ReadDetailViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire

class ReadDetailViewController: BaseViewController, UIScrollViewDelegate {
    
    var VCArray: [UIViewController] = []
    var scrollView: UIScrollView?
    var navView: TodayNavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createScrollView()
        
        titleLabel.text = VCArray[0].title
        
        changeNav(image: #imageLiteral(resourceName: "navbarBack"))
        
        self.view.addSubview(navBar)
    }
    
    func createScrollView() -> Void {
        
        scrollView = UIScrollView(frame: CGRect.init(x: 0, y: 0, width: width, height: height))
        
        scrollView?.contentSize = CGSize(width: width * 2, height: height)
        scrollView?.isPagingEnabled = true
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.bounces = false
        scrollView?.delegate = self
        
        var i: CGFloat = 0
        for vc in VCArray {
            
            vc.view.frame = CGRect.init(x: width * i, y: 0, width: width, height: height)
            
            self.addChildViewController(vc)
            
            scrollView?.addSubview(vc.view)
            
            i += 1
        }
        
        self.view.addSubview(scrollView!)
    }
    
    override func changeNav(image: UIImage?) {
        super.changeNav(image: image)
        
        navView = TodayNavigationBar(frame: CGRect.init(x: width - 115, y: 20, width: 115, height: 40), firstImage: #imageLiteral(resourceName: "readNew"), firstSelectImage: #imageLiteral(resourceName: "readNewSelected"), secondImage: #imageLiteral(resourceName: "readHot"), secondSelectImage: #imageLiteral(resourceName: "readHotSelected"))
        
        navView.todayButton.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
        navView.fragmentButton.addTarget(self, action: #selector(self.buttonClick(button:)), for: .touchUpInside)
        
        navBar.addSubview(navView)
    }
    
    func buttonClick(button: UIButton) -> Void {
        
        animationForNavButton(button: button)
        
        scrollView?.setContentOffset(CGPoint.init(x: CGFloat(button.tag - 10) * width, y: 0), animated: true)
    }
    
    func animationForNavButton(button: UIButton) -> Void {
        
        for btn in navView.buttonArray {
            
            btn.isSelected = false
        }
        button.isSelected = true
        
        titleLabel.text = VCArray[button.tag - 10].title
        
        UIView.animate(withDuration: 0.5, animations: {
            
            self.navView.actionView.frame = CGRect(x: self.navView.actionView.frame.origin.x, y: 39, width: button.center.x - self.navView.actionView.center.x + 8, height: 2)
        }) { (true) in
            
            UIView.animate(withDuration: 0.12, animations: {
                
                self.navView.actionView.frame.origin.x = button.center.x - 4
                self.navView.actionView.frame.size = CGSize(width: 8, height: 2)
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / width
        let button = navView.buttonArray[Int(index)]
        
        animationForNavButton(button: button)
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
