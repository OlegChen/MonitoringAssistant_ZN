//
//  OrderDetailVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/25.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class OrderDetailVC: UIViewController ,UITableViewDelegate,UITableViewDataSource {

    
    var tableView : UITableView!
    
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工单详情"
        self.view.backgroundColor = RGBCOLOR(r: 240/255, 240/255, 240/255)
        
//        self.navigationItem.rightBarButtonItem =

        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 80, 0))
        }
        self.tableView.register(UINib.init(nibName: "OrderDetailCell" , bundle: nil), forCellReuseIdentifier: OrderDetailCell_id)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.frame = CGRect(x:0 , y : 0 , width:ScreenW , height: 190)
       
        let view = (Bundle.main.loadNibNamed("OrderDetailHeaderView", owner: nil, options: nil)![0] as! OrderDetailHeaderView)
        headerView.addSubview(view)
        
        self.tableView.tableHeaderView = headerView
    
        self.setupBottomBtn()
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailCell_id)
        
        return cell!
    }
    
    
    func setupBottomBtn() {
        
        let btn = UIButton()
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(self.view).offset(30)
            make.left.equalTo(self.view).offset(45)
            make.right.equalTo(self.view).offset(-45)
            make.height.equalTo(50)
        }
        btn.layer.cornerRadius = 4
        btn.backgroundColor = RGBCOLOR(r: 71, 143, 183)
        btn.setTitle("派  单", for: UIControlState.normal)
        btn.setTitleColor(.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(sureBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func sureBtnClick(btn: UIButton) {
        
//        weak var weakSelf = self // ADD THIS LINE AS WELL
//
//        UserCenter.shared.userInfo { (islogin, userInfo) in
//
//
//            let para = ["companyCode":userInfo.companyCode ,
//                        "orgCode":userInfo.orgCode ,
//                        "empNo":userInfo.empNo ,
//                        "empName":userInfo.empName,
//                        "workNo" : self.workNo,
//                        "workSendId": "0",
//                        "sendEmpNo":self.selectedWorkerModle?.empNo,
//                        "sendEmpName":self.selectedWorkerModle?.empName
//            ]
//
//            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: workSendUrl, modelClass: "BaseModel", response: { (obj) in
//
//                let model = obj as! BaseModel
//
//                if model.statusCode == 800{
//
//                    let alertView = UIAlertView(title: "提示", message: "派单成功", delegate: nil, cancelButtonTitle: "确定")
//                    alertView.show()
//
//                }else{
//
//                    let alertView = UIAlertView(title: "提示", message: "派单失败", delegate: nil, cancelButtonTitle: "确定")
//                    alertView.show()
//                }
//
//
//            }) { (error) in
//
//
//
//            }
//        }
//
        
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
