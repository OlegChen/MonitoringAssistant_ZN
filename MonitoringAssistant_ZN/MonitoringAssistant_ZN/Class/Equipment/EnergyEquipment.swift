//
//  EnergyEquipment.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EnergyEquipment: BaseTableVC ,EnergyTableViewCellDelegate{
    let titleArr = ["设备监控", "告警信息" ]
    let iconArr = [ "设备监控icon","告警icon"]

    let imgArr = ["abcd_equipment_monitor","abcd_alarm_managem"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title  = "设备"
        
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
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EnergyTableViewCell  = tableView.dequeueReusableCell(withIdentifier: EnergyTableViewCell_id, for: indexPath) as! EnergyTableViewCell
        
        
        cell.index = indexPath.row
        cell.delegate = self
        cell.setuptitleAndImg(title: titleArr[indexPath.row], Img: imgArr[indexPath.row])
        cell.iconImgView.image = UIImage.init(named: self.iconArr[indexPath.row])

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ScreenW / 680.0 * 284.0 + 50

    }
    
    func BtnSelected(index: Int) {
        
        if index == 0 {
            
            self.navigationController?.pushViewController(EquipmentMonitorVC(), animated: true)
            
        }else if index == 1 {
            
            self.navigationController?.pushViewController(WorningInfoVC(), animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            self.navigationController?.pushViewController(EquipmentMonitorVC(), animated: true)
            
        }else if indexPath.row == 1 {
            
            self.navigationController?.pushViewController(WorningInfoVC(), animated: true)
        }
        
    }
    
}
