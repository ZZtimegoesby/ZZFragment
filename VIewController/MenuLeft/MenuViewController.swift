//
//  MenuViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/4.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import MMDrawerController

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    lazy var dataArray:[String] = {
        
        return ["首页", "电台", "阅读", "社区", "标签", "我的"]
    }()
    
    lazy var imageArray: [UIImage] = {
        
        return [#imageLiteral(resourceName: "sliderHomeSelected"),#imageLiteral(resourceName: "sliderFMSelected"), #imageLiteral(resourceName: "sliderReadSelected"), #imageLiteral(resourceName: "sliderGroupSelected"), #imageLiteral(resourceName: "sliderShopSelected"), #imageLiteral(resourceName: "个人中心")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        
        if cell == nil {
            
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "reuseIdentifier")
            cell?.accessoryType = .disclosureIndicator
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.textColor = UIColor.white
        cell?.textLabel?.text = dataArray[indexPath.row]
        cell?.imageView?.image = imageArray[indexPath.row]
        cell?.backgroundColor = UIColor.clear
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var vc: UIViewController!
        
        switch indexPath.row {
        case 0:
            vc = SingleVCs.mainVC
        case 1:
            vc = SingleVCs.FMVC
        case 2:
            vc = SingleVCs.readVC
        case 3:
            vc = SingleVCs.commVC
        case 4:
            vc = SingleVCs.tagVC
        case 5:
            vc = MineViewController()
        default: break
        }
        
        let app = UIApplication.shared.delegate as! AppDelegate
        
        if vc.isKind(of: MineViewController.self) {
            
            app.drawerVC?.centerViewController = UINavigationController(rootViewController: vc)
            
        } else {
            
            app.drawerVC?.centerViewController = app.navViewLayoutConstraint(vc: vc)
        }
        
        vc.navigationController?.navigationBar.isHidden = true
        app.drawerVC?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        return .lightContent
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
