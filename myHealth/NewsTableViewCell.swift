//
//  NewsTableViewCell.swift
//  myHealth
//
//  Created by shilei on 2017/9/11.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    var dic : NSDictionary!
    
    @IBOutlet weak var titleLable: UILabel!
    
    @IBOutlet weak var firstImgV: UIImageView!
    
    @IBOutlet weak var secondImgV: UIImageView!
    
    @IBOutlet weak var thirdImgV: UIImageView!
    
    @IBOutlet weak var fromLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        firstImgV.layer.masksToBounds = true;
        firstImgV.layer.cornerRadius = 3
        firstImgV.layer.borderColor = UIColor.white.cgColor
        firstImgV.layer.borderWidth = 0.5
        self.firstImgV.contentMode = .scaleToFill
        secondImgV.layer.masksToBounds = true;
        secondImgV.layer.cornerRadius = 3
        secondImgV.layer.borderColor = UIColor.white.cgColor
        secondImgV.layer.borderWidth = 0.5
        self.secondImgV.contentMode = .scaleToFill
        thirdImgV.layer.masksToBounds = true;
        thirdImgV.layer.cornerRadius = 3
        thirdImgV.layer.borderColor = UIColor.white.cgColor
        thirdImgV.layer.borderWidth = 0.5
        self.thirdImgV.contentMode = .scaleToFill
        
    }
    
    override func layoutSubviews() {
        self.titleLable.text = dic["title"] as? String;
        
        let firstImgUrl = dic["thumbnail_pic_s"] as? String
        let secoundImgUrl = dic["thumbnail_pic_s02"] as? String
        let thirdImgUrl = dic["thumbnail_pic_s03"] as? String
        if firstImgUrl != nil {
            
            self.firstImgV.kf.setImage(with: URL(string: firstImgUrl!) );
        }
        
        if secoundImgUrl != nil {
            self.secondImgV.kf.setImage(with: URL(string: secoundImgUrl!));
        }
        
        if thirdImgUrl != nil {
            
            self.secondImgV.kf.setImage(with: URL(string: thirdImgUrl!));
        }
        
        
        self.fromLable.text = dic["author_name"] as? String;
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
