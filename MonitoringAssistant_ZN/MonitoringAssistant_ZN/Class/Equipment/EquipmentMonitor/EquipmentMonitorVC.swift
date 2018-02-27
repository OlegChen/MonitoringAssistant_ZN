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
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        let headerView = UIView()
        headerView.frame = CGRect(x:0 , y : 0 , width:ScreenW , height: 394)
        
        let view = (Bundle.main.loadNibNamed("EquipmentMonitorHeaderView", owner: nil, options: nil)![0] as! EquipmentMonitorHeaderView)
        self.headView = view
        headerView.addSubview(view)
        self.tableView.tableHeaderView = headerView
        
        self.tableView.register(UINib.init(nibName:"EquipmentMonitorSectionHeaderView", bundle: nil), forHeaderFooterViewReuseIdentifier: EquipmentMonitorSectionHeaderView_id)
            
        self.tableView.register(UINib.init(nibName: "EquipmentMonitorCell" , bundle: nil), forCellReuseIdentifier: EquipmentMonitorCell_id)

       
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
        let cell = tableView.dequeueReusableCell(withIdentifier: EquipmentMonitorCell_id) as! EquipmentMonitorCell
        
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: EquipmentMonitorSectionHeaderView_id) as! EquipmentMonitorSectionHeaderView
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 77
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
      
        
    }
    
    
  
    
    
}


