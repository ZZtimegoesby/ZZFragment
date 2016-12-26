//
//  ReadViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire

class ReadViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var collectionView: ReadCollectionView!
    var dataArray: [ReadCellModel] = []
    var picArray: [MainSliderModel] = []
    var detailVC: ReadDetailViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        loadData()
        
        titleLabel.text = "阅读"
        
        createCollectionView()
        
        self.view.addSubview(navBar)
    }
    
    func loadData() -> Void {
        
        showHUB(str: "加载中...")
        
        Alamofire.request(Net_ReadColumns, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            
            if let dic = (response.result.value as? [String : AnyObject])?["data"] as? [String : AnyObject] {
                
                for temp in dic["list"] as! [[String : AnyObject]] {
                    
                    let readModel = try! ReadCellModel(dictionary: temp)
                    
                    self.dataArray.append(readModel)
                }
                
                for temp in dic["carousel"] as! [[String : AnyObject]] {
                    
                    let model = try! MainSliderModel(dictionary: temp)
                    
                    self.picArray.append(model)
                }
                
                self.collectionView.reloadData()
            }
            self.hideHUB()
        }
    }
    
    func createCollectionView() -> Void {
        
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .vertical
        
        collectionView = ReadCollectionView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), collectionViewLayout: layout, VC: self)
        
        collectionView.contentInset = UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReadlistCell", for: indexPath) as! ReadlistCell
        
            cell.model = dataArray[indexPath.item]
            
            return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (width - 40) / 3, height: (width - 40) / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let model = dataArray[indexPath.item]
        
        let newVC = ReadNewViewController()
        
        newVC.type = model.type
        newVC.sort = "addtime"
        newVC.title = "最新文章"
        
        let hotVC = ReadNewViewController()
        
        hotVC.type = model.type
        hotVC.sort = "hot"
        hotVC.title = "热门文章"
        
        detailVC = ReadDetailViewController()

        detailVC.VCArray = [newVC, hotVC]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ReadFooterView", for: indexPath) as! ReadFooterView
            
            view.freedWriteBtn.addTarget(self, action: #selector(self.freedomBtnClick), for: .touchUpInside)
            
            return view
            
        } else {
            
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            
            view.backgroundColor = UIColor.gray
            
            if picArray.count != 0 {
                
                self.collectionView.createSliderView(vc: self, view: view)
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.pushDtailView))
                self.collectionView.sliderController.view.addGestureRecognizer(tap)
                
                return view
                
            } else{
                
                return view
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: width, height: 190)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: width, height: width * 241 / 516 + 20)
    }
    
    func pushDtailView() -> Void {
        
        let index = collectionView!.sliderController.currentIndex
        
        let str = picArray[index].url
        
        let arr = str!.components(separatedBy: "/")
        
        let sliderVC = TodayDetailsViewController()
        
        sliderVC.flag = 1
        sliderVC.contentid = arr[3]
        
        self.navigationController?.pushViewController(sliderVC, animated: true)
    }
    
    func freedomBtnClick() -> Void {
        
        let newVC = FreedomNewViewController()
        
        newVC.sort = "addtime"
        newVC.title = "最新写作"
        
        let hotVC = FreedomNewViewController()
        
        hotVC.sort = "hot"
        hotVC.title = "热门写作"
        
        detailVC = ReadDetailViewController()
        
        detailVC.VCArray = [newVC, hotVC]
        
        self.navigationController?.pushViewController(detailVC, animated: true)
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
