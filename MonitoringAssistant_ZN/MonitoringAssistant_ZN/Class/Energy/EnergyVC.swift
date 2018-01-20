//
//  EnergyVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EnergyVC: BaseTableVC {
    
    let titleArr = ["用能概况", "用能监测" , "黄金对标"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title  = "用能"
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UINib.init(nibName: "EnergyTableViewCell", bundle: nil), forCellReuseIdentifier: EnergyTableViewCell_id)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EnergyTableViewCell  = tableView.dequeueReusableCell(withIdentifier: EnergyTableViewCell_id, for: indexPath) as! EnergyTableViewCell

        
        
        cell.setuptitleAndImg(title: titleArr[indexPath.row], Img: "")
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 200;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            self.navigationController?.pushViewController(EnergyPointsTableViewController(), animated: true)
        }else if indexPath.row == 1 {
            
            self.navigationController?.pushViewController(EnergyMonitorVC(), animated: true)
        }else if indexPath.row == 2 {
            
            self.navigationController?.pushViewController(EnergyCompareVC(), animated: true)
        }
    }
    
}
