//
//  EquipmentMonitorHeaderView.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/27.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EquipmentMonitorHeaderView: UIView {
    
    

    func setData(array:NSArray) {
        
        
        var ring1Progress : Double = 0
        var ring2Progress : Double = 0
        var ring3Progress : Double = 0
        var ring4Progress : Double = 0
        
    
        for i in 0..<array.count {
            
            let model = array[i] as! equipmentMonitorMonitorStatusModel

            let rank1 = model.code
            switch rank1{
            case "1"?:
                print("在线")
                ring1Progress = Double(model.proportion!)
                self.onlineNumL.text = model.cnt! + "个"
                self.onlineRateL.text = String(model.proportion!) + "%"
                
                self.sumCntL.text = model.sumCnt! + "个"
            case "2"?:
                print("离线")
                ring2Progress = Double(model.proportion!)
                self.offLineNumL.text = model.cnt! + "个"
                self.offLineRateL.text = String(model.proportion!) + "%"
            case "3"?:
                print("故障")
                ring3Progress = Double(model.proportion!)
                self.troubleNumL.text = model.cnt! + "个"
                self.troubleRateL.text = String(model.proportion!) + "%"
            case "9"?:
                print("停用")
                ring4Progress = Double(model.proportion!)
                self.stopNumL.text = model.cnt! + "个"
                self.stopRateL.text = String(model.proportion!) + "%"
            default:
                print("没有评级")
            }
            
        }
        
//        CATransaction.begin()
//        CATransaction.setAnimationDuration(1.0)
        self.progressGroup.setRing1_progress(value: ring1Progress / 100)  //selectedGroup.contentView.ring1.progress
        self.progressGroup.setRing2_progress(value: ring2Progress / 100)   //selectedGroup.contentView.ring2.progress
        self.progressGroup.setRing3_progress(value: ring3Progress / 100 ) //selectedGroup.contentView.ring3.progress
        self.progressGroup.setRing4_progress(value: ring4Progress / 100)  //selectedGroup.contentView.ring3.progress
//        CATransaction.commit()
    
        
        
    }
    
    
    @IBOutlet weak var sumCntL: UILabel!
    
    @IBOutlet weak var groupContainerView: UIView!
    @IBOutlet weak var progressGroup: MKRingProgressGroupView!
    
    @IBOutlet weak var exampleView1: UIView!
    @IBOutlet weak var exampleView2: UIView!
    
    @IBOutlet weak var exampleView3: UIView!
    @IBOutlet weak var exampleView4: UIView!
    
    
    @IBOutlet weak var onlineNumL: UILabel!
    
    @IBOutlet weak var onlineRateL: UILabel!
    
    @IBOutlet weak var offLineNumL: UILabel!
    
    @IBOutlet weak var offLineRateL: UILabel!
    
    @IBOutlet weak var troubleNumL: UILabel!
    
    @IBOutlet weak var troubleRateL: UILabel!
    
    @IBOutlet weak var stopNumL: UILabel!
    
    @IBOutlet weak var stopRateL: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.progressGroup.ringWidth = 12
        
        
        exampleView1.layer.cornerRadius = 8
        exampleView2.layer.cornerRadius = 8
        exampleView3.layer.cornerRadius = 8
        exampleView4.layer.cornerRadius = 8

        sumCntL.font = UIFont.boldSystemFont(ofSize: 16)
        
        
        self.progressGroup.setRing1_progress(value: 0)
        self.progressGroup.setRing2_progress(value: 0)
        self.progressGroup.setRing3_progress(value: 0)
        self.progressGroup.setRing4_progress(value: 0)
        
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
