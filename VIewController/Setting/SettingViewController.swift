//
//  SettingViewController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var dataArray: [UITableViewCell] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func createTableView() -> Void {
        
        tableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: width, height: height), style: .plain, delegate: self, dataSource: self, color: nil, contentInset: UIEdgeInsets.init(top: ToolsWays.top, left: 0, bottom: 0, right: 0), cellReuseIdentifier: nil)
        
        self.view.addSubview(tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return dataArray[indexPath.row]
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
