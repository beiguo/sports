//
//  RunViewController.swift
//  myHealth
//
//  Created by 石庆磊 on 2017/9/10.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit
import StreamingKit
import WebKit
import SVProgressHUD



class RunViewController: UIViewController , WKUIDelegate , WKNavigationDelegate ,STKAudioPlayerDelegate{
    
    @IBOutlet weak var runBtnView: UIView!
    
    var musicView:UIView!
    var wkWebV : WKWebView!
    var slider: UISlider!
    var playBtn : UIButton!
    var nextBtn : UIButton!
    var musicTitleLable : UILabel!
    var audioPlayer = STKAudioPlayer()
    var isOpenMusic = false
    //播放列表
    
    
    
    var quene  = [
        ["name":"Rolling In The Deep","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Rolling In The Deep", ofType: "mp3")!)],
        ["name":"Making Love Out Of Nothing At All","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Making Love Out Of Nothing At All", ofType: "mp3")!)],
        ["name":"Moon","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Moon", ofType: "mp3")!)],
        ["name":"Booty Music","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Booty Music", ofType: "mp3")!)],
        ["name":"Please Don't Go","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Please Don't Go", ofType: "mp3")!)],
        ["name":"Te Rog","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Te Rog", ofType: "mp3")!)],
        ["name":"Release The Pain","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Release The Pain", ofType: "mp3")!)],
        ["name":"Why We Try","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Why We Try", ofType: "mp3")!)],
        ["name":"Grenade","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Grenade", ofType: "mp3")!)],
        ["name":"Say Goodnight","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Say Goodnight", ofType: "mp3")!)],
        ["name":"Born to Do","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Born to Do", ofType: "mp3")!)],
        ["name":"Fugitive","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Fugitive", ofType: "mp3")!)],
        ["name":"I Can","url":URL(fileURLWithPath:Bundle.main.path(forResource: "I Can", ofType: "mp3")!)],
        ["name":"Trippin","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Trippin", ofType: "mp3")!)],
        ["name":"Beautiful In White","url":URL(fileURLWithPath:Bundle.main.path(forResource: "Beautiful In White", ofType: "mp3")!)]
    ]
    
    
    //更新进度条定时器
    var timer:Timer!
    
    //当前播放音乐索引
    var currentIndex:Int = -1
    
    //是否循环播放
    var loop:Bool = false
    
    //当前播放状态
    var state:STKAudioPlayerState = []

    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        createMusicView();
        createWebView();
        
        
        createSlider();
        createBtn();
        createTitleLable()
        
        
        //重置播放器
        resetAudioPlayer()
        
        //歌曲重新排序
        
        //设置一个定时器，每三秒钟滚动一次
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,
                                     selector: #selector(tick), userInfo: nil, repeats: true)

        
        getHealthData()
        changeRunBtn()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RunViewController.changeAudioPlay), name: NSNotification.Name(rawValue: "CHANGEAUDIO"), object: nil)
        
    }
    
    
    
    
    func tick() {
        if state == .playing {
            
            
            slider.value = Float(audioPlayer.progress);
        }
    }
    
    func changeProgress() {
        audioPlayer.seek(toTime: Double(slider.value))
        if state == .paused {
            audioPlayer.resume()
        }
    }
    
    func createTitleLable() {
        musicTitleLable = UILabel(frame: CGRect(x: 0, y: 30, width: self.view.frame.size.width, height: 40))
        
        musicTitleLable.textColor = UIColor.white
        musicTitleLable.textAlignment = .center
        
        musicView.addSubview(musicTitleLable)
    }
    
    func createWebView() {
        wkWebV = WKWebView(frame: CGRect(x: 30, y: self.view.bounds.height*0.17, width: self.view.bounds.width-60, height: self.view.bounds.height*0.36));
        wkWebV.scrollView.layer.cornerRadius = 40
        wkWebV.navigationDelegate = self
        wkWebV.uiDelegate = self
        
        wkWebV.scrollView.isScrollEnabled = false;
        let path = Bundle.main.path(forResource: "playAni1", ofType: "html");
        let url = URL(fileURLWithPath: path!);
        wkWebV.load(URLRequest(url: url));
        self.musicView.addSubview(wkWebV);
    }
    
    func createSlider() {
        slider = UISlider(frame: CGRect(x: 30, y: self.view.bounds.height*0.6, width: self.view.bounds.width-60, height: 31));
        slider.setThumbImage(UIImage(named:"cm2_efc_knob_trough_prs"), for: .normal)
        slider.addTarget(self, action: #selector(RunViewController.changeProgress), for: UIControlEvents.valueChanged);
//        slider.maximumTrackTintColor = UIColor.white
        slider.minimumTrackTintColor = UIColor.white
        self.musicView.addSubview(slider);
    }
    
    
    func createBtn() {
        playBtn = UIButton(type: UIButtonType.custom)
        playBtn.frame = CGRect(x: self.view.bounds.width*0.23, y: self.view.bounds.height*0.75, width: self.view.bounds.width*0.1, height: self.view.bounds.width*0.1)
        playBtn.setImage(UIImage(named:"stopMusic.png"), for: UIControlState.normal);
        playBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        playBtn.addTarget(self, action: #selector(RunViewController.playOrStopMusic), for: UIControlEvents.touchUpInside)
        self.musicView.addSubview(playBtn);
        
        
        nextBtn = UIButton(type: UIButtonType.custom)
        nextBtn.frame = CGRect(x: self.view.bounds.width*0.68, y: self.view.bounds.height*0.74, width: self.view.bounds.width*0.12, height: self.view.bounds.width*0.12)
        nextBtn.setImage(UIImage(named:"nextMusic.png"), for: UIControlState.normal);
        nextBtn.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        nextBtn.addTarget(self, action: #selector(RunViewController.playNextMusic), for: UIControlEvents.touchUpInside)
        self.musicView.addSubview(nextBtn);
    }
    
    
    func openMusicView() {
        
        if !isOpenMusic {
            playWithQueue(queue: quene)
            isOpenMusic = true
        }
        
        
        
         UIView.animate(withDuration: 1) {
            self.musicView.frame.origin = CGPoint(x: 0, y: 0);
            self.musicView.alpha = 1
            
            var rect = self.runBtnView.bounds
            rect = CGRect(x: 0, y: 0, width: rect.width*1.3, height: rect.width*1.3)
            self.runBtnView.bounds = rect
            
            
        }
        
        
        
        
    }
    
    
    func createMusicView() {
        musicView = UIView(frame: UIScreen.main.bounds)
        musicView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height);
//        musicView.backgroundColor = UIColor(colorLiteralRed: 0.1, green: 0.1, blue: 0.2, alpha: 1)
        musicView.backgroundColor = UIColor.black
        musicView.alpha = 0
        let recognizer = UISwipeGestureRecognizer(target: self, action: #selector(RunViewController.responseGlide))
        recognizer.direction = .down;
        musicView.addGestureRecognizer(recognizer);
        
        UIApplication.shared.keyWindow?.addSubview(musicView);
        
    }
    
    //向下
    func responseGlide() {
        UIView.animate(withDuration: 1) {
            self.musicView.frame.origin = CGPoint(x: 0, y: UIScreen.main.bounds.height);
            self.musicView.alpha = 0
            
            var rect = self.runBtnView.bounds
            rect = CGRect(x: 0, y: 0, width: rect.width/1.3, height: rect.width/1.3)
            self.runBtnView.bounds = rect
        }
        
        getHealthData()
    }
    
    func resetAudioPlayer()  {
        var options = STKAudioPlayerOptions()
        options.flushQueueOnSeek = true
        options.enableVolumeMixer = true
        
        
        audioPlayer = STKAudioPlayer(options: options)
        
        audioPlayer.meteringEnabled = true
        audioPlayer.volume = 1
        audioPlayer.delegate = self
    }
    
    
    
    func playWithQueue(queue:[Dictionary<String, Any>],index:Int = 0) {
        guard index >= 0 && index < queue.count else {
            return
        }
        self.quene = queue
        audioPlayer.clearQueue()
        let url = queue[index]["url"] as! URL
        
        
        audioPlayer.play(url)
        
        
        for i in 1 ..< queue.count {
            audioPlayer.queue(queue[Int((index + i) % queue.count)]["url"] as! URL)
        }
        currentIndex = index
        loop = false
    }

    
    //播放／暂停
    func playOrStopMusic() {
        //在暂停和继续两个状态间切换
        if self.state == .paused {
            audioPlayer.resume()
            
            playBtn.setImage(UIImage(named:"stopMusic.png"), for: UIControlState.normal);
        }else{
            audioPlayer.pause()
            playBtn.setImage(UIImage(named:"playMusic.png"), for: UIControlState.normal);
        }
    }
    
    // 下一曲
    func playNextMusic()  {
        next();
    }
    
    func next() {
        guard quene.count > 0 else {
            return
        }
        currentIndex = (currentIndex + 1) % quene.count
        playWithQueue(queue: quene, index: currentIndex)
    }

    
    //STKAudioPlayer-delegate
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didStartPlayingQueueItemId queueItemId: NSObject) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didCancelQueuedItems queuedItems: [Any]) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishBufferingSourceWithQueueItemId queueItemId: NSObject) {
        updateNowPlayingInfoCenter()
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, stateChanged state: STKAudioPlayerState, previousState: STKAudioPlayerState) {
        self.state = state
        if state != .stopped && state != .error && state != .disposed {
        }
        updateNowPlayingInfoCenter()
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, didFinishPlayingQueueItemId queueItemId: NSObject, with stopReason: STKAudioPlayerStopReason, andProgress progress: Double, andDuration duration: Double) {
        
    }
    
    func audioPlayer(_ audioPlayer: STKAudioPlayer, unexpectedError errorCode: STKAudioPlayerErrorCode) {
//        print("Error when playing music \(errorCode)")
        resetAudioPlayer()
        playWithQueue(queue: quene, index: currentIndex)
    }
    
    
    //更新当前播放信息
    func updateNowPlayingInfoCenter() {
        if currentIndex >= 0 {
            let music = quene[currentIndex]
            //更新标题
//            self.title = "当前播放：\(String(describing: music["name"]))"
            musicTitleLable.text = String(describing: music["name"]!)
            //设置进度条相关属性
            slider!.maximumValue = Float(audioPlayer.duration)
        }else{
            //停止播放
            slider.value = 0
        }
    }
    
    
    //调整runbtn
    func changeRunBtn() {
        runBtnView.layer.masksToBounds = true;
        runBtnView.layer.cornerRadius = 80
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(RunViewController.openMusicView))
        runBtnView.addGestureRecognizer(recognizer);

        
    }
    
    
    //得到健康数据
    func getHealthData() {
        HealthManager().authorizeHealthKit{(authorized , error)->Void in
            if authorized {
                
                HealthManager().getStepCount(completion: { (steps, error) in
                    
                    if steps != -10{
                        
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateStyle = DateFormatter.Style.short
                        let dateString = dateFormatter.string(from: date)
                        
                        let dic = [dateString:["steps":steps]]
                        
                        if UserDefaults.standard.object(forKey: "Notes") == nil{
                            
                            UserDefaults.standard.set(dic, forKey: "Notes")
                            
                            
                        }else{
                        
                            let haveHealDic = NSMutableDictionary(dictionary: UserDefaults.standard.object(forKey: "Notes") as! NSDictionary)
                            
                            if haveHealDic[dateString] == nil{
                            
                                haveHealDic[dateString] = ["steps":steps]
                                
                            }else{
                                
                                let stepsDic = NSMutableDictionary(dictionary: haveHealDic[dateString] as! NSDictionary)
                                
                                
                                stepsDic["steps"] = steps
                                
                                haveHealDic[dateString] = stepsDic
                                
                            }
                            
                            UserDefaults.standard.set(haveHealDic, forKey: "Notes");
                            
                        }
                        
                    }
                    
                })
                
                HealthManager().getDistance { (distance, error) in
                    
                    if distance != -10{
                        
                        
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        
                        dateFormatter.dateStyle = DateFormatter.Style.short
                        let dateString = dateFormatter.string(from: date)
                        
                        let dic = [dateString:["distance":distance]]
                        
                        if UserDefaults.standard.object(forKey: "Notes") == nil{
                            
                            UserDefaults.standard.set(dic, forKey: "Notes")
                            
                            
                        }else{
                            
                            let haveHealDic = NSMutableDictionary(dictionary: UserDefaults.standard.object(forKey: "Notes") as! NSDictionary)
                            
                            if haveHealDic[dateString] == nil{
                                
                                haveHealDic[dateString] = ["distance":distance]
                                
                            }else{
                                
                                let distanceDic = NSMutableDictionary(dictionary: haveHealDic[dateString] as! NSDictionary)
                                
                                
                                distanceDic["distance"] = distance
                                
                                haveHealDic[dateString] = distanceDic
                                
                            }
                            
                            UserDefaults.standard.set(haveHealDic, forKey: "Notes");
                            
                        }
                        
                    }
                }
                
                
            }else{
                
                SVProgressHUD.showError(withStatus: "对不起，您当前设备没有提供健康数据的功能")
                
                
            }
            
        }
    
    }
    
    
    //播放视频的时候停止播放音频
    func changeAudioPlay(){
    
        playOrStopMusic()
        
    }
    
}
