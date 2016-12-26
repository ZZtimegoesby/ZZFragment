//
//  TopicShowViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/28.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class TopicShowViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{

    var tableView: UITableView?
    
    var sort: String!
    var dataArray: [TopicModel] = []
    
    var limit = 10
    var start = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTabelView()
        createRefresh()
    }
    
    func createTabelView() -> Void {
        
        tableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .plain, delegate: self, dataSource: self, color: nil, contentInset: UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0), cellReuseIdentifier: "TopicViewCell")
        
        tableView?.separatorStyle = .none
        tableView?.tag = 30
        
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
    }
    
    //MARK:  ---------- Alamofire请求数据 ---------
    func loadData() {
        
        showHUB(str: "正在加载..")
        
        Alamofire.request(Net_PostsHotList, method: .post, parameters: ["limit" : limit, "start" : start, "sort" : sort], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                
                for temp in dic["list"] as! [[String : AnyObject]] {
                    
                    let model = try! TopicModel(dictionary: temp)
                    
                    if model.content! != "" {
                        
                        model.LabelHeight = (model.content! as NSString).boundingRect(with: CGSize.init(width: self.width - 32, height: 10000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil).height
                    } else {
                        
                        model.LabelHeight = 0
                    }
                    
                    if model.coverimg! != "" {
                        
                        model.imageHeight = 430
                    } else {
                        
                        model.imageHeight = 0
                    }
                    
                    model.modeltype = "TopicModel"
                    self.dataArray.append(model)
                }
                
                self.tableView?.reloadData()
            }
            self.tableView?.mj_header.endRefreshing()
            self.tableView?.mj_footer.endRefreshing()
            self.hideHUB()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TopicViewCell") as! TopicViewCell
        
        cell.model = dataArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = dataArray[indexPath.row]
        
        return model.LabelHeight + model.imageHeight + 165
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArray[indexPath.row]
        
        let detailVC = TodayDetailsViewController()
        
        detailVC.contentid = model.contentid!
        detailVC.baseModel = model
        
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
