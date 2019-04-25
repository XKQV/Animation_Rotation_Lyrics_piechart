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
    @IBOutlet weak var maskLable: UILabel!
    @IBOutlet var mastlayer: CALayer!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addSubview(self.maskLable)
    }
    
    func setupDefault(){
        self.maskLable.textColor = UIColor.green
        self.maskLable.backgroundColor = UIColor.clear
        
        mastlayer = CALayer()
        mastlayer.anchorPoint = CGPoint(x: 0, y: 0.5)
//        mastlayer.position = CGPoint(0,self.bounds.height/2)
        mastlayer.bounds = mTitleLable.bounds
        mastlayer.backgroundColor = UIColor.white.cgColor
        self.maskLable.layer.mask = mastlayer
        
    }
    func startLyricsAnimationWithTimeArray(timeArray : NSArray, locationArray : NSArray) -> Void {
        
        let totalDuration = timeArray.lastObject as! Float
        let animation = CAKeyframeAnimation(keyPath: "bounds.size.width")
        let keyTimeArray = NSMutableArray()
        let widthArray = NSMutableArray()
//        for i in timeArray {
//            let tempTime =  (i as AnyObject).floatValue / totalDuration
//            keyTimeArray.add(tempTime)
//
//            widthArray.add(temWidth)
//
//        }
        
        
    }

}
