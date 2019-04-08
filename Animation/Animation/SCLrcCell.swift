//
//  SCLrcCell.swift
//  Animation
//
//  Created by 董志玮 on 2019/4/8.
//  Copyright © 2019 董志玮. All rights reserved.
//

import UIKit

class SCLrcCell: UITableViewCell {
    // 这个是storyboard拉的label的outlet
    
    @IBOutlet weak var mTitleLable: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
