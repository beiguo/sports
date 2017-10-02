//
//  ViewController.swift
//  myHealth
//
//  Created by 石庆磊 on 2017/9/10.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    var htmlString: String!
    
    var webV : WKWebView!
    var inBtn = UIButton(type: UIButtonType.custom)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createWebView()
        createInBtn()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createWebView() {
        
        self.webV = WKWebView(frame: self.view.frame)
        let path = Bundle.main.path(forResource: "inApp", ofType: "html")
        self.webV.load(URLRequest(url: URL(fileURLWithPath: path!)))
//        self.webV.
        self.view.addSubview(webV)
        
    }
    
    func createInBtn() {
        
        inBtn.frame = CGRect(x: (self.view.bounds.width*0.4)/2, y: self.view.bounds.height-150, width: self.view.bounds.width*0.6, height: 50);
        inBtn.layer.borderWidth = 2;
        inBtn.layer.cornerRadius = 25;
        inBtn.layer.borderColor = UIColor.white.cgColor;
        inBtn.setTitle("Enter", for: UIControlState.normal);
        inBtn.setTitleColor(UIColor.white, for: UIControlState.normal);
        inBtn.addTarget(self, action: #selector(ViewController.goNext), for: UIControlEvents.touchUpInside);
        inBtn.tintColor = UIColor.white;
        
        self.view.addSubview(inBtn);
    }
    
    func goNext() {
        self.performSegue(withIdentifier: "InApp", sender: nil);
    }



}

