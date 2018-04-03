//
//  EnergyPointsTableViewController.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import SnapKit
import ESPullToRefresh

class EnergyPointsTableViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var tableView : UITableView!
    
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.title = "用能概况"
        
        self.fd_interactivePopDisabled = true


        let custnav = UIView.init(frame: CGRect(x:0 ,y: 0 , width: ScreenH , height:64))
        custnav.backgroundColor = UIColor.init(red: 71/255.0, green: 143/255.0, blue: 183/255.0, alpha: 1.0)
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
        title.textColor = UIColor.white
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
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UINib.init(nibName: "EnergyPointsCell", bundle: nil), forCellReuseIdentifier: EnergyPointsCell_id)
        self.tableView.register(EnergyPointsHeaderView.self, forHeaderFooterViewReuseIdentifier: EnergyPointsHeaderView_id)
        
        self.tableView.tableFooterView = UIView()
        
//        self.view.beginLoading()
        
        self.getdata()
        
        
        self.tableView.es.addPullToRefresh {
            
            [weak self] in
            
            self?.getdata()
            
        }
        
        self.tableView.es.startPullToRefresh()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.fd_prefersNavigationBarHidden = true
        
        UIApplication.shared.statusBarStyle = .lightContent
        
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        
        return .lightContent
        
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
        return self.dataArr.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EnergyPointsCell = tableView.dequeueReusableCell(withIdentifier: EnergyPointsCell_id, for: indexPath) as! EnergyPointsCell
        
        let model : EnergyPointsReturnObjModel = self.dataArr[indexPath.row] as! EnergyPointsReturnObjModel
        
        cell.setIndex(index: indexPath.row)
        
        cell.titleL.text = model.energyTypeName
        cell.label1.text = model.todayEnergy != nil ? model.todayEnergy : "--"
        
        cell.label2.text = model.todayPlanValue != nil ? model.totalPlanValue : "--"
        cell.label3.text = model.todayFee != nil ? model.todayFee : "--"
        cell.label4.text = model.totalPlanValue != nil ? model.totalPlanValue : "--"
        cell.lable5.text = model.totalEnergy != nil ? model.totalEnergy : "--"
        cell.label6.text = model.unilEnergy != nil ?  model.unilEnergy : "--"
        cell.label7.text = model.totalFee != nil ? model.totalFee : "--"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EnergyPointsHeaderView_id)
        return header
    }
 
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 35
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    
    func getdata() {
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: profilesDataUrl, modelClass: "EnergyPointsModel", response: { (obj) in
                
                let model = obj as! EnergyPointsModel
                
                if(model.statusCode == 800){
                    
                    self.dataArr.removeAllObjects()
                    
                    self.dataArr.addObjects(from: model.returnObj!)
                    self.tableView.reloadData()
                }else{
                    
                    YJProgressHUD.showMessage(model.msg, in: UIApplication.shared.keyWindow, afterDelayTime: 2)
                }
                
                self.view.endLoading()
                
                self.tableView.es.stopPullToRefresh()
                
            }) { (error) in
                
                self.view.endLoading()
                self.tableView.es.stopPullToRefresh()
            }
            
        }
        

        
        
        
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
