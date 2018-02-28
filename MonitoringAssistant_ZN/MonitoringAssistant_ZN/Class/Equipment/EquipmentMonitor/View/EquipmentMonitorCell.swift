//
//  EquipmentMonitorCell.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/27.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let EquipmentMonitorCell_id = "EquipmentMonitorCell"


class EquipmentMonitorCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var allNumL: UILabel!
    
    @IBOutlet weak var onLineNumL: UILabel!
    
    @IBOutlet weak var rateL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 230, 230, 230)
        self.contentView.addSubview(line)
        line.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(self.contentView.snp.top).offset(0)
            make.height.equalTo(0.5)
        }
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
