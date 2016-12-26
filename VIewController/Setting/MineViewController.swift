//
//  MineViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/4.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class MineViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var headerView: TableViewCell!
    var tableView: UITableView!
    var nightView: UIView!
    
    lazy var dataArray = {
        
        return [["收藏的美文", "喜欢的音乐", "下载"], ["夜间模式", "清理缓存"], ["退出登录"]]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        createTableView()
        changeNav(image: #imageLiteral(resourceName: "返回"))
        
        nightView = UIView(frame: UIScreen.main.bounds)
        
        self.view.addSubview(navBar)
    }
    
    override func changeNav(image: UIImage?) {
        super.changeNav(image: image)
        
        leftLabel.text = "我的"
        leftLabel.textColor = UIColor.white
        navBar.backgroundColor = UIColor.clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    func createTableView() -> Void {
        
        tableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .group, delegate: self, dataSource: self, color: UIColor.white, contentInset: UIEdgeInsets.init(top: height / 2 - 150, left: 0, bottom: 0, right: 0), cellReuseIdentifier: nil)
        
        headerView = Bundle.main.loadNibNamed("TableViewCell", owner: self, options: nil)?.first as! TableViewCell
        
        headerView.frame = CGRect.init(x: 0, y: -height / 2, width: width, height: height / 2)
        
        tableView.addSubview(headerView)
        self.view.addSubview(tableView)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "setCell")
        
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "setCell")
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            
            let nightSwitch = UISwitch(frame: CGRect.init(x: width - 65, y: 8, width: 0, height: 0))
            
            nightSwitch.addTarget(self, action: #selector(self.nightSwitchAction(sw:)), for: .valueChanged)
            
            cell?.addSubview(nightSwitch)
            
        } else {
            
            cell?.accessoryType = .disclosureIndicator
        }
        
        cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        
        return cell!
    }
    
    func nightSwitchAction(sw: UISwitch) -> Void {
        
        if sw.isOn {
            
            nightView.backgroundColor = UIColor.init(white: 0, alpha: 0.4)
            
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            
            appdelegate.window?.addSubview(nightView)
            
            nightView.isUserInteractionEnabled = false
            
        } else {
            
            nightView.removeFromSuperview()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var VC: BaseViewController?
        
        switch indexPath {
            
        case indexPath where indexPath.section == 0 && indexPath.row == 0:
            VC = ArticleCollectViewController()
        case indexPath where indexPath.section == 0 && indexPath.row == 1:
            VC = MusicCollectViewController()
        case indexPath where indexPath.section == 1 && indexPath.row == 1:
            VC = SettingViewController()
        case indexPath where indexPath.section == 1 && indexPath.row == 2:
            break
        default :
            break
        }
        
        if VC != nil {
            
            self.navigationController?.pushViewController(VC!, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y < -height / 2 + 150 && headerView != nil{
            
            let xOffSet = scrollView.contentOffset.y + height / 2 - 150
            
            var frame = headerView.frame
            
            frame.size.width = fabs(xOffSet/2) + width
            frame.origin.x = xOffSet / 4
            
            headerView.frame = frame
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
