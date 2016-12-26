//
//  FMViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh

class FMViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var hotListArray: [FMHotListModel] = []
    var alllistArray: [FMHotListModel] = []
    var sliderArray: [MainSliderModel] = []
    
    var header: FMTableHeaderVIew!
    var tableView: UITableView!
    var limit = 10
    var start = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = "电台音乐"
        
        createTableView()
                
        createRefresh()
        
        self.view.addSubview(navBar)
    }
    
    func createTableView() {
        
        tableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .plain, delegate: self, dataSource: self, color: UIColor.white, contentInset: UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0), cellReuseIdentifier: "FMListCell")
        
        tableView.separatorStyle = .none
        
        self.view.addSubview(tableView)
    }
    
    func createRefresh() {
        
        createMJRefresh(scrollView: tableView, mj_header: {
            
            self.sliderArray.removeAll()
            self.hotListArray.removeAll()
            self.alllistArray.removeAll()
            self.start = 0
            self.upLoadData()
            
        }) {
            
            self.start += self.limit
            self.downLoadData()
        }
    }
    
    func upLoadData() -> Void {
        
        showHUB(str: "请稍候..")
        
        Alamofire.request(Net_Radio, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                    
                for temp in dic["hotlist"] as! [[String:AnyObject]] {
                    
                    let fmHotModel = try! FMHotListModel(dictionary: temp)
                    
                    self.hotListArray.append(fmHotModel)
                }
                
                for temp in dic["alllist"] as! [[String:AnyObject]] {
                    
                    let fmHotModel = try! FMHotListModel(dictionary: temp)
                    
                    self.alllistArray.append(fmHotModel)
                }
                
                for temp in dic["carousel"] as! [[String:AnyObject]] {
                    
                    let model = try! MainSliderModel(dictionary: temp)
                    
                    self.sliderArray.append(model)
                }
                
                DispatchQueue.main.async(execute: { 
                    
                    self.header = FMTableHeaderVIew.init(frame: CGRect.init(x: 0, y: 0, width: self.width, height: self.width * 267 / 570 + 175), viewContorller: self)
                    
                    self.header.dataArray = self.hotListArray
                    
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.showNewView))
                    
                    self.header.sliderController.view.addGestureRecognizer(tap)
                    
                    self.tableView.tableHeaderView = self.header
                })
                
                self.tableView?.reloadData()
            }
            self.tableView?.mj_header.endRefreshing()
            self.hideHUB()
            self.tableView.separatorStyle = .singleLine
        }
    }
    
    func showNewView() -> Void {
        
        let index = header.sliderController.currentIndex
        
        let str = self.sliderArray[index].url
        
        let arr = str!.components(separatedBy: "/")
        let detailVC = FMDetailViewController()
        
        detailVC.radioid = arr[3]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func downLoadData() -> Void {
        
        Alamofire.request(Net_RadioList, method: .post, parameters: ["limit": limit,"start": start], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                
                for temp in dic["list"] as! [[String:AnyObject]] {
                    
                    let fmHotModel = try! FMHotListModel(dictionary: temp)
                    
                    self.alllistArray.append(fmHotModel)
                }
                
                self.tableView?.reloadData()
                self.tableView?.mj_footer.endRefreshing()
            }
        }

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return alllistArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FMListCell") as! FMListCell
        
        cell.model = alllistArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 128
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = alllistArray[indexPath.row]
        
        let detailVC = FMDetailViewController()
        
        detailVC.radioid = model.radioid!
        detailVC.title = model.title
        
        self.navigationController?.pushViewController(detailVC, animated: true)
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
