//
//  FramentDetailViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/5.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire

class FramentDetailViewController: BaseViewController {

    var model: FragmentModel?
    lazy var webView = { () -> UIWebView in
        
        let webView = UIWebView.init(frame: CGRect.init(x: 0, y: ToolsWays.top + 60, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 124))
        
        webView.scrollView.showsVerticalScrollIndicator = false
        
        webView.backgroundColor = UIColor.white
        
        return webView
    }()
    
    var authorView: TodayDetailAuthorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.addSubview(webView)
        webView.scrollView.sizeToFit()

        createAuthorView()
        
        titleLabel.text = "详情"
        
        changeNav(image: #imageLiteral(resourceName: "navbarBack"))
        
        loadData()
        
        self.view.addSubview(navBar)
    }
    
    func createAuthorView() -> Void {
        
        authorView = TodayDetailAuthorView(frame: CGRect.init(x: 0, y: 64, width: width, height: 60))
        
        self.view.addSubview(authorView!)
    }
    
    func loadData() -> Void {
        
        showHUB(str: "加载中..")
        
        Alamofire.request(Net_TimelineInfo, method: .post, parameters: ["contentid":model!.contentid!], encoding: URLEncoding.default, headers: nil).responseJSON { (reponse) in
            
            if let dic = (reponse.result.value as? [String:AnyObject])!["data"] {
                
                //MARK: 处理html字符串 添加图片 改变图片自适应屏幕大小
                var arr = (dic["html"] as! String).components(separatedBy: "</article>\n")
                
                arr[0].append("</article>\n <img src= \"\(self.model!.coverimg!)\"/>")
                
                var imgStr = (arr as NSArray).componentsJoined(by: "\n")
                
                arr = imgStr.components(separatedBy: "</style>\n")
                
                arr[0].append("img{height: auto; width: auto; width:100%;}\n")
                
                imgStr = (arr as NSArray).componentsJoined(by: "</style>\n")
                
                
                
                self.webView.loadHTMLString(imgStr, baseURL: nil)
                
                let authorDic = dic["userinfo"] as! [String:AnyObject]
                
                self.authorView?.icon.af_setImage(withURL: URL.init(string: authorDic["icon"] as! String)!, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true, completion: nil)
                
                self.authorView?.nameLabel.text = String.init(format: "作者：%@", authorDic["uname"] as! String)
                
                let tagDic = dic["tag_info"] as! [String: AnyObject]
                var str = tagDic["tag"] as! String
                
                if str == "" {
                    
                    str = "其他"
                }
                
                self.authorView?.descLabel.text = String.init(format: "标签：%@", str) + String.init(format: "                         发表时间：%@", dic["addtime_f"] as! String)
                
            }
            self.hideHUB()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
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
