//
//  TagsShowController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/20.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class TagsShowController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var model: tagsModel?
    var tableView: TodayTableView?
    
    var start = 0
    var dataArray: [FragmentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = self.title
                
        createTableView()
        
        createRefresh()
        
        changeNav(image: #imageLiteral(resourceName: "navbarBack"))
        
        self.view.addSubview(navBar)
    }
    
    func createTableView() -> Void {
        
        tableView = TodayTableView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .plain)
        
        tableView?.separatorStyle = .none
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.contentInset = UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(tableView!)
    }
    
    func createRefresh() {
        
        createMJRefresh(scrollView: tableView!, mj_header: { 
            
            self.start = 0
            self.dataArray.removeAll()
            
            self.loadData()
            
            }) {
                
                self.start += 10
                self.loadData()
        }
    }
    
    func loadData() {
        
        showHUB(str: "加载中..")
        
        Alamofire.request(Net_TimelineList, method: .post, parameters: ["limit":10, "start": start, "tag" : (model?.tag)!], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                    
                for temp in dic["list"] as! [[String:AnyObject]] {
                    
                    let fragmentModel = try! FragmentModel(dictionary: temp)
                    
                    if fragmentModel.content != "" {
                        
                        fragmentModel.labelHeight = (fragmentModel.content! as NSString).boundingRect(with: CGSize.init(width: self.width - 60, height: 10000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil).height
                    } else {
                        
                        fragmentModel.labelHeight = 0
                    }
                    
                    //处理图片高度
                    if fragmentModel.coverimg_wh != "" {
                        
                        let arr = fragmentModel.coverimg_wh?.components(separatedBy: "*")
                        
                        let width = (arr![0] as NSString).integerValue
                        
                        let height = (arr![1] as NSString).integerValue
                        
                        if arr?.count == 2 {
                            
                            let imageHeight = (self.width - 20) * CGFloat(height) / CGFloat(width)
                            
                            fragmentModel.imgHeight = imageHeight
                        }
                    } else {
                        fragmentModel.imgHeight = 0
                    }
                    
                    self.dataArray.append(fragmentModel)
                }
                
                self.tableView?.reloadData()
            }
            self.tableView?.mj_footer.endRefreshing()
            self.tableView?.mj_header.endRefreshing()
            self.hideHUB()
            self.tableView?.separatorStyle = .singleLine
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = dataArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "FragPictrueCell") as! FragPictrueCell
            
            cell.model = model
            
            cell.selectionStyle = .none
            
            return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = dataArray[indexPath.row]
            
        return 85 + model.labelHeight! + model.imgHeight!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        let model = dataArray[indexPath.row]
        
        let detailVC = FramentDetailViewController()
        
        detailVC.model = model
        
        self.navigationController?.pushViewController(detailVC, animated: true)
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
