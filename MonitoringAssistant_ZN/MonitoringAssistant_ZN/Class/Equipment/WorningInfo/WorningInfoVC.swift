//
//  WorningInfoVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class WorningInfoVC: BaseTableVC {

    var headView : WorningInfoHeaderView?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "告警信息"
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        let view = UIView()
        view.frame = CGRect(x:0 , y:0 , width:ScreenW  , height:733)
        
        let headView = (Bundle.main.loadNibNamed("WorningInfoHeaderView", owner: nil, options: nil)![0] as! WorningInfoHeaderView)
        headView.frame = view.bounds
        self.headView = headView
        view.addSubview(headView)
        
        self.tableView.tableHeaderView = view
        
        self.getData()
        

    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func getData() {
        

        YJProgressHUD.showProgress(nil, in: self.tableView)
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: alarmAllDataUrl, modelClass: "WorningInfoModel", response: { (obj) in
                
                let model = obj as! WorningInfoModel
                
                if(model.statusCode == 800){
                    
                    self.headView?.updateArray(array: model.returnObj?.alarmMonths! as! NSArray)
                    
                    self.headView?.yearNumL.text = String(model.returnObj?.yearCnt! as! Int)
                    self.headView?.yearRateL.text = String(model.returnObj?.yearProportion! as! Double) + "%"
                    
                    self.headView?.setTypesData(array: model.returnObj?.alarmTypes! as! NSArray)
                    
                }
                
                YJProgressHUD.hide()
                
            }, failture: { (error) in
                
                YJProgressHUD.hide()
            })
            
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        
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
