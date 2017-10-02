//
//  TabbarController.swift
//  myHealth
//
//  Created by shilei on 2017/9/13.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit

class TabbarController: UITabBarController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        UITabBar.appearance() = UIColor.red
        UITabBar.appearance().tintColor = UIColor.black
//        self.view.backgroundColor = UIColor.black
//        self.tabBar.isTranslucent = true
        //        self.tabBar.backgroundColor = UIColor.black
        var items : [UITabBarItem] = self.tabBar.items!
        let tabbar0SelectedImage = UIImage(named: "bike")
        let tabbar1SelectedImage = UIImage(named: "study")
        let tabbar2SelectedImage = UIImage(named: "news")
        items[0].selectedImage = tabbar0SelectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        items[1].selectedImage = tabbar1SelectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        items[2].selectedImage = tabbar2SelectedImage?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
    }
    
}
