//
//  EnergyFeeVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/22.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EnergyFeeVC: BaseTableVC ,EnergyTableViewCellDelegate{

    let titleArr = ["收费信息"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title  = "收费"
        
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
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EnergyTableViewCell  = tableView.dequeueReusableCell(withIdentifier: EnergyTableViewCell_id, for: indexPath) as! EnergyTableViewCell
        
        cell.index = indexPath.row
        cell.delegate = self
        cell.setuptitleAndImg(title: titleArr[indexPath.row], Img: "abcd_charge_survey")
        cell.iconImgView.image = UIImage.init(named: "收费icon")

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return ScreenW / 680.0 * 284.0 + 50
    }
    
    func BtnSelected(index: Int) {
        
        if index == 0 {
            
            let vc = FeeInfoVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            
            let vc = FeeInfoVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
    }
    
}
