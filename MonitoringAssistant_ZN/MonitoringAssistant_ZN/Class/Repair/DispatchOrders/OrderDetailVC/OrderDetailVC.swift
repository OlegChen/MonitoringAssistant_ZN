//
//  OrderDetailVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/25.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class OrderDetailVC: BaseVC ,UITableViewDelegate,UITableViewDataSource {

    
    var tableView : UITableView!
    
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工单详情"
        self.view.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "派单记录", target: self, action: #selector(toDispatchOrderListVC))

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
        self.getdata()
    
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
            
            make.top.equalTo(self.tableView.snp.bottom).offset(20)
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
        
//        let vc = SelectWorkerVCViewController()
//        vc.lat = model.latitude
//        vc.lon = model.longitude
//        vc.workNo = model.workNo
//        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func toDispatchOrderListVC() {
        
        
        
        
    }
    
    
    func getdata() {
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName
            ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: workOrderDetailUrl, modelClass: "", response: { (obj) in
                
//                let model = obj as! EnergyPointsModel
//
//                self.dataArr.addObjects(from: model.returnObj!)
//                self.tableView.reloadData()
                
            }) { (error) in
                
            }
            
        }
        
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
