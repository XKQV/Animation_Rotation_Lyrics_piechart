//
//  lyricsViewController.swift
//  Animation
//
//  Created by 董志玮 on 2019/4/8.
//  Copyright © 2019 董志玮. All rights reserved.
//

import UIKit

class lyricsViewController: UIViewController {
    
    var lrcIndex = 1
    
    @IBOutlet weak var mLrcTable: SCTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mLrcTable.separatorStyle = .none                 // 去掉tableView分割线
        self.mLrcTable.showsVerticalScrollIndicator = false   // 去掉tableView垂直滚动条
        self.mLrcTable.prepareLRC(lrcPath: "309769.lrc")      // 歌词解析
        self.mLrcTable.Lrc_Index = 1;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func nextline(_ sender: Any) {
        if lrcIndex < self.mLrcTable.mTimeArray.count - 1 {
            lrcIndex  = lrcIndex + 1
            self.mLrcTable.Lrc_Index = lrcIndex
        }
    }
    
    @IBAction func preline(_ sender: Any) {
        if lrcIndex > 0 {
            lrcIndex  = lrcIndex - 1
            self.mLrcTable.Lrc_Index = lrcIndex
        }
    }
}

