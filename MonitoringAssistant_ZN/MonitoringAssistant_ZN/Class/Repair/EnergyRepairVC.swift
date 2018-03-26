//
//  EnergyRepairVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EnergyRepairVC: BaseTableVC ,EnergyTableViewCellDelegate{

    let titleArr = ["工单信息", "转派工单" , "轨迹回放"]
    let iconArr = [ "工单信息icon","派转工单icon","黄金对标icon"]

    let imgArr = ["abcd_work_order_details", "abcd_equipment_monitor" , "abcd_trajectory_play"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title  = "报修"
        
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
        
        
        cell.index = indexPath.row
        cell.delegate = self
        cell.setuptitleAndImg(title: titleArr[indexPath.row], Img: self.imgArr[indexPath.row])
        cell.iconImgView.image = UIImage.init(named: self.iconArr[indexPath.row])

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ScreenW / 680.0 * 284.0 + 50
    }
    
    func BtnSelected(index: Int) {
        
        if index == 0 {
            
            self.navigationController?.pushViewController(OrderInfoVC(), animated: true)
            
        }else if index == 1 {
            
            self.navigationController?.pushViewController(DispatchOrderVC(), animated: true)
            
        }else if index == 2 {
            
            self.navigationController?.pushViewController(TrackPlayBackVC(), animated: true)
            
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            self.navigationController?.pushViewController(OrderInfoVC(), animated: true)
            
        }else if indexPath.row == 1 {
            
            self.navigationController?.pushViewController(DispatchOrderVC(), animated: true)

        }else if indexPath.row == 2 {
            
            self.navigationController?.pushViewController(TrackPlayBackVC(), animated: true)

            
        }
        
    }
    
}
