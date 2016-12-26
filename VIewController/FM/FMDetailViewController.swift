//
//  FMDetailViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/22.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import MJRefresh
import MagicalRecord

class FMDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var radioid: String = ""
    var tableView: UITableView?
    lazy var dataArray: [FMDetailModel] = []
    var headerView: FMDetailHeaderCell?
    lazy var musicList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = self.title

        createTabelView()
        
        changeNav(image: #imageLiteral(resourceName: "navbarBack"))
                
        createRefresh()
        
        self.view.addSubview(navBar)
    }
    
    func createTabelView () {
        
        tableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .plain, delegate: self, dataSource: self, color: UIColor.white, contentInset: UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0), cellReuseIdentifier: "FMDetailCell")

        tableView?.separatorStyle = .none
        headerView = Bundle.main.loadNibNamed("FMDetailHeaderCell", owner: nil, options: nil)!.first as? FMDetailHeaderCell
        
        tableView?.tableHeaderView = headerView
        
        self.view.addSubview(tableView!)
    }
    
    func createRefresh() {
        
        let header = MJRefreshGifHeader {
            
            self.loadData()
        }
        
        header?.setTitle("下拉可以刷新", for: .idle)
        header?.setTitle("松开立即刷新", for: .pulling)
        header?.setTitle("正在刷新。。。", for: .refreshing)
        header?.setTitle("刷新结束", for: .noMoreData)
        
        self.tableView?.mj_header = header
        header?.beginRefreshing()
    }
    
    func loadData() {
        
        showHUB(str: "请稍候。。")
        
        Alamofire.request(Net_RadioDetail, method: .post, parameters: ["radioid" : radioid], encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                
                for temp in dic["list"] as! [[String:AnyObject]] {
                    
                    let detailModel = try! FMDetailModel(dictionary: temp)
                    
                    detailModel.playInfo!.musicAlbum = self.title
                    
                    self.dataArray.append(detailModel)
                    self.musicList.append(detailModel.musicUrl!)
                }

                let headerModel = try! FMHeaderModel(dictionary: dic["radioInfo"] as! [String : AnyObject])
                
                self.headerView?.model = headerModel
                
                self.tableView?.reloadData()
            }
            
            self.tableView?.mj_header.endRefreshing()
            self.hideHUB()
            self.tableView?.separatorStyle = .singleLine
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FMDetailCell") as! FMDetailCell
        
        cell.listButton.addTarget(self, action: #selector(self.cellButtonClick(btn:)), for: .touchUpInside)
        cell.listButton.tag = indexPath.row
        cell.model = dataArray[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArray[indexPath.row]
        
        let playVC = PlayMusicController()
        
        playVC.model = model.playInfo!
        playVC.index = indexPath.row
        playVC.musicArr = dataArray
        
        self.navigationController?.pushViewController(playVC, animated: true)
    }
    
    func cellButtonClick(btn: UIButton) -> Void {
        
        let model = dataArray[btn.tag]
        
        let alart = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        if let context = MusicModel.mr_findFirst(byAttribute: "musicID", withValue: model.tingid!) {
            
            let like = UIAlertAction(title: "取消收藏", style: .default) { (action) in
                
                context.mr_deleteEntity()
                NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
                self.showTextHUB(str: "已取消收藏")
            }
            alart.addAction(like)
        } else {
            
            let like = UIAlertAction(title: "添加收藏", style: .default) { (action) in
                
                self.likeActionClick(model: model)
            }
            alart.addAction(like)
        }
        let fenxiang = UIAlertAction(title: "分享", style: .default) { (action) in
            
        }
        
        alart.addAction(cancel)
        alart.addAction(fenxiang)
        
        self.present(alart, animated: true, completion: nil)
    }
    
    func likeActionClick(model: FMDetailModel) -> Void {
        
        let musicModel = MusicModel.mr_createEntity()
        let userinfo = Userinfo.mr_createEntity()
        let playinfo = Playinfo.mr_createEntity()
        
        playinfo?.imgData = model.imageData!
        playinfo?.imgUrl = (model.playInfo?.imgUrl)!
        playinfo?.tingid = model.tingid!
        playinfo?.title = model.title!
        playinfo?.albumTitle = model.playInfo?.musicAlbum!
        playinfo?.musicModel = musicModel
        playinfo?.userinfo = userinfo
        
        userinfo?.playinfo = playinfo
        userinfo?.uname = (model.userinfo?.uname)!
        
        MagicalRecord.save({ (context) in
            
            
            if model.imageData == nil {
                
                Alamofire.request(model.coverimg!).responseData(completionHandler: { (data) in
                    
                    musicModel?.img = (data.result.value)!
                })
            } else {
                
                musicModel?.img = model.imageData
            }
            musicModel?.singer = (model.userinfo?.uname!)!
            musicModel?.musicUrl = model.musicUrl!
            musicModel?.musicID = (playinfo?.tingid)!
            musicModel?.playinfo = playinfo
            
            musicModel?.userName = "1"
            
            }, completion: { (success, error) in
                
                self.showTextHUB(str: "已添加至收藏")
        })

    }


    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        self.didScrollAnmimatiom(scrollView: scrollView, lastOffSet: lastOffSet, view: navBar)
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
