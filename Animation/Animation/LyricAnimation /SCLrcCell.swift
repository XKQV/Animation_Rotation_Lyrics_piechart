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
    
    
}
extension UILabel {
    static var _myComputedProperty = CGFloat()
    
    var myComputedProperty:CGFloat {
        get {
            return UILabel._myComputedProperty
        }
        set(newValue) {
            UILabel._myComputedProperty = newValue
        }
    }
    
    func setProgress(progress : CGFloat) -> Void {
        myComputedProperty = progress
        
        self .setNeedsDisplay()
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        
        let fillRect = CGRect.init(x: rect.origin.x, y: rect.origin.y, width: rect.size.width*myComputedProperty, height: rect.size.height)
        self.tintColor = UIColor.yellow
        UIRectFillUsingBlendMode(fillRect, CGBlendMode.sourceIn)
    }
    
}
