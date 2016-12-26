//
//  FramentViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/19.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class FramentViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView: TodayTableView?
    
    //fragment数据源
    lazy var fragmentModelArray = NSMutableArray()
    
    var limit = 10
    var start = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
        
        createRefresh()
    }
    
    func createTableView() -> Void {
        
        tableView = TodayTableView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .plain)
        tableView?.tag = 10
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.contentInset = UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0)
        
        self.view.addSubview(tableView!)
    }
    
    //MARK:  ----------- 上拉下拉刷新 ---------
    func createRefresh() {
        
        createMJRefresh(scrollView: tableView!, mj_header: {
            
            self.start = 0
            self.fragmentModelArray.removeAllObjects()
            
            self.loadData()
            
        }) {
            
            self.start += self.limit
            self.loadData()
        }
    }
    
    //MARK:  ---------- Alamofire请求数据 ---------
    func loadData() {
        
        showHUB(str: "正在加载..")
        
        Alamofire.request(Net_TimelineList, method: .post, parameters: ["limit":limit, "start": start], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                    
                for temp in dic["list"] as! [[String:AnyObject]] {
                    
                    let fragmentModel = try! FragmentModel(dictionary: temp)
                    
                    if fragmentModel.content != "" {
                        
                        fragmentModel.labelHeight = (fragmentModel.content! as NSString).boundingRect(with: CGSize.init(width: self.width - 60, height: 10000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil).height
                        
                    } else {
                        
                        fragmentModel.labelHeight = 0
                    }
                    
                    //处理图片高度
                    if fragmentModel.coverimg_wh! != "" {
                        
                        let arr = fragmentModel.coverimg_wh?.components(separatedBy: "*")
                        
                        let width = (arr![0] as NSString).integerValue
                        
                        let height = (arr![1] as NSString).integerValue
                        
                        if arr?.count == 2 {
                            
                            let imageHeight = (self.width - 40) * CGFloat(height) / CGFloat(width)
                            
                            fragmentModel.imgHeight = imageHeight
                        }
                    } else {
                        
                        fragmentModel.imgHeight = 0
                    }
                    
                    self.fragmentModelArray.add(from: fragmentModel)
                }
                
                self.tableView?.reloadData()
            }
            self.tableView?.mj_footer.endRefreshing()
            self.tableView?.mj_header.endRefreshing()
            self.hideHUB()
        }
    }
    
    //MARK:    -------- tableView 协议方法 ------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fragmentModelArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let model = fragmentModelArray[indexPath.row] as! FragmentModel
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FragPictrueCell") as! FragPictrueCell
        
        cell.model = model
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = fragmentModelArray[indexPath.row] as! FragmentModel
        
        return 85 + model.labelHeight! + model.imgHeight!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = fragmentModelArray[indexPath.row] as! FragmentModel
        
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
