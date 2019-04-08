//
//  SCTableView.swift
//  Animation
//
//  Created by 董志玮 on 2019/4/8.
//  Copyright © 2019 董志玮. All rights reserved.
//

import UIKit

class SCTableView: UITableView,UITableViewDelegate, UITableViewDataSource{
    
    
    var mLRCDictinary = [String : String]()
    var mTimeArray = [String]()
    var mIsLRCPrepared : Bool = false
    
    var currentCell : SCLrcCell?
    
    var lrcOldCell : SCLrcCell?
    
    var old_Index : Int = 0
        
 
    // 设置歌词index，显示哪一行
    var Lrc_Index : Int = 0 {
        
        didSet{
            
            if Lrc_Index == oldValue {
                return
            }
            // 滚动到指定index的位置
            // 新的indexPath
            let indexPath = NSIndexPath(row: Lrc_Index, section: 0  )
            self.scrollToRow(at: indexPath as IndexPath, at: .middle, animated: true)
            currentCell = self.cellForRow(at: indexPath as IndexPath) as? SCLrcCell
            currentCell?.mTitleLable.textColor = UIColor.red
            // 旧的indexPath
            let oldIndexpath = NSIndexPath(row: oldValue, section: 0)
            let oldCell = self.cellForRow(at: oldIndexpath as IndexPath) as? SCLrcCell
            currentCell?.addAnimation(animationType: .scaleAlways)
            oldCell?.addAnimation(animationType: .scaleNormal)
            oldCell?.mTitleLable.textColor = UIColor.black
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        self.delegate = self
        
        
    }
    
    //MARK: -  解析歌词
    func prepareLRC(lrcPath:String) {
        //从资源中导入 lrc
        let url = Bundle.main.url(forResource: lrcPath, withExtension: nil)
        
        var contentStr = ""
        do{
            contentStr = try String(contentsOf: url!)
        }catch{
            
            print(error)
            
        }
        
        let lrcArray = contentStr.components(separatedBy: "\n")
        
        self.mLRCDictinary = [String : String]()
        self.mTimeArray = [String]()
        
        for line in lrcArray {
            
            // 首先处理歌词中无用的东西
            // [ti:][ar:][al:]这类的直接跳过
            if line.contains("[0") || line.contains("[1") || line.contains("[2") || line.contains("[3") {
                
                var lineArr = line.components(separatedBy:"]")
                let str1 = (line as NSString).substring(with: NSRange(location: 3,length: 1))
                let str2 = (line as NSString).substring(with: NSRange(location: 6,length: 1))
                if str1 == ":" && str2 == "." {
                    let lrcStr = lineArr[1]
                    let timeStr = (lineArr[0] as NSString).substring(with: NSRange(location: 1, length: 5))
                    self.mLRCDictinary[timeStr] = lrcStr
                    self.mTimeArray.append(timeStr)
                    
                }
            } else {
                continue
            }
            
        }
        
        self.mIsLRCPrepared = true
        self.reloadData()
    }
    

    
    
    //MARK: - Table Delegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mTimeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IrcCell") as! SCLrcCell
        
        cell.mTitleLable.text = self.mLRCDictinary[self.mTimeArray[indexPath.row]]
        
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        cell.mTitleLable.numberOfLines = 0
        cell.mTitleLable.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.mTitleLable.sizeToFit()
        
        
        return cell
    }

}


    
 
    

    

