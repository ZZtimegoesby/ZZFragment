//
//  ReadNewViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/25.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class ReadNewViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView?
    
    var type: NSNumber!
    var sort: String!
    var dataArray: [ReadDetailModel] = []
    
    var limit = 10
    var start = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createTabelView()
        createRefresh()
    }
    
    func createTabelView() -> Void {
        
        tableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .plain, delegate: self, dataSource: self, color: UIColor.white, contentInset: UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0), cellReuseIdentifier: "ReadDetailCell")
        tableView?.separatorStyle = .none
        tableView?.tag = 20
        
        self.view.addSubview(tableView!)
    }
    
    func createRefresh() {
        
        createMJRefresh(scrollView: tableView!, mj_header: {
            
            self.start = 0
            self.dataArray.removeAll()
            self.loadData()
            
        }) {
            
            self.start += self.limit
            self.loadData()
        }
        tableView?.mj_header.beginRefreshing()
    }
    
    //MARK:  ---------- Alamofire请求数据 ---------
    func loadData() {
        
        showHUB(str: "请稍候..")
        
        Alamofire.request(Net_ReadDetail, method: .post, parameters: ["limit" : limit, "start" : start, "sort" : sort, "typeid" : type], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                
                for temp in dic["list"] as! [[String : AnyObject]] {
                    
                    let readDetailModel = try! ReadDetailModel(dictionary: temp)
                    readDetailModel.modeltype = "ReadDetailModel"
                    self.dataArray.append(readDetailModel)
                }
                
                self.tableView?.reloadData()
            }
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            self.hideHUB()
            self.tableView?.separatorStyle = .singleLine
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadDetailCell") as! ReadDetailCell
        
        cell.model = dataArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArray[indexPath.row]
        
        let detailVC = TodayDetailsViewController()
        
        detailVC.contentid = model.id
        detailVC.baseModel = model
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row % 3 == 0 {
            
            HJWAnimationCell.setAnimationCell(cell, forRowAt: indexPath, type: .left)
        } else if indexPath.row % 3 == 1 {
            
            HJWAnimationCell.setAnimationCell(cell, forRowAt: indexPath, type: .right)
        } else {
            
            HJWAnimationCell.setAnimationCell(cell, forRowAt: indexPath, type: .horizontal)
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
