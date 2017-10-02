//
//  MyWkWebViewController.swift
//  myHealth
//
//  Created by shilei on 2017/9/11.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit
import WebKit

class MyWkWebViewController: UIViewController , WKUIDelegate , WKNavigationDelegate , WKScriptMessageHandler {
    
    var webview : WKWebView!
    var urlStr : String!
    var proView : UIProgressView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true;
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.isHidden = false;
        
        webview.removeObserver(self, forKeyPath: "estimatedProgress")
        
        webview.removeObserver(self, forKeyPath: "title")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProView()
        createWebview()
        
    }
    
    func createProView() {
        proView = UIProgressView(frame: CGRect(x: 0, y: 64, width: self.view.bounds.width, height: 2));
        proView.alpha = 0;
        self.view.addSubview(proView);
    }

    func createWebview() {
        let config = WKWebViewConfiguration();
        config.preferences = WKPreferences();
        config.preferences.minimumFontSize = 10 ;
        config.preferences.javaScriptEnabled = true;
        config.preferences.javaScriptCanOpenWindowsAutomatically = false;
        config.processPool = WKProcessPool();
        config.userContentController = WKUserContentController()
        
        webview = WKWebView(frame: CGRect(x: 0, y: 66, width: self.view.bounds.width, height: self.view.bounds.height), configuration: config);
        self.view.addSubview(webview);
        let request = URLRequest(url: URL(string: urlStr)!);
        self.webview.load(request);
        webview.uiDelegate = self;
        webview.navigationDelegate = self;
        webview.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil);
        webview.addObserver(self, forKeyPath: "title", options: NSKeyValueObservingOptions.new, context: nil);
    }
    
    //WKNavigationDelegate 的代理
    
    //一、追踪加载过程
    //1.页面开始时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("start");
    }
    //2.内容开始返回时调用
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("commit");
    }
    
    //3.页面加载完成之后时调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish");
    }
    
    //4.页面加载失败时调用
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error);
    }


    //    webview 的缓冲进度监控
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            
            proView.alpha = 1
            
            proView.setProgress(Float(CGFloat(webview.estimatedProgress)), animated: true);
            if (Float(webview.estimatedProgress) >= 1.0 ){
                
                UIView.animate(withDuration: 0.5, animations: { 
                    self.proView.alpha = 0
                })
                
            }
        }else if keyPath == "title" {
        
            self.title = webview.title;
            
        }
        
    }
    
    //WKScriptMessageHandler-delegate js与ios的交互的主要方法
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
    }

    
}
