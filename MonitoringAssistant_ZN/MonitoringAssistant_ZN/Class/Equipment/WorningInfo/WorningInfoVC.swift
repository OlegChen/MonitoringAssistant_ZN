//
//  WorningInfoVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class WorningInfoVC: BaseVC,UITableViewDelegate,UITableViewDataSource {

    var headView : WorningInfoHeaderView?
    
    var tableView : UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "告警信息"
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = RGBCOLOR(r: 242, 242, 242)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 0, 0))
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        let view = UIView()
        view.frame = CGRect(x:0 , y:0 , width:ScreenW  , height:733)
        
        let headView = (Bundle.main.loadNibNamed("WorningInfoHeaderView", owner: nil, options: nil)![0] as! WorningInfoHeaderView)
        headView.frame = view.bounds
        self.headView = headView
        view.addSubview(headView)
        
        self.tableView.tableHeaderView = view
        
        YJProgressHUD.showProgress(nil, in: self.tableView)
        self.getData()
        
        self.tableView.es.addPullToRefresh {
            
            [weak self] in
            self?.getData()
            
        }
        

    }
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
    
    func getData() {
        
        
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
                
                self.tableView.es.stopPullToRefresh()
                
            }, failture: { (error) in
                
                YJProgressHUD.hide()
                self.tableView.es.stopPullToRefresh()
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
