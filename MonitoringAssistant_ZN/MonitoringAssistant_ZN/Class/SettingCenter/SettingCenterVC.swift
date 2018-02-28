//
//  SettingCenterVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class SettingCenterVC: BaseTableVC {
    
    @IBOutlet weak var headImg: UIImageView!
    
    @IBOutlet weak var nameL: UILabel!
    
    @IBOutlet weak var TelL: UILabel!
    
    @IBOutlet weak var loginOutBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "配置中心"
        
        self.view.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        loginOutBtn.layer.cornerRadius = 4

        self.getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 3 : 2
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            if(indexPath.row == 0){
                
                self.navigationController?.pushViewController(ChangePwVC(), animated: true)
            }else{
                
                self.navigationController?.pushViewController(AboutUsVC(), animated: true)

            }
            
            
        }
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    func getData() {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName
            ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: getUserUrl, modelClass: "LoginModel" , response: { (obj) in
                
                let model = obj as! LoginModel
                
                if (model.statusCode == 800){
                    
                    self.headImg.kf.setImage(with: URL.init(string: (model.returnObj?.headUrl)!))
                    self.nameL.text = model.returnObj?.empName
                    self.TelL.text = model.returnObj?.mobile
                }
                
                
                
            }) { (error) in
                
            }
            
        }
        
    }


    
    @IBAction func loginOutClick(_ sender: UIButton) {
        
        UserCenter.shared.logOut()
        
        let vc = LoginVC.getLoginVC()
        UIApplication.shared.keyWindow?.rootViewController = vc
    }
    

}
