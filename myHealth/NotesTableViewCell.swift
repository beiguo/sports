//
//  NotesTableViewCell.swift
//  myHealth
//
//  Created by shilei on 2017/9/13.
//  Copyright © 2017年 石庆磊. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var stepL: UILabel!
    
    @IBOutlet weak var distanceL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
