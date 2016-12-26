//
//  PlayMusicController.swift
//  ZZFragment
//
//  Created by qianfeng on 16/10/24.
//  Copyright © 2016年 张政. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation
import MediaPlayer
import MagicalRecord

enum PlayerCurrentPlayMode {
    case singleLoop  //单曲循环
    case listLoop    //列表循环
    case randomPlay  //随机播放
}

class PlayMusicController: UIViewController {
    
    @IBOutlet weak var backImg: UIImageView!
    @IBOutlet weak var singer: UILabel!       //歌手名
    @IBOutlet weak var musicName: UILabel!      //音乐名称
    @IBOutlet weak var musicImg: UIImageView!     //音乐图片
    @IBOutlet weak var lastTime: UILabel!       //剩余播放时间
    @IBOutlet weak var currentTime: UILabel!   // 当前播放时间
    @IBOutlet weak var slider: UISlider!    //进度条
    @IBOutlet weak var playModeBtn: UIButton!    //循环模式
    @IBOutlet weak var nextButton: UIButton!   //下一曲
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    var model: playInfo!
    var musicArr: [FMDetailModel] = []  //歌曲数组
    var player = SingleVCs.player
    var index: Int!
    var timer: Timer?
    var timeObserver: Any!     //player监听
    var currentSecond: Float = 0     //当前播放时间
    var durationSecond: Float = 0     //总时间
    var playView: PlayListView!    //播放列表界面
    var alartView: PlayerAlartView!     //提示框
    var lockViewDic: [String:Any] = [:]      //后台信息字典
    var playMode: PlayerCurrentPlayMode = .listLoop    //播放模式
    
    //MARK:---------- 播放方法 -------------
    @IBAction func playClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        lockViewDic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double(currentSecond)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = lockViewDic

        if player.timeControlStatus == .playing {
            
            player.pause()
            timer?.invalidate()
        } else {
            player.play()
            createTimer()
        }
    }
    
    //MARK:---------- 上一曲 -------------
    @IBAction func lastMusicClick(_ sender: UIButton) {
        
        if index == 0 {
            
            index = musicArr.count
        }
        
        changeMusicIfRandomPlay(changeIndex: index, str: "上")
    }
    
    //MARK:---------- 下一曲 -------------
    @IBAction func nextMusicClick(_ sender: UIButton) {
        
        if index == musicArr.count - 1 {
            
            index = -1
        }
        
        changeMusicIfRandomPlay(changeIndex: index, str: "下")
    }
    
    //MARK:---------- 换歌 -------------
    func changeMusicIfRandomPlay(changeIndex: Int, str: String) -> Void {
        
        if playMode == .randomPlay {
            
            while true {
                
                let arcIndex = Int(arc4random_uniform(UInt32(musicArr.count)))
                
                if index != arcIndex {
                    
                    index = arcIndex
                    changeMusic(index: index)
                    return
                }
            }
        } else{
            
            if str == "下" {
                
                index = changeIndex + 1
            } else {
                index = changeIndex - 1
            }
            
            changeMusic(index: index)
        }
    }
    
    func changeMusic(index: Int) -> Void {
        
        slider.value = 0
        model = musicArr[index].playInfo
        
        timer?.invalidate()
        loadUIData()
        
        player.currentItem?.removeObserver(self, forKeyPath: "status")

        let item = AVPlayerItem(url: URL(string: self.musicArr[index].musicUrl!)!)
        
        player.replaceCurrentItem(with: item)
        
        player.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        player.play()
    }
    
    //MARK:---------- 分享 -------------
    @IBAction func shareClick(_ sender: UIButton) {
        
        
    }
    
    //MARK:---------- 喜欢 ------------
    @IBAction func likeMusicClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if let context = MusicModel.mr_findFirst(byAttribute: "musicID", withValue: model.tingid!) {
            
            context.mr_deleteEntity()
            NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
            alartView.show(text: "已取消收藏")
        } else {
            
            let musicModel = MusicModel.mr_createEntity()
            let userinfo = Userinfo.mr_createEntity()
            let playinfo = Playinfo.mr_createEntity()
            
            playinfo?.imgData = model.imageData!
            playinfo?.imgUrl = model.imgUrl!
            playinfo?.tingid = model.tingid!
            playinfo?.title = model.title!
            playinfo?.albumTitle = model.musicAlbum!
            playinfo?.musicModel = musicModel
            playinfo?.userinfo = userinfo
            
            userinfo?.playinfo = playinfo
            userinfo?.uname = (model.userinfo?.uname)!
            
            MagicalRecord.save({ (context) in
                
                musicModel?.img = self.model.imageData!
                musicModel?.singer = (self.model.userinfo?.uname)!
                musicModel?.musicID = (playinfo?.tingid)!
                musicModel?.playinfo = playinfo
                musicModel?.musicUrl = self.musicArr[self.index].musicUrl!
                
                musicModel?.userName = "1"
                
                }, completion: { (success, error) in
                    
                    self.alartView.show(text: "已添加至收藏")
            })
        }
    }
    
    //MARK:---------- 下载 -------------
    @IBAction func loadDownMusicClick(_ sender: UIButton) {
        
        
    }
    
    //MARK:---------- 播放列表 -------------
    @IBAction func showAllMusic(_ sender: UIButton) {
        
        playView = PlayListView(frame: self.view.frame, color: UIColor.init(white: 0, alpha: 0.3), controller: self)
        
        self.view.addSubview(playView)
        
        UIView.animate(withDuration: 0.3) {
            
            self.playView.playListView.frame = CGRect.init(x: 0, y: self.height - 330, width: self.width, height: 330)
        }
    }
    
    //MARK:---------- 更改播放模式 ------------
    @IBAction func changPlayMoel(_ sender: UIButton) {
        
        if playMode == .listLoop {
            
            playMode = .singleLoop
            sender.setImage(#imageLiteral(resourceName: "娱乐_单曲循环"), for: .normal)
            alartView.show(text: "单曲循环")
        } else if playMode == .singleLoop {
            
            playMode = .randomPlay
            sender.setImage(#imageLiteral(resourceName: "随机播放"), for: .normal)
            alartView.show(text: "随机播放")
        } else {
            
            playMode = .listLoop
            sender.setImage(#imageLiteral(resourceName: "娱乐_循环播放"), for: .normal)
            alartView.show(text: "列表循环")
        }
    }
    
    //MARK:---------- 取消播放列表 -----------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for tch in touches {
            
            if tch.view == playView {
                
                self.playlistViewDisAppear()
            }
        }
    }
    
    func playlistViewDisAppear() -> Void {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.playView.playListView.frame = CGRect.init(x: 0, y: self.height, width: self.width, height: 0)
        }) { (true) in
            
            self.playView.removeFromSuperview()
        }
    }
    
    //MARK: ---------- view相关方法 ------------
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        (UIApplication.shared.delegate as! AppDelegate).statusView.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        (UIApplication.shared.delegate as! AppDelegate).statusView.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUIData()
        
        createPlayer()
        
        alartView = PlayerAlartView(superView: self.view)
        self.view.addSubview(alartView)
        
        self.lockViewDic[MPMediaItemPropertyPlaybackDuration] = 0.00
        
        slider.addTarget(self, action: #selector(self.changeProgress), for: .valueChanged)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        player.currentItem?.removeObserver(self, forKeyPath: "status")
        player.removeTimeObserver(timeObserver)
        timeObserver = nil
        player.removeObserver(self, forKeyPath: "timeControlStatus")
        timer?.invalidate()
        timer = nil
    }
    
    //MARK:---------- 更新锁屏信息 -----------
    func setLockView() -> Void {
        
        lockViewDic[MPMediaItemPropertyTitle] = model.title!
        lockViewDic[MPMediaItemPropertyArtist] = (model.userinfo?.uname)!
        lockViewDic[MPMediaItemPropertyAlbumTitle] = model.musicAlbum
        lockViewDic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.00
    }
    
    //MARK:------- 接收远程控制方法（后台或锁屏） --------
    override func remoteControlReceived(with event: UIEvent?) {
        
        switch event!.subtype {
        case .remoteControlPlay:
            player.play()
            
        case .remoteControlPause:
            lockViewDic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double(currentSecond)
            MPNowPlayingInfoCenter.default().nowPlayingInfo = lockViewDic
            player.pause()
        case .remoteControlNextTrack:
            self.nextMusicClick(nextButton)
            
        case .remoteControlPreviousTrack:
            self.lastMusicClick(nextButton)
            
        default:
            break
        }
    }
    
    //MARK:---------- 播放结束调用该方法 -------
    func itemPlayFinished(n: Notification) -> Void {
        
        player.seek(to: kCMTimeZero)
        
        if playMode == .listLoop {
            
            nextMusicClick(nextButton)
        } else if playMode == .randomPlay {
            
            while true {
                
                let arcIndex = Int(arc4random_uniform(UInt32(musicArr.count)))
                
                if index != arcIndex {
                    
                    changeMusic(index: arcIndex)
                    
                    return
                }
            }
        }
    }
    
    //MARK:---------- 滑条slider方法 ------------
    func changeProgress(sender: UISlider) -> Void {
        
        player.seek(to: CMTimeMake(Int64(Float((self.player.currentItem?.duration.value)!) * slider.value), (self.player.currentItem?.duration.timescale)!), completionHandler: { (true) in
            
            self.player.play()
        })
        
        currentTime.text = timeFormoat(interval: Float(sender.value) * durationSecond)
        lastTime.text = timeFormoat(interval: durationSecond - Float(sender.value) * durationSecond)
        
        lockViewDic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = Double(Float(sender.value) * durationSecond)
        MPNowPlayingInfoCenter.default().nowPlayingInfo = lockViewDic
    }
    
    //MARK:---------- 监听方法实现 -----------
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            
            if player.currentItem?.status == .readyToPlay {
                createTimer()
            } else {
                alartView.show(text: "网络不太好。。")
                timer?.invalidate()
            }
        } else if keyPath == "timeControlStatus" {
            
            if player.timeControlStatus == .playing {
                
                playButton.isSelected = false
                
                lockViewDic[MPNowPlayingInfoPropertyPlaybackRate] = 1.0
                
                MPNowPlayingInfoCenter.default().nowPlayingInfo = lockViewDic
                
            } else if player.timeControlStatus == .paused {
                
                playButton.isSelected = true
                lockViewDic[MPNowPlayingInfoPropertyPlaybackRate] = 0.0
                MPNowPlayingInfoCenter.default().nowPlayingInfo = lockViewDic
            }
        }
    }
    
    //MARK:---------- 图片旋转 ------------
    func rotateImage() -> Void {
        
        musicImg.transform = musicImg.transform.rotated(by: CGFloat(M_PI * 0.001))
    }
    
    //MARK:---------- 创建player、添加监听 ---------
    func createPlayer() -> Void {
        
        let item = AVPlayerItem(url: URL(string: model.musicUrl!)!)
        
        player.replaceCurrentItem(with: item)
        
        player.volume = 0.5
        
        player.currentItem?.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        player.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
        
        //添加通知 自动切换下一曲
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemPlayFinished(n:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMake(1, 1), queue: .main, using: { (time) in
            
            let duration = self.player.currentItem?.duration
            
            let current = self.player.currentItem?.currentTime()
            
            self.currentSecond = Float(current!.value) / Float(current!.timescale)
            
            self.currentTime.text = self.timeFormoat(interval: self.currentSecond)
            if Float(duration!.timescale) != 0 {
                
                self.durationSecond = Float(duration!.value) / Float(duration!.timescale)
                
                if self.lockViewDic[MPMediaItemPropertyPlaybackDuration]! as! Double != Double(self.durationSecond) {
                
                    self.lockViewDic[MPMediaItemPropertyPlaybackDuration] = Double(self.durationSecond)
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self.lockViewDic
                }
                self.lastTime.text = self.timeFormoat(interval: self.durationSecond - self.currentSecond)
                
                self.slider.value = self.currentSecond / self.durationSecond
            }
        })
        
        player.play()
    }
    
    //MARK:---------- 更新界面方法 -------------
    func loadUIData() -> Void {
        
        if (MusicModel.mr_find(byAttribute: "musicID", withValue: model.tingid!)?.count)! > 0 {
            self.likeButton.isSelected = true
        } else {
            self.likeButton.isSelected = false
        }
        
        singer.text = (model.userinfo?.uname)!
        musicName.text = model.title!
        
        currentTime.text = "--:--"
        lastTime.text = "--:--"
        
        setLockView()
        musicImg.transform = .identity
        
        if model.imageData == nil {
            
            musicImg.af_setImage(withURL: URL.init(string: model.imgUrl!)!, placeholderImage: #imageLiteral(resourceName: "back_playmusic"), filter: nil, progress: nil, progressQueue: .main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.3), runImageTransitionIfCached: true) { (response) in
                
                if response.result.isSuccess {
                    
                    self.model.imageData = UIImagePNGRepresentation(response.result.value!)!
                    
                    self.backImg.image = UIImage(data: self.model.imageData!)
                    self.lockViewDic[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize.init(width: 120, height: 120), requestHandler: { (sz) -> UIImage in
                        return UIImage(data: self.model.imageData!)!
                    })
                    MPNowPlayingInfoCenter.default().nowPlayingInfo = self.lockViewDic
                }
            }
        } else {
            
            musicImg.image = UIImage(data: model.imageData!)
            self.lockViewDic[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize.init(width: 120, height: 120), requestHandler: { (sz) -> UIImage in
                return UIImage(data: self.model.imageData!)!
            })
            MPNowPlayingInfoCenter.default().nowPlayingInfo = self.lockViewDic
        }
    }
    
    //MARK: ---------- 其他方法 -------------
    //返回方法
    @IBAction func backClick(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //时间格式化 00:00
    func timeFormoat(interval:Float) -> String {
        
        let s = Int(interval) % 60
        let m = Int(interval) / 60
        
        return String(format: "%02d:%02d", m, s)
    }
    //创建timer
    func createTimer() -> Void {
        
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.rotateImage), userInfo: nil, repeats: true)
    }
    //成为第一响应者
    override var canBecomeFirstResponder: Bool {
        return true
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
