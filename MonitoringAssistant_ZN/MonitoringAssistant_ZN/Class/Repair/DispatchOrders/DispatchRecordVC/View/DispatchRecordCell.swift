//
//  DispatchRecordCell.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let DispatchRecordCell_id = "DispatchRecordCell"


class DispatchRecordCell: UITableViewCell {
    
    var isFist = false
    var isLast = false
    
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var timeL: UILabel!
    
    @IBOutlet weak var statusL: UILabel!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var iconImg: UIImageView!
    
    @IBOutlet weak var line: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setLine(isFirst:Bool , isLast:Bool) {
        
        if (isFirst) {
            
            self.iconImg.image = UIImage.init(named: "dispatch_record_first")
            self.line.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.snp.centerY).offset(0)
                make.bottom.equalTo(self).offset(0)
            })
            self.layoutIfNeeded()
            
        }else if(isLast){
            
            self.iconImg.image = UIImage.init(named: "dispatch_record")
            
            self.line.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self).offset(0)
                make.bottom.equalTo(self).offset(0)
            })
            self.layoutIfNeeded()
            
        }else{
            
            self.iconImg.image = UIImage.init(named: "dispatch_record_last")
            
            self.line.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self).offset(0)
                make.bottom.equalTo(self.snp.centerY).offset(0)
            })
            self.layoutIfNeeded()
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
