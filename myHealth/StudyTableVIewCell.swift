//
//  StudyTableVIewCell.swift
//  myHealth
//
//  Created by 石庆磊 on 2017/9/10.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit

class StudyTableViewCell: UITableViewCell {
    @IBOutlet weak var rightImgV: UIImageView!
    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var imgV: UIImageView!
    
    override func awakeFromNib() {
        self.imgV.layer.borderWidth = 1
        self.imgV.layer.borderColor = UIColor.black.cgColor
        self.imgV.layer.cornerRadius = 5
        self.imgV.layer.masksToBounds = true;
        self.imgV.contentMode = .scaleToFill
    }
    
  
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder);
    }
    
}
