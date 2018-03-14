//
//  OrderInfoVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/18.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class OrderInfoVC: BaseVC, UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView?
    
    var headerView : OrderInfoHeaderView?
    var footerView : OrderInfoFooterView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工单信息"

        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 0, 0))
        })
        self.tableView?.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "123")
        
        
        let view1 = UIView.init()
        view1.frame = CGRect(x:0 ,y:0 , width: ScreenW , height : 320)
        self.headerView = (Bundle.main.loadNibNamed("OrderInfoHeaderView", owner: nil, options: nil)![0] as! OrderInfoHeaderView)
        view1.addSubview(self.headerView!)
        self.tableView?.tableHeaderView = view1
        
        
        let view2 = UIView.init()
        view2.frame = CGRect(x:0 ,y:0 , width: ScreenW , height : 358)
        self.footerView = Bundle.main.loadNibNamed("OrderInfoFooterView", owner: nil, options: nil)![0] as? OrderInfoFooterView
        view2.addSubview(self.footerView!)
        self.tableView?.tableFooterView = view2
        
        
        self.getDataInfo()
        
    }
    
    func getDataInfo() {
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: workOrderAllDataUrl, modelClass: "orderInfoModel", response: { (obj) in
                
                let model = obj as! orderInfoModel
                
                if model.statusCode == 800 {
                    
                    self.headerView?.setDataArray(array: model.returnObj?.sourceWorkStutVos! as! NSArray)
                    self.footerView?.setDataArray(array: model.returnObj?.statusWorkStutVos! as! NSArray)
                    
                }
                
            }, failture: { (error) in
                
                
            })
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "123")
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        cell?.backgroundColor = UIColor.init(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 20
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
