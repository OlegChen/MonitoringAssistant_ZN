//
//  EquipmentMonitorVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EquipmentMonitorVC: BaseVC,UITableViewDelegate,UITableViewDataSource{
    
    
    var tableView : UITableView!
    
    var headView : EquipmentMonitorHeaderView?
    
    lazy var statusDataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    lazy var classDataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
//    var buttons = [MKRingProgressGroupButton]()
//    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "设备监控"
   
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 0, 0))
        }
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let headerView = UIView()
        headerView.frame = CGRect(x:0 , y : 0 , width:ScreenW , height: 150 + (ScreenW - 68*2))
        
        let view = (Bundle.main.loadNibNamed("EquipmentMonitorHeaderView", owner: nil, options: nil)![0] as! EquipmentMonitorHeaderView)
        self.headView = view
        headerView.addSubview(view)
        view.frame = headerView.bounds
        self.tableView.tableHeaderView = headerView
        
        self.tableView.register(UINib.init(nibName:"EquipmentMonitorSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: EquipmentMonitorSectionHeaderView_id)
            
        self.tableView.register(UINib.init(nibName: "EquipmentMonitorCell" , bundle: nil), forCellReuseIdentifier: EquipmentMonitorCell_id)

       self.getData()
        
        self.tableView.es.addPullToRefresh {
            
            [weak self] in
            self?.getData()
            
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.classDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
        let cell = tableView.dequeueReusableCell(withIdentifier: EquipmentMonitorCell_id) as! EquipmentMonitorCell
        
        let model = self.classDataArr[indexPath.row] as! equipmentMonitorMonitorClassModel
        
        cell.titleL.text = model.name
        cell.allNumL.text = model.sumCnt! + "个"
        cell.onLineNumL.text = model.cnt! + "个"
        cell.rateL.text = String(model.proportion!) + "%"
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: EquipmentMonitorSectionHeaderView_id) as! EquipmentMonitorSectionHeaderView
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 77
    }
    
    
    func getData() {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName
            ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: monitorAllDataUrl, modelClass:  "equipmentMonitorModel" , response: { (obj) in
                
                let model = obj as! equipmentMonitorModel
                
                if (model.statusCode == 800){
                    
                    self.statusDataArr.removeAllObjects()
                    self.classDataArr.removeAllObjects()
                    
                    self.statusDataArr.addObjects(from: (model.returnObj?.monitorStatus)!)
                    self.classDataArr.addObjects(from: (model.returnObj?.monitorClass)! )
                    
                    
                    self.headView?.setData(array: self.statusDataArr)
                    
                    self.tableView.reloadData()
                }
                
               self.tableView.es.stopPullToRefresh()
                
            }) { (error) in
                
                self.tableView.es.stopPullToRefresh()
                
            }
            
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        
    }
    
    
  
    
    
}


