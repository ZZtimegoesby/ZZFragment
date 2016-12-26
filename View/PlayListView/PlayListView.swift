//
//  PlayListView.swift
//  ZZFragment
//
//  Created by qianfeng on 16/11/30.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit

class PlayListView: UIView, UITableViewDataSource, UITableViewDelegate {

    var playListView: UIView!
    var superController: PlayMusicController!
    
    init(frame: CGRect, color: UIColor, controller: PlayMusicController) {
        super.init(frame: frame)
        
        self.backgroundColor = color
        
        self.superController = controller
        
        playListView = ToolsWays.createView(frame: CGRect.init(x: 0, y: frame.size.height, width: frame.size.width, height: 0), backgroundCollor: UIColor.clear)
        
        let playTableView = ToolsWays.createTableView(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: 280), style: .plain, delegate: self, dataSource: self, color: UIColor.clear, cellReuseIdentifier: nil)
        
        playTableView.bounces = false
        playTableView.showsVerticalScrollIndicator = false
        playTableView.register(UINib.init(nibName: "PlayListCell", bundle: nil), forCellReuseIdentifier: "PlayListCell")
        
        let button = ToolsWays.createButton(frame: CGRect.init(x: 0, y: playTableView.frame.height, width: frame.width, height: 50), title: "关闭", titleColor: UIColor.darkGray, image: nil, selectImage: nil)
        button.backgroundColor = UIColor.init(white: 1, alpha: 0.95)
        button.addTarget(self, action: #selector(self.btnClick), for: .touchUpInside)
        
        playListView.addSubview(button)
        playListView.addSubview(playTableView)
        
        self.addSubview(playListView)
    }
    
    func btnClick() -> Void {
        
        superController.playlistViewDisAppear()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return superController.musicArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListCell") as! PlayListCell
        
        let model = superController.musicArr[indexPath.row]
        
        cell.title.text = model.title!
        
        if indexPath.row == superController.index {
            
            cell.icon.isHighlighted = true
            cell.title.textColor = UIColor.red
        } else {
            cell.icon.isHighlighted = false
            cell.title.textColor = UIColor.darkGray
        }
        
        cell.backgroundColor = UIColor.init(white: 1, alpha: 0.95)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        superController.index = indexPath.row
        tableView.reloadData()
        superController.changeMusic(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        
        view.frame.origin = CGPoint(x: 0, y: 0)
        view.backgroundColor = UIColor.white
        
        let label = ToolsWays.createLabel(frame: CGRect.init(x: self.center.x - 30, y: 8, width: 100, height: 30), labelText: "播放列表", textColor: UIColor.black, font: UIFont.systemFont(ofSize: 16))
        
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 45
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
