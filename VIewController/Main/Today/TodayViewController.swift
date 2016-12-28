//
//  TodayViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/5.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MJRefresh

class TodayViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: TodayTableView?
    
    //today数据源
    lazy var todayModelArray = NSMutableArray()
    lazy var picDataArray: [MainSliderModel] = []
    
    var limit = 10
    var start = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTableView()
                
        createRefresh()
    }
    
    func createTableView() -> Void {
        
        tableView = TodayTableView.init(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .grouped)
        tableView?.tag = 10
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.contentInset = UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0)
        tableView?.separatorStyle = .none
        
        self.view.addSubview(tableView!)
    }
    
    //MARK:  ----------- 上拉下拉刷新 ---------
    func createRefresh() {
        
        createMJRefresh(scrollView: tableView!, mj_header: {
            
            self.start = 0
            self.todayModelArray.removeAllObjects()
            self.picDataArray.removeAll()
            
            self.loadData()
            self.loadSliderImage()
        }) {
            self.start += self.limit
            self.loadData()
        }
    }
    
    //MARK:  ---------- Alamofire请求数据 ---------
    func loadData() {
        
        showHUB(str: "请稍等..")
        
        Alamofire.request(Net_Today, method: .post, parameters: ["limit":limit, "start": start], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                
                SingleVCs.mainVC.changeLeftLabelText(text: { () -> String! in
                    
                    return dic["date"] as! String
                })
                
                for temp in dic["list"] as! [[String:AnyObject]] {
                    
                    let todayModel = try! TodayModel(dictionary: temp)
                    
                    todayModel.modeltype = "TodayModel"
                    
                    self.todayModelArray.add(from: todayModel)
                }
                self.tableView?.reloadData()
            }
            self.tableView?.mj_footer.endRefreshing()
            self.tableView?.mj_header.endRefreshing()
            self.hideHUB()
        }
    }
    
    func loadSliderImage() -> Void {
        
        Alamofire.request(Net_Today, method: .post, parameters: ["limit":limit, "start": 0], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                
                for temp in dic["carousel"] as! [[String: AnyObject]] {
                    
                    let sliderMdoel = try! MainSliderModel(dictionary: temp)
                    
                    self.picDataArray.append(sliderMdoel)
                }
                DispatchQueue.main.async(execute: {
                    
                    self.tableView?.createTabelViewHeaderView(VC: self, arr: self.picDataArray)
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.showNewView))
                    self.tableView?.sliderController?.view.addGestureRecognizer(tap)
                })
            }
        }
    }
    
    //轮播图点击跳转手势方法
    func showNewView() -> Void {
        
        let index = tableView!.sliderController?.currentIndex
        
        let str = self.picDataArray[index!].url
        
        let arr = str!.components(separatedBy: "/")
        
        if (str?.contains("taobao"))! {
            
            let taobaoStr = str?.replacingOccurrences(of: "https:", with: "taobao:")
            
            //判断当前系统（练习）
            if #available(iOS 10, *) {
                
                //应用内跳转第三方app
                UIApplication.shared.open(URL.init(string: taobaoStr!)!, options: [UIApplicationOpenURLOptionUniversalLinksOnly : true], completionHandler: { (success) in
                    print(success)
                    if success == false {
                        
                        UIApplication.shared.open(URL.init(string: str!)!, options: [:], completionHandler: nil)
                    }
                })
                
            } else {
                
                if UIApplication.shared.canOpenURL(URL.init(string: taobaoStr!)!) {
                    
                    UIApplication.shared.openURL(URL.init(string: taobaoStr!)!)
                } else {
                    
                    UIApplication.shared.openURL(URL.init(string: str!)!)
                }
            }
            
        } else {
            
            let sliderVC = TodayDetailsViewController()
            
            sliderVC.contentid = arr[3]
            sliderVC.flag = 1
            
            self.navigationController?.pushViewController(sliderVC, animated: true)
        }
    }
    
    //MARK:    -------- tableView 协议方法 ------------
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return todayModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let model = todayModelArray[indexPath.section] as? TodayModel
            
            if model?.type == 2 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TodayMusicCell") as! TodayMusicCell
                
                cell.model = model
                cell.selectionStyle = .none
                
                return cell
                
            } else if model?.type == 5 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TodayOtherCell") as! TodayOtherCell
                
                cell.model = model
                cell.selectionStyle = .none
                
                return cell
            }
            else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "TodayCell") as! TodayCell
                
                cell.model = model
                cell.selectionStyle = .none
                
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let model = todayModelArray[indexPath.section] as! TodayModel
        
        if model.type == 5 {
            return (height - 70) / 2 - 105
        } else if model.type == 2  {
            return (height - 70) / 2 - 50
        }
        
        if model.content! == "" {
            return (height - 70) / 2 - 18
        }
        return (height - 70) / 2 + 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = todayModelArray[indexPath.section] as! TodayModel
        
        if model.type == 2 {
            
            let fmVC = PlayMusicController()
            
            fmVC.model = model.playInfo
            
            self.navigationController?.pushViewController(fmVC, animated: true)
            
        } else {
            
            let detailVC = TodayDetailsViewController()
            
            detailVC.contentid = model.id
            detailVC.baseModel = model
            detailVC.flag = 0
            detailVC.imgUrl = model.coverimg!
            
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = Bundle.main.loadNibNamed("TodayCellFooterView", owner: nil, options: nil)?.first as! TodayCellFooterView
        
        view.model = todayModelArray[section] as? TodayModel
        
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0))
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0
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
