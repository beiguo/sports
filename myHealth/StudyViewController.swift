//
//  StudyViewController.swift
//  myHealth
//
//  Created by 石庆磊 on 2017/9/10.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit
import AVFoundation
import MobileCoreServices

class StudyViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableV: UITableView!
    
//    var dataArr = ["山地车骑行姿势","山地车骑行装备","如何骑上自行车","如何从自行车上下来","如何转移重心","如何转弯","压抬技巧","之字形上坡","之字形下坡骑行路线","如何进行兔跳_1","如何进行兔跳_2","山地车后轮骑行技巧","山地车后轮滑行技巧","如何抬后轮","如何侧跳","如何下落差","如何在骑行中跳跃"]
    var dataArr = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView();
        self.automaticallyAdjustsScrollViewInsets = false;
        
        
        let view = UIView(frame: CGRect.zero)
        self.tableV.tableFooterView = view
    }
    
    func setTableView() {
        tableV.delegate = self;
        tableV.dataSource = self;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudyCell", for: indexPath) as! StudyTableViewCell;
        cell.titleL.text = dataArr[indexPath.row]
        let path = Bundle.main.path(forResource: dataArr[indexPath.row], ofType: "mp4");
        print(indexPath.row);
        cell.imgV.image = getAVGenrator(filePth: path!);
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "toPlayVideo", sender: nil);
        tableView.deselectRow(at: indexPath, animated: true)
        let clvc = CLViewController4()
        let path = Bundle.main.path(forResource: dataArr[indexPath.row], ofType: "mp4")
        clvc.path = path
        clvc.vTitle = dataArr[indexPath.row]
        self.navigationController?.pushViewController(clvc, animated: true)
        
    }
    
//    获取locat视频截图
    func getAVGenrator(filePth:String) ->UIImage{
        let vidoUrl = NSURL(fileURLWithPath: filePth)
        let avAsset = AVAsset(url: vidoUrl as URL)
        
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        let time = CMTimeMakeWithSeconds(5.0, 600)
        var actualTime:CMTime = CMTimeMake(0, 0)
        let imageRef = try! generator.copyCGImage(at: time, actualTime: &actualTime)
        let frameImg = UIImage(cgImage: imageRef)
        
        return frameImg
        
        
    }
    
    

    
    
    
    
}
