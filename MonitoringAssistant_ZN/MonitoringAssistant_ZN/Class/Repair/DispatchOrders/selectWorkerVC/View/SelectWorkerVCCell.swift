//
//  SelectWorkerVCCell.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/23.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let SelectWorkerVCCell_id = "SelectWorkerVCCell"

class SelectWorkerVCCell: UITableViewCell {
    
    @IBOutlet weak var selectBtn: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        for i in 0..<6 {
            
            let line = UIView()
            self.addSubview(line)
            line.snp.makeConstraints({ (make) in
                
                let width = (ScreenW - 30 - 45) / 4
                make.left.equalTo(self).offset(15 + (i < 2 ? (Double( i ) *  Double( 45)): (45 + Double( i - 1) *  Double( width )))  )
                make.top.equalTo(self).offset(0)
                make.bottom.equalTo(self).offset(0)
                make.width.equalTo(0.5)
                
            })
            
            line.backgroundColor = UIColor.init(red: 208/255 , green: 220/255, blue: 230/255 , alpha: 1.0)
            
            
        }
        
        let line1 = UIView()
        self.addSubview(line1)
        line1.snp.makeConstraints({ (make) in
            
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(0)
            make.height.equalTo(0.5)
            
        })
        
        line1.backgroundColor = UIColor.init(red: 208/255 , green: 220/255, blue: 230/255 , alpha: 1.0)
        
        
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
