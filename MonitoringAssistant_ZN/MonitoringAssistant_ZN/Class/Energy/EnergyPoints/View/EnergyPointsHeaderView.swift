//
//  EnergyPointsHeaderView.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let EnergyPointsHeaderView_id = "EnergyPointsHeaderView"

class EnergyPointsHeaderView: UITableViewHeaderFooterView {

    let arr = ["今日能耗","5日能耗","5日计划","5日费用","单方能耗","计划单方能耗"]
    
    
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        for i in 0..<arr.count {
            
            let label = UILabel()
            label.text = arr[i]
            label.textColor = UIColor.black
            label.font = UIFont.systemFont(ofSize: 14)
            label.textAlignment = NSTextAlignment.center
            let btnW = ((ScreenH -   (ScreenH == 812 ? 180 : 100 ) ) / 6.0)
            label.frame = CGRect(x: (ScreenH == 812 ? 130 : 80 ) + btnW * CGFloat(i), y: 0, width: btnW , height: 50)
            self.addSubview(label)
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}