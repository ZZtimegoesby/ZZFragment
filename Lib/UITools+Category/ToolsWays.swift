//
//  ToolsWays.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/16.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import MagicalRecord
import Alamofire

enum tableViewStyle {
    case plain
    case group
}

class ToolsWays: NSObject {

    static let top: CGFloat = 64
    
    class func createImageView(frame: CGRect, image: UIImage) -> UIImageView {
        
        let imageView = UIImageView.init(frame: frame)
        
        imageView.image = image.original()
        
        return imageView
    }
    
    class func createButton(frame: CGRect, title: String?, titleColor: UIColor?,image: UIImage?, selectImage: UIImage?) -> UIButton {
        
        let button = UIButton.init(frame: frame)
        
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setBackgroundImage(image, for: .normal)
        button.setBackgroundImage(selectImage, for: .selected)
        button.setBackgroundImage(image, for: .highlighted)

        return button
    }
    
    class func createLabel(frame: CGRect, labelText: String?, textColor: UIColor?, font: UIFont) -> UILabel {
        
        let label = UILabel.init(frame: frame)
        
        label.text = labelText
        label.textColor = textColor
        label.font = font
        
        return label
    }
    
    class func createView(frame: CGRect, backgroundCollor: UIColor) -> UIView {
        
        let view = UIView.init(frame: frame)
        
        view.backgroundColor = backgroundCollor
        
        return view
    }
    
    class func createTableView(frame: CGRect, style: tableViewStyle, delegate: UITableViewDelegate, dataSource: UITableViewDataSource, color: UIColor?, contentInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0), cellReuseIdentifier: String?) -> UITableView {
        
        var tableView: UITableView!
        
        if style == .plain {
            
            tableView = UITableView(frame: frame, style: .plain)
        } else {
            
            tableView = UITableView(frame: frame, style: .grouped)
        }
        
        tableView.delegate = delegate
        tableView.dataSource = dataSource
        tableView.backgroundColor = color
        tableView.contentInset = contentInset
        
        if cellReuseIdentifier != nil {
            
            tableView.register(UINib.init(nibName: cellReuseIdentifier!, bundle: nil), forCellReuseIdentifier: cellReuseIdentifier!)
        }
        
        return tableView
    }
    
    class func createCollectionView(frame: CGRect, layout: UICollectionViewFlowLayout, delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource, color: UIColor?, contentInset: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0), cellWithReuseIdentifier: String?) -> UICollectionView {
        
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        
        collectionView.backgroundColor = color
        collectionView.delegate = delegate
        collectionView.dataSource = dataSource
        collectionView.contentInset = contentInset
        collectionView.bounces = false

        if cellWithReuseIdentifier != nil {
            
            collectionView.register(UINib.init(nibName: cellWithReuseIdentifier!, bundle: nil), forCellWithReuseIdentifier: cellWithReuseIdentifier!)
        }
        
        return collectionView
    }
    
    class func saveModeltoCoreData(baseModel: BaseModel, article: ArticleModel, user: Userinfo, showtextHub: @escaping ()->Void, userName: String, imgUrl:String!) -> Void {
        
        MagicalRecord.save({ (context) in
            
            article.title = baseModel.title
            if baseModel.imageData == nil {
                
                Alamofire.request(imgUrl).responseData(completionHandler: { (data) in
                    
                    article.coverimg = (data.result.value)!
                })
            } else {
                
                article.coverimg = baseModel.imageData
            }
            article.userinfo = user
            
            article.type = baseModel.modeltype
            //TODO: 更改user
            article.userName = userName
            
            switch baseModel.modeltype! {
            case "TodayModel":
                
                let model = baseModel as! TodayModel
                
                article.content = model.content
                article.id = model.id
                
            case "FreedomWriteModel":
                
                let model = baseModel as! FreedomWriteModel
                
                article.content = model.shortcontent
                article.id = model.contentid
                
            case "ReadDetailModel":
                
                let model = baseModel as! ReadDetailModel
                
                article.content = model.content
                article.id = model.id
                
            case "TopicModel":
                
                let model = baseModel as! TopicModel
                
                article.content = model.content
                article.id = model.contentid
                
            default:
                break
            }
            
        }) { (sucess, error) in
            
            showtextHub()
        }
    }
}
