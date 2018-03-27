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
        
        CheckVerson.checkVersion(withVC: self)
        
        // 如果需要设置导航栏底部分割线隐藏，可以在这里统一设置
        WRNavigationBar.defaultShadowImageHidden = true
        
        
        let imgView = UIImageView(frame:self.view.bounds)
        imgView.image = UIImage.init(named: "home_back")
        imgView.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(imgView, at: 0)

        
        let fanView = MainBtn(frame: CGRect(x: 0, y: 0, width: ScreenW - 80, height: ScreenW - 80))
        self.view.addSubview(fanView)
        fanView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.view).offset(35)
            make.centerX.equalTo(self.view)
            make.width.equalTo(ScreenW - 80)
            make.height.equalTo(ScreenW - 80)
        }
//        fanView.pressSubBtnColor = UIColor.red
        fanView.startAngle = .pi / 4.0
        fanView.angle = 2 * .pi
        fanView.subBtns = ["收费", "报修", "用能", "设备"]
        fanView.delegate = self
        
        
        
        let logoView = UIImageView()
        logoView.image = UIImage.init(named: "home_text")
        logoView.contentMode = UIViewContentMode.scaleAspectFit
        logoView.layer.shadowColor = UIColor.darkGray.cgColor;
        logoView.layer.shadowOffset = CGSize(width:2, height:2);
        logoView.layer.shadowOpacity = 0.7;
        logoView.layer.shadowRadius = 5;
        self.view.addSubview(logoView)
        logoView.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(fanView.snp.top).offset(-50)
            make.width.equalTo(300);
            make.height.equalTo(65);
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
