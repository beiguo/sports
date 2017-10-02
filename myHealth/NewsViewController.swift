//
//  NewsViewController.swift
//  myHealth
//
//  Created by 石庆磊 on 2017/9/10.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit
import AFNetworking
import Kingfisher
import MJRefresh
import SVProgressHUD

//聚合数据接口 get
let newsUrl = "http://v.juhe.cn/toutiao/index"
let newsKey = "fc35459c18c8022409949be4c5232782"
let newsType = "tiyu"

class NewsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet weak var tableV: UITableView!
    
    var dataArr: NSArray!
    
    let header = MJRefreshNormalHeader()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.tableV.mj_header.beginRefreshing();
        
        
        let view = UIView(frame: CGRect.zero)
        self.tableV.tableFooterView = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        
        setTableView()
        
        header.setRefreshingTarget(self, refreshingAction: #selector(NewsViewController.headerRefresh))
        self.tableV.mj_header = header
    }
    
    
    //tableview - setting
    
    func setTableView() {
        tableV.delegate = self
        tableV.dataSource = self
        
        
    }
    
    func headerRefresh() {
        
        //判断网络状态
        if UserDefaults.standard.object(forKey: "NoNetWork") != nil {
            
            let str = UserDefaults.standard.object(forKey: "NoNetWork") as! String
            
            if str == "YES" {
                
                let alertView = UIAlertController.init(title: "网络断开连接", message: "请检查网络或者蜂窝网络使用权限", preferredStyle: UIAlertControllerStyle.alert);
                let cancleBtn = UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel) { (action) in
                    //取消
                    
                }
                let exitBtn = UIAlertAction.init(title: "点击退出", style: UIAlertActionStyle.default) { (action) in
                    //退出
                    
                }
                alertView.addAction(cancleBtn)
                alertView.addAction(exitBtn)
                
                self.present(alertView, animated: true, completion: nil)
                
                return
            }
            
            
        }
        SVProgressHUD.show(withStatus: "加载中")
        let parameters: Dictionary = ["key" : newsKey,"type":newsType]
        let manager = AFHTTPSessionManager()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","text/plain","text/html") as? Set<String>
        
        manager.post(newsUrl, parameters: parameters, progress: { (Progress) in}, success: { (task, responseObject) in
            
            print(responseObject!)
            self.tableV.mj_header.endRefreshing()
            SVProgressHUD.dismiss()
            
            let dataDic = responseObject as! NSDictionary
            
            if(dataDic["error_code"] as! NSNumber == 0){
                
                self.dataArr = NSArray(array: (dataDic["result"] as! NSDictionary)["data"] as! NSArray)
                
                self.tableV.reloadData()
                
            }
            
        }) { (task, error) in
            self.tableV.mj_header.endRefreshing()
            SVProgressHUD.dismiss()
            SVProgressHUD.showError(withStatus: "服务器错误,请稍后重试")
        }
        
        
    }
    
    
    
    
    //tableview-delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataArr == nil {
            return 0
        }
        return dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let dic : NSDictionary = dataArr[indexPath.row] as! NSDictionary
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCell1", for: indexPath) as! NewsTableViewCell
        
        if dataArr != nil {
            
            cell.dic = dic
            
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let dic : NSDictionary = dataArr[indexPath.row] as! NSDictionary
        
        self.performSegue(withIdentifier: "toNewsDetail", sender: dic["url"]);
        
    }
  
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewsDetail" {
            
            let wkvc = segue.destination as! MyWkWebViewController
            wkvc.urlStr = sender as! String
        }
    }
    
    
}
