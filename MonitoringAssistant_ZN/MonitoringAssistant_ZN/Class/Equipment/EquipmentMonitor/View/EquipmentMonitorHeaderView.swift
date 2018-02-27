//
//  EquipmentMonitorHeaderView.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/27.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EquipmentMonitorHeaderView: UIView {
    
    
    @IBOutlet weak var groupContainerView: UIView!
    @IBOutlet weak var progressGroup: MKRingProgressGroupView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.progressGroup.ringWidth = 15
        
        delay(0.5) {
            self.updateMainGroupProgress()
        }
        
    }
    
    private func updateMainGroupProgress() {
        //        let selectedGroup = buttons[selectedIndex]
        CATransaction.begin()
        CATransaction.setAnimationDuration(1.0)
        self.progressGroup.ring1.progress = 0.5 //selectedGroup.contentView.ring1.progress
        self.progressGroup.ring2.progress = 0.7 //selectedGroup.contentView.ring2.progress
        self.progressGroup.ring3.progress = 0.3 //selectedGroup.contentView.ring3.progress
        self.progressGroup.ring4.progress = 0.6 //selectedGroup.contentView.ring3.progress
        CATransaction.commit()
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
