//
//  CollectViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/4.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import MagicalRecord

enum CollectViewWithArticleOrMusic {
    
    case article
    case music
}

class CollectViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView: UITableView!
    lazy var articleArray: [ArticleModel] = []
    lazy var musicArray: [MusicModel] = []
    var deleteArray: NSMutableArray = NSMutableArray()
    var editView: UIView!
    var articleOrMusic: CollectViewWithArticleOrMusic!
    
//    lazy var nothingDataView = { () -> UIView in 
//        
//        let view = ToolsWays.createView(frame: CGRect.init(x: 0, y: 64, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64), backgroundCollor: UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1))
//        
//        let label = UILabel()
//        label.center = view.center
//        label.frame.size = CGSize(width: UIScreen.main.bounds.width, height: 40)
//        label.text = "还没有收藏的文章，快去收藏美文吧！"
//        label.backgroundColor = UIColor.white
//        label.textAlignment = .center
//        label.textColor = UIColor.darkGray
//        
//        view.addSubview(label)
//        
//        return view
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        changeNav(image: #imageLiteral(resourceName: "navbarBack"))
        
//        titleLabel.text = "我的收藏"
                        
        createEditView()
        
//        self.addObserver(self, forKeyPath: "dataArray", options: .new, context: nil)
        
        self.navigationController?.navigationBar.barStyle = .default
    }
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        
//        if keyPath == "dataArray" {
//            
//            if dataArray.count == 0 {
//                self.view.addSubview(nothingDataView)
//            } else {
//                nothingDataView.removeFromSuperview()
//            }
//        }
//    }
    
    func createEditView() -> Void {
        
        editView = UIView(frame: CGRect.init(x: 0, y: height + 50, width: width, height: 50))
        
        let leftButton = ToolsWays.createButton(frame: CGRect.init(x: 0, y: 0, width: width/2, height: 50), title: "删除", titleColor: UIColor.white, image: nil, selectImage: nil)
        leftButton.backgroundColor = UIColor.orange
        leftButton.addTarget(self, action: #selector(self.deleteSomeModel(btn:)), for: .touchUpInside)
        
        let rightButton = ToolsWays.createButton(frame: CGRect.init(x: width/2, y: 0, width: width/2, height: 50), title: "一键删除", titleColor: UIColor.white, image: nil, selectImage: nil)
        rightButton.backgroundColor = UIColor.lightGray
        rightButton.addTarget(self, action: #selector(self.deleteAllModel), for: .touchUpInside)
        
        editView.addSubview(leftButton)
        editView.addSubview(rightButton)
    }
    
    func deleteSomeModel(btn: UIButton) -> Void {
        
        if deleteArray.count > 0 {
            
            var arr: [IndexPath] = []
            
            if articleOrMusic == .article {
                
                for row in deleteArray {
                    
                    articleArray[row as! Int].mr_deleteEntity()
                    
                    articleArray.remove(at: row as! Int)
                    
                    let index = IndexPath(row: row as! Int, section: 0)
                    
                    arr.append(index)
                }
            } else {
                
                for row in deleteArray {
                    
                    musicArray[row as! Int].mr_deleteEntity()
                    
                    musicArray.remove(at: row as! Int)
                    
                    let index = IndexPath(row: row as! Int, section: 0)
                    
                    arr.append(index)
                }
            }
            
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            
            tableView.deleteRows(at: arr, with: .left)
            deleteArray.removeAllObjects()
        }
    }
    
    func deleteAllModel() -> Void {
        
        let alartVC = UIAlertController(title: "", message: "一定要删除所有收藏么。。", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "我再想想", style: .cancel, handler: nil)
        
        let certain = UIAlertAction(title: "我意已决", style: .default) { (action) in
            
            if self.articleOrMusic == .article {
                
                self.articleArray.removeAll()
                
                self.tableView.reloadData()
                
                ArticleModel.mr_truncateAll()
            } else {
                
                self.musicArray.removeAll()
                
                self.tableView.reloadData()
                
                MusicModel.mr_truncateAll()
            }
            
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        }
        
        alartVC.addAction(cancel)
        alartVC.addAction(certain)
        
        self.present(alartVC, animated: true, completion: nil)
    }
    
    override func changeNav(image: UIImage?) {
        super.changeNav(image: image)
        
        let editButton = ToolsWays.createButton(frame: CGRect.init(x: width-80, y: 25, width: 80, height: 35), title: "编辑", titleColor: UIColor.black, image: nil, selectImage: nil)
        
        editButton.addTarget(self, action: #selector(self.editAction(btn:)), for: .touchUpInside)
        
        navBar.addSubview(editButton)
    }
    
    func editAction(btn: UIButton) -> Void {
        
        tableView.isEditing = !tableView.isEditing
        
        if tableView.isEditing {
            
            self.deleteArray.removeAllObjects()
            
            self.view.addSubview(editView)
            
            btn.setTitle("完成", for: .normal)
            
            UIView.animate(withDuration: 0.1, animations: { 
                
                self.editView.frame.origin.y = self.height - 50
            })
            
        } else {
            btn.setTitle("编辑", for: .normal)
            
            UIView.animate(withDuration: 0.1, animations: { 
                
                self.editView.frame.origin.y = self.height + 50
            }, completion: { (true) in
                
                self.editView.removeFromSuperview()
            })
        }
    }
    
    func loadData() -> Void {
        
        if articleOrMusic == .article {
            
            if let arr = (ArticleModel.mr_find(byAttribute: "userName", withValue: "1") as? [ArticleModel]) {
                
                articleArray.removeAll()
                self.articleArray = arr
            }
            
        } else {
            
            if let arr = (MusicModel.mr_find(byAttribute: "userName", withValue: "1") as? [MusicModel]) {
                
                musicArray.removeAll()
                self.musicArray = arr
            }
        }
        
        tableView.reloadData()
    }
    
    func createTableView() -> Void {
        
        tableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .plain, delegate: self, dataSource: self, color:UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1), contentInset: UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0) , cellReuseIdentifier: "CollectCell")
        
        tableView.register(UINib.init(nibName: "MusicCollectCell", bundle: nil), forCellReuseIdentifier: "MusicCollectCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.tableFooterView = UIView.init()
        
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if articleOrMusic == .article {
            
            return articleArray.count
        } else {
            return musicArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if articleOrMusic == .article {
            
            let model = articleArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CollectCell") as! CollectCell
            
            cell.model = model
            
            return cell
        } else {
            
            let model = musicArray[indexPath.row]
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MusicCollectCell") as! MusicCollectCell
            
            cell.model = model
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            
            deleteArray.add(indexPath.row)
            
        } else {
            
            if articleOrMusic == .article {
                
                let model = articleArray[indexPath.row]
                let detailVC = TodayDetailsViewController()
                
                detailVC.contentid = (model.id)!
                detailVC.atricleModel = articleArray[indexPath.row]
                
                self.navigationController?.pushViewController(detailVC, animated: true)
            } else {
                
                var arr: [FMDetailModel] = []
                
                let musicVC = PlayMusicController()
                
                for temp in musicArray {
                    
                    let fmModel = FMDetailModel()
                    let play = playInfo()
                    let userInfo = userinfo()
                    
                    userInfo.uname = temp.singer
                    
                    play.tingid = temp.musicID
                    play.imgUrl = (temp.playinfo?.imgUrl)!
                    play.musicAlbum = (temp.playinfo?.albumTitle)!
                    play.imageData = (temp.playinfo?.imgData)!
                    play.title = (temp.playinfo?.title)!
                    play.userinfo = userInfo
                    
                    fmModel.playInfo = play
                    fmModel.userinfo = userInfo
                    fmModel.imageData = temp.img
                    fmModel.musicUrl = temp.musicUrl
                    
                    arr.append(fmModel)
                }
                
                musicVC.index = indexPath.row
                musicVC.musicArr = arr
                musicVC.model = arr[indexPath.row].playInfo!
                
                self.navigationController?.pushViewController(musicVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        if tableView.isEditing {
            
            deleteArray.remove(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if articleOrMusic == .article {
            return 170
        } else {
            return 105
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return UITableViewCellEditingStyle.init(rawValue: UITableViewCellEditingStyle.delete.rawValue | UITableViewCellEditingStyle.insert.rawValue)!
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
//    deinit {
//        
//        self.removeObserver(self, forKeyPath: "dataArray")
//    }
    
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
