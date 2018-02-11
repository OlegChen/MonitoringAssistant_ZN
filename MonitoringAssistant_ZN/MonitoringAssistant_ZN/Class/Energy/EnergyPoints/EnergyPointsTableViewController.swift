//
//  EnergyPointsTableViewController.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import SnapKit

class EnergyPointsTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "用能概况"


        let custnav = UIView.init(frame: CGRect(x:0 ,y: 0 , width: ScreenH , height:64))
        custnav.backgroundColor = UIColor.red
        self.view.addSubview(custnav)
        
        let backBtn = UIButton.init()
        backBtn.setImage(UIImage.init(named: "backItem"), for: UIControlState.normal)
        custnav.addSubview(backBtn)
        backBtn.addTarget(self, action:#selector(backBtnClick) , for: UIControlEvents.touchUpInside)
        backBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(custnav).offset(20)
            make.top.equalTo(custnav).offset(20)
            make.height.equalTo(44)
            make.width.equalTo(55)
        }
        
        
        let title = UILabel.init()
        title.text = "用能概况"
        title.font=UIFont.boldSystemFont(ofSize:17)//调整文字为加粗类型
        custnav.addSubview(title)
        title.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(custnav)
            make.centerY.equalTo(custnav).offset(10)

        }
        
        appDelegate.blockRotation = true
        
        self.tableView = UITableView()
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.frame = CGRect(x:0 ,y:64 , width: ScreenH , height :ScreenW - 64)
        self.tableView.register(UINib.init(nibName: "EnergyPointsCell", bundle: nil), forCellReuseIdentifier: EnergyPointsCell_id)
        self.tableView.register(EnergyPointsHeaderView.self, forHeaderFooterViewReuseIdentifier: EnergyPointsHeaderView_id)
        
        self.tableView.tableFooterView = UIView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        

    }

    override func viewWillDisappear(_ animated: Bool) {
        
        appDelegate.blockRotation = false
        
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)

    }
    
    
    override var prefersStatusBarHidden: Bool {
        return false
        
    }
    
    @objc func backBtnClick() {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EnergyPointsCell_id, for: indexPath)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EnergyPointsHeaderView_id)
        
        return header
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 50
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
