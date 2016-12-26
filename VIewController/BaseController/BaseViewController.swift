//
//  BaseViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import MMDrawerController
import MJRefresh
import MBProgressHUD

class BaseViewController: UIViewController {

    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var navBar: UIView!
    var leftBtn: UIButton!
    var leftLabel: UILabel!
    var titleLabel: UILabel!
    var hub: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        createHUB()
        createNav()
    }
    
    func createHUB() -> Void {
        
        hub = MBProgressHUD.init(view: self.view)
        self.view.addSubview(hub)
    }
    
    func showTextHUB(str: String) -> Void {
        
        hub.show(animated: true)
        hub.mode = .customView
        hub.bezelView.isHidden = false
        hub.customView = UIImageView(image: #imageLiteral(resourceName: "对号"))
        hub.label.text = str
        self.view.bringSubview(toFront: hub)
        hub.hide(animated: true, afterDelay: 0.7)
    }
    
    func showHUB(str: String) -> Void {
        
        hub.label.text = str
        hub.show(animated: true)
        self.view.bringSubview(toFront: self.hub)
    }
    
    func hideHUB() -> Void {
        
        hub.hide(animated: true)
    }
    
    func createNav() -> Void {
        
        navBar = ToolsWays.createView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 64), backgroundCollor: UIColor.white)
        
        leftBtn = ToolsWays.createButton(frame: CGRect.init(x: 15, y: 25, width: 35, height: 35), title: nil, titleColor: nil, image: #imageLiteral(resourceName: "sliderMenuSelected"), selectImage: nil)
        leftBtn.addTarget(self, action: #selector(self.showMenu(button:)), for: .touchUpInside)
        
        leftLabel = ToolsWays.createLabel(frame: CGRect.init(x: 58, y: leftBtn.center.y - 10, width: 60, height: 20), labelText: nil, textColor: UIColor.black, font: UIFont.systemFont(ofSize: 13))
        
        titleLabel = UILabel(frame: CGRect.init(x: width/2 - 100, y: 25, width: 200, height: 35))
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        
        navBar.addSubview(titleLabel)
        navBar.addSubview(leftBtn)
        navBar.addSubview(leftLabel)
    }
    
    func showMenu(button: UIButton) -> Void {
        
        if button.backgroundImage(for: .normal) == #imageLiteral(resourceName: "sliderMenuSelected") || button.backgroundImage(for: .normal) == #imageLiteral(resourceName: "返回"){
            
            let app = UIApplication.shared.delegate as! AppDelegate
            
            app.drawerVC?.toggle(MMDrawerSide.left, animated: true, completion: nil)
        } else {
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    func changeNav(image: UIImage?) ->Void {
        
        leftBtn.setBackgroundImage(image, for: .normal)
        leftBtn.setBackgroundImage(image, for: .highlighted)
    }
    
    //MARK: 父类上拉刷新下拉加载
    func createMJRefresh(scrollView: UIScrollView, mj_header headerRefresh: @escaping ()->Void, mj_footer footerRefresh: @escaping ()->Void) {
        
        let header = MJRefreshGifHeader {
            
            headerRefresh()
        }
        
        header?.setTitle("下拉可以刷新", for: .idle)
        header?.setTitle("松开立即刷新", for: .pulling)
        header?.setTitle("正在刷新。。。", for: .refreshing)
        header?.setTitle("刷新结束", for: .noMoreData)
        
        scrollView.mj_header = header
        header?.beginRefreshing()
        
        let footer = MJRefreshBackGifFooter(refreshingBlock: {
            footerRefresh()
        })
        
        footer?.setTitle("上拉可以显示更多数据", for: .idle)
        footer?.setTitle("松开以加载更多数据", for: .pulling)
        footer?.setTitle("加载数据中。。。", for: .refreshing)
        footer?.setTitle("加载完成", for: .noMoreData)
        
        scrollView.mj_footer = footer
    }
    
    //MARK: 父类实现自定义导航栏随tableView滚动而滑动
    var lastOffSet: CGFloat = 0
    var tempOffSet: CGFloat = 0
    var lastWidthSet: CGFloat = 0
    var lastNavFrame: CGFloat = 0
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        lastOffSet = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.frame.height && scrollView.contentSize.height != 0 {
            
            scrollView.mj_footer.beginRefreshing()
        }
        
        switch scrollView.tag {
            
        case 10:
            self.didScrollAnmimatiom(scrollView: scrollView, lastOffSet: lastOffSet, view: SingleVCs.mainVC.navBar)
        case 20:
            self.didScrollAnmimatiom(scrollView: scrollView, lastOffSet: lastOffSet, view: SingleVCs.readVC.detailVC.navBar)
        case 30:
            self.didScrollAnmimatiom(scrollView: scrollView, lastOffSet: lastOffSet, view: SingleVCs.commVC.navBar)
        default:
            self.didScrollAnmimatiom(scrollView: scrollView, lastOffSet: lastOffSet, view: navBar)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        switch scrollView.tag {
            
        case 10:
            lastNavFrame = SingleVCs.mainVC.navBar.frame.origin.y
        case 20:
            lastNavFrame = SingleVCs.readVC.navBar.frame.origin.y
        case 30:
            lastNavFrame = SingleVCs.commVC.navBar.frame.origin.y
        default:
            lastNavFrame = navBar.frame.origin.y
        }
    }
    
    func didScrollAnmimatiom(scrollView: UIScrollView!, lastOffSet: CGFloat!, view: UIView!) -> Void {
        
        if scrollView.contentOffset.y < lastOffSet {
            
            UIView.animate(withDuration: 0.15, animations: {
                
                view.frame.origin.y = 0
            })
            
        } else {
            
            if scrollView.contentOffset.y > -scrollView.contentInset.top + 64 {
                
                if view.frame.origin.y <= 0 && view.frame.origin.y > -scrollView.contentInset.top {
                    
                    if lastNavFrame == -scrollView.contentInset.top {
                        
                        UIView.animate(withDuration: 0.8, animations: {
                            
                            view.frame.origin.y = -scrollView.contentInset.top
                        })
                        
                    } else {
                        
                        if scrollView.contentOffset.y < 64 {
                        
                            view.frame.origin.y = -scrollView.contentOffset.y
                        } else{
                            view.frame.origin.y = lastNavFrame - (scrollView.contentOffset.y - lastOffSet)
                        }
                    }
                    
                    if scrollView.contentInset.top + view.frame.origin.y <= 5.5 {
                        
                        UIView.animate(withDuration: 0.35, animations: {
                            
                            view.frame.origin.y = -scrollView.contentInset.top
                        })
                    }
                }
            }
        }
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
