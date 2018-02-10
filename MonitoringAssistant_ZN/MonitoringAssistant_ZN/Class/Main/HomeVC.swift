//
//  HomeVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/15.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import SnapKit

class HomeVC: BaseVC ,MainBtnDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navBarBackgroundAlpha = 0.0
        navBarShadowImageHidden = true;
        
        // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
        WRNavigationBar.defaultShadowImageHidden = true
        
        
        let imgView = UIImageView(frame:self.view.bounds)
        imgView.image = UIImage.init(named: "home_back")
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(imgView, at: 0)

        
        let fanView = MainBtn(frame: CGRect(x: 0, y: 0, width: ScreenW - 80, height: ScreenW - 80))
        fanView.center = self.view.center
        self.view.addSubview(fanView)
//        fanView.pressSubBtnColor = UIColor.red
        fanView.startAngle = .pi / 4.0
        fanView.angle = 2 * .pi
        fanView.subBtns = ["1", "2", "3", "4"]
        fanView.delegate = self
        
        
        
        let logoView = UIImageView()
        logoView.image = UIImage.init(named: "home_text")
        logoView.contentMode = UIViewContentMode.center
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(fanView.snp.top).offset(-20)
            make.width.equalTo(300);
            make.height.equalTo(45);
            make.centerX.equalTo(self.view)
        }
        
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
