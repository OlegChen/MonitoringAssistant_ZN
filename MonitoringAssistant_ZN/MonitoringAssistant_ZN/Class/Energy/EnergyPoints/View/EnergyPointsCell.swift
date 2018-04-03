//
//  EnergyPointsCell.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let EnergyPointsCell_id = "EnergyPointsCell"

class EnergyPointsCell: UITableViewCell {

    

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var lable5: UILabel!
    @IBOutlet weak var label6: UILabel!
    
    @IBOutlet weak var label7: UILabel!
    
    
    func setIndex(index:Int) {
        
        switch index {
        case 0:
            self.titleL.textColor = RGBCOLOR(r: 130, 185, 205)
        case 1:
            self.titleL.textColor = RGBCOLOR(r: 233, 62, 68)
        case 2:
            self.titleL.textColor = RGBCOLOR(r: 80, 179, 182)
        case 3:
            self.titleL.textColor = RGBCOLOR(r: 255 , 130, 155)
        case 4:
            self.titleL.textColor = RGBCOLOR(r: 255, 189, 142)
        case 5:
            self.titleL.textColor = RGBCOLOR(r: 39, 39, 39)
        case 6:
            self.titleL.textColor = RGBCOLOR(r: 0, 0, 0)
        default: break
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
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

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
