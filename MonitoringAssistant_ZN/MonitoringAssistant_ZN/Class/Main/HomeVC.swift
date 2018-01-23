//
//  HomeVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class HomeVC: BaseVC ,MainBtnDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fanView = MainBtn(frame: CGRect(x: 0, y: 0, width: ScreenW - 80, height: ScreenW - 80))
        fanView.center = self.view.center
        self.view.addSubview(fanView)
        fanView.startAngle = .pi / 4.0
        fanView.angle = 2 * .pi
        fanView.subBtns = ["1", "2", "3", "4"]
        fanView.delegate = self
        
    }
    
    func clickBtn(with index: Int) {
                
        print("点击了%@",index)
        switch index {
        case 0:
            let vc = EnergyFeeVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = EnergyRepairVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = EnergyVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = EnergyEquipment()
            self.navigationController?.pushViewController(vc, animated: true)
        default: break
            
        }
        
        
    }
    
    func clickCenterBtn() {
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "SettingCenterVC") as! SettingCenterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
