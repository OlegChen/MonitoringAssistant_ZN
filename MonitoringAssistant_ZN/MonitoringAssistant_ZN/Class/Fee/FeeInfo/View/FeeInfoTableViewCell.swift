//
//  FeeInfoTableViewCell.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/13.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let FeeInfoTableViewCell_id = "FeeInfoTableViewCell"

class FeeInfoTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var feeL: UILabel!
    
    @IBOutlet weak var percentL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
