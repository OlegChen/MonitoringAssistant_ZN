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

    let arr = ["今日能耗","日计划值","今日费用","累计用能计划","累计能耗","单方能耗","累计费用"]
    
    
    
    override init(reuseIdentifier: String?) {
        
        super.init(reuseIdentifier: reuseIdentifier)
        
        for i in 0..<arr.count {
            
            let label = UILabel()
            label.text = arr[i]
            label.textColor = UIColor.black
            label.font = UIFont.boldSystemFont(ofSize: 11)
            label.textAlignment = NSTextAlignment.right
            let btnW = ((ScreenH -   (ScreenH == 812 ? 180 : 100 ) ) / 7.0)
            label.frame = CGRect(x: (ScreenH == 812 ? 130 : 80 ) + btnW * CGFloat(i), y: 0, width: btnW , height: 40)
            self.addSubview(label)
            
        }
        
        self.contentView.backgroundColor = UIColor.white
     
        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 210, 210, 210)
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(self).offset(0)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.height.equalTo(0.5)
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
