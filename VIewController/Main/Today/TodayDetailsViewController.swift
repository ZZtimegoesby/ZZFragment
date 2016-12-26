//
//  TodayDetailsViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/18.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import MagicalRecord

class TodayDetailsViewController: BaseViewController, UIScrollViewDelegate {

    var contentid: String!
    var baseModel: BaseModel!
    var atricleModel: ArticleModel?
    var flag = 0
    var likeButton: UIButton!
    var authorModel: userinfo!
    var imgUrl: String!
    
    lazy var webView = { () -> UIWebView in
       
        let webView = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        webView.backgroundColor = UIColor.white
        
        return webView
    }()
    
    var authorView: TodayDetailAuthorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.scrollView.contentInset = UIEdgeInsets.init(top: ToolsWays.top + 55, left: 0, bottom: 0, right: 0)
        
        //解决加载时底部出现黑条
        webView.isOpaque = false
        
        self.view.addSubview(webView)
                
        loadData()
        
        changeNav(image: #imageLiteral(resourceName: "navbarBack"))
        
        titleLabel.text = "详情"
        
        webView.scrollView.delegate = self
                
        createAuthorView()
        
        examineButtonSelect()
        
        self.view.addSubview(navBar)
    }
    
    func examineButtonSelect() -> Void {
        
        if (ArticleModel.mr_find(byAttribute: "id", withValue: contentid)?.count)! > 0 {
            
            likeButton.isSelected = true
        }
    }
    
    func createAuthorView() -> Void {
        
        authorView = TodayDetailAuthorView(frame: CGRect.init(x: 0, y: 64, width: width, height: 60))
        
        self.view.addSubview(authorView!)
    }
    
    override func changeNav(image: UIImage?) {
        super.changeNav(image: image)
        
        let view = ToolsWays.createView(frame: CGRect.init(x: width - 115, y: 20, width: 115, height: 40), backgroundCollor: UIColor.white)
        
        if flag == 0 {
            
            likeButton = ToolsWays.createButton(frame: CGRect.init(x: 18, y: 8, width: 32, height: 30), title: nil, titleColor: nil, image: #imageLiteral(resourceName: "navBarLoveSelected"), selectImage: #imageLiteral(resourceName: "contentLoved").original())
            view.addSubview(likeButton)
            likeButton.addTarget(self, action: #selector(self.likeClick(button:)), for: .touchUpInside)
        }
        
        let shareButton = ToolsWays.createButton(frame: CGRect.init(x: 75, y: 8, width: 32, height: 30), title: nil, titleColor: nil, image: #imageLiteral(resourceName: "contentMore"), selectImage: nil)
        
        view.addSubview(shareButton)
        navBar.addSubview(view)
    }
    
    func likeClick(button: UIButton) -> Void {
        
        button.isSelected = !button.isSelected
        
        if let context = ArticleModel.mr_findFirst(byAttribute: "id", withValue: contentid) {
            
            context.mr_deleteEntity()
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            showTextHUB(str: "已取消收藏")
        } else{
            addAction()
        }
    }
    
    func loadData() -> Void {
        
        showHUB(str: "正在加载")
        
        Alamofire.request(Net_ArticleInfo, method: .post, parameters: ["contentid":contentid], encoding: URLEncoding.default, headers: nil).responseJSON { (reponse) in
            
            if let dic = (reponse.result.value as? [String:AnyObject])!["data"] {
                
                //MARK: 处理html字符串 改变图片自适应屏幕大小

                var arr = (dic["html"] as! String).components(separatedBy: "</style>\n")
                
                arr[0].append("img{height: auto; width: auto/9; width:100%;}\n")
                
                let imgStr = (arr as NSArray).componentsJoined(by: "</style>\n")
                
                
                self.webView.loadHTMLString(imgStr, baseURL: nil)
                
                self.authorModel = try! userinfo(dictionary: dic["userinfo"] as! [String : AnyObject])
                
                self.authorView?.icon.af_setImage(withURL: URL.init(string: self.authorModel.icon!)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
                
                self.authorView?.nameLabel.text = String.init(format: "作者：%@", self.authorModel.uname!)
                
                self.authorView?.descLabel.text = String.init(format: "签名：%@", self.authorModel.desc!)
            }
            self.hideHUB()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
    //MARK:  ------ 数据库操作 --------
    
    func addAction() -> Void {
        
        let atricle = ArticleModel.mr_createEntity()
        
        if baseModel == nil {
            
            MagicalRecord.save({ (context) in
                
                atricle?.content = (self.atricleModel?.content)!
                atricle?.coverimg = (self.atricleModel?.coverimg)!
                atricle?.id = (self.atricleModel?.id)!
                atricle?.title = (self.atricleModel?.title)!
                atricle?.type = (self.atricleModel?.type)!
                atricle?.userName = (self.atricleModel?.userName)!
                atricle?.userinfo = (self.atricleModel?.userinfo)!
                
                }, completion: { (success, error) in
                    
                    self.showTextHUB(str: "已收藏")
            })
            
        } else{
            
            let user = Userinfo.mr_createEntity()
            user?.articles = atricle!
            user?.uname = self.authorModel.uname
            user?.desc = self.authorModel.desc
            if authorView?.icon.image == nil {
                
                Alamofire.request(self.authorModel.icon!).responseData(completionHandler: { (data) in
                    
                    user?.icon = (data.result.value)!
                })
            } else {
                
                user?.icon = UIImagePNGRepresentation((self.authorView?.icon.image)!)
            }
            
            ToolsWays.saveModeltoCoreData(baseModel: self.baseModel, article: atricle!, user: user!, showtextHub: {
                
                self.showTextHUB(str: "已收藏")
                
                }, userName: "1", imgUrl: imgUrl)
        }
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
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
