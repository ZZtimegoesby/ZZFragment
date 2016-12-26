//
//  GroupShowViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/29.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire

class GroupShowViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    
    var sort: String!
    var dataArray: [GroupModel] = []
    
    var limit = 10
    var start = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backImage = ToolsWays.createImageView(frame: CGRect.init(x: 0, y: 20, width: width, height: height), image: #imageLiteral(resourceName: "groupblackimage"))
        
        self.view.addSubview(backImage)
        
        createTableView()
        createRefresh()
    }
    
    func createTableView() -> Void {
        
        tableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .group, delegate: self, dataSource: self, color: UIColor.clear, contentInset: UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0), cellReuseIdentifier: "GroupViewCell")
        
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.tag = 30
        
        self.view.addSubview(tableView)
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
        
        Alamofire.request(Net_GroupList, method: .post, parameters: ["limit" : limit, "start" : start, "sort" : sort], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                
                for temp in dic["list"] as! [[String : AnyObject]] {
                    
                    let model = try! GroupModel(dictionary: temp)
                    model.modeltype = "GroupModel"
                    
                    for latestpost in temp["latestposts"] as! [[String : AnyObject]] {
                        
                        let lates = try! latestposts(dictionary: latestpost)
                        model.latestModel.append(lates)
                    }
                    
                    self.dataArray.append(model)
                }
                
                self.tableView.reloadData()
            }
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            self.hideHUB()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupViewCell") as! GroupViewCell
        
        cell.model = dataArray[indexPath.section]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 143
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("GroupSectionHeaderView", owner: nil, options: nil)!.first as? GroupSectionHeaderView
        
        view?.model = dataArray[section]
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("GroupSectionFooterView", owner: nil, options: nil)?.first as? GroupSectionFooterView
        
        view?.model = dataArray[section]
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        let model = dataArray[section]
        
        let height = ("小组签名：\r" + model.desc!).boundingRect(with: CGSize.init(width: width - 20, height: 10000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 14)], context: nil).height
        
        return height + 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        (cell as! GroupViewCell).GpCellCollectionView.reloadData()
        (cell as! GroupViewCell).GpCellCollectionView.contentOffset.x = 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 70
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
