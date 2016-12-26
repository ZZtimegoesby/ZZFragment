//
//  ArticleCollectViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/12/7.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class ArticleCollectViewController: CollectViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.articleOrMusic = CollectViewWithArticleOrMusic.article
        titleLabel.text = "我的美文"
        createTableView()
        
        self.view.addSubview(navBar)
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
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
