//
//  TagsViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/19.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire

class TagsViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var dataArray: [tagsModel] = []
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        createCollectionVeiw()
        
        titleLabel.text = "标签"
        
        loadData(path: Net_tag)
        
        self.view.addSubview(navBar)
    }
    
    func createCollectionVeiw() -> Void {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        collectionView = ToolsWays.createCollectionView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), layout: layout, delegate: self, dataSource: self, color: UIColor.init(red: 239/255, green: 239/255, blue: 244/255, alpha: 1), contentInset: UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0), cellWithReuseIdentifier: "TagsCell")
        
        self.view.addSubview(collectionView!)
    }
    
    func loadData(path: String) {
        
        showHUB(str: "请稍候..")
        
        Alamofire.request(path, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (respone) in
            
            if let dic = (respone.result.value as? [String:AnyObject])?["data"] {
                
                for temp in dic["list"] as! [[String:AnyObject]] {
                    
                    let model = try! tagsModel(dictionary: temp)
                    self.dataArray.append(model)
                }
                self.collectionView?.reloadData()
            }
            
            self.hideHUB()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCell", for: indexPath) as! TagsCell
        
        cell.model = dataArray[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataArray[indexPath.item]
        
        let tagsVC = TagsShowController()
        
        tagsVC.model = model
        tagsVC.title = model.tag!
        
        self.navigationController?.pushViewController(tagsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize.init(width: (width - 40)/3, height: 134)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 20, left: 10, bottom: 10, right: 10)
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
