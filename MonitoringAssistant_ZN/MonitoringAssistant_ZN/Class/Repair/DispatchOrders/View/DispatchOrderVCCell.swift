//
//  DispatchOrderVCCell.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let DispatchOrderVCCell_id = "DispatchOrderVCCell"


protocol DispatchOrderVCCellDelegate :class {
    func dispatchMethod(index:Int)
}

class MyClass {
}


class DispatchOrderVCCell: UITableViewCell {
    
    weak var delegate: DispatchOrderVCCellDelegate?

    var index : Int?
    
    @IBOutlet weak var dispatchBtn: UIButton!
    
    
    @IBOutlet weak var titleL: UILabel!
    
    
    @IBOutlet weak var dateL: UILabel!
    
    @IBOutlet weak var longTimeL: UILabel!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var detailL: UILabel!
    
    @IBOutlet weak var addressL: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()

        
        
        
        
    }
    
    
    @IBAction func btnClick(_ sender: UIButton) {
    
        delegate?.dispatchMethod(index: self.index!)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
