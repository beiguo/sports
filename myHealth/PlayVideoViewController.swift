//
//  PlayVideoViewController.swift
//  myHealth
//
//  Created by shilei on 2017/9/11.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit
import CLPlayer

class PlayVideoViewController: UIViewController {
    
    var player : CLPlayerView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    @IBOutlet weak var player: CLPlayerView!
    
    var isVertical = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.tabBarController?.tabBar.isHidden = true;
        // 强制横屏
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
//        appDelegate.blockRotation = true
        createPlayerView();
        
        NotificationCenter.default.addObserver(self, selector: #selector(PlayVideoViewController.changeDevive), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    func changeDevive() {
        
        if isVertical {
            print("改变了屏幕方向")
            
            isVertical = false
            
            player.frame = CGRect(x: 0, y: 0, width: self.view.bounds.height, height: self.view.bounds.width);
            
        }else{
            isVertical = true
        }
        
    }
    
    
    
    func createPlayerView() {
        player = CLPlayerView(frame: CGRect(x: 0, y: 90, width: self.view.frame.width, height: 300))
//        player.frame = self.view.bounds;
        
        player.repeatPlay = true
        
        player.isLandscape = true
        
        player.fillMode = .ResizeAspectFill
        
        player.progressBackgroundColor = UIColor.purple
        player.progressBufferColor = UIColor.red
        
        player.progressPlayFinishColor = UIColor.green
        
        player.fullStatusBarHidden = true
        player.mute = true
        player.strokeColor = UIColor.red
        player.url = URL(fileURLWithPath: Bundle.main.path(forResource: "first_run_practice", ofType: "mp4")!);
        
        player.playVideo()
        
        player.backButton { (btn) in
            print(self.player.isFullScreen);
        }
        
        player.endPlay { 
            self.player.destroyPlayer()
            self.player = nil
            print("finish");
        }
        
        
        self.view.addSubview(player)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated);
        if (self.tabBarController?.tabBar.isHidden)! {
            self.tabBarController?.tabBar.isHidden = false;
        }
        
//        appDelegate.blockRotation = false
//        let value = UIInterfaceOrientation.portrait.rawValue
//        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
//    override func shouldAutorotate() -> Bool {
//        
//        return false
//        
//    }
    
    
}
