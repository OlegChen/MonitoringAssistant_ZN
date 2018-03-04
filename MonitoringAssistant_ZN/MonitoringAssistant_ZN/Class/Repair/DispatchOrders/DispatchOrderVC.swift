//
//  DispatchOrderVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class DispatchOrderVC: BaseVC,UITableViewDelegate,UITableViewDataSource,DispatchOrderVCCellDelegate {

    var tableView : UITableView!
    
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "转派工单"
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 0, 0))
        }
        self.tableView.register(UINib.init(nibName: "DispatchOrderVCCell", bundle: nil), forCellReuseIdentifier: DispatchOrderVCCell_id)
        self.tableView.backgroundColor = UIColor.init(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getData()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DispatchOrderVCCell_id) as! DispatchOrderVCCell
        
        let model = self.dataArr[indexPath.row] as! DispatchOrderReturnObjModel
        
        cell.index = indexPath.section
        
        cell.titleL.text = model.workClass! + " | " + model.workName!
        cell.dateL.text = "报修时间：" + model.createDateStr!
        cell.longTimeL.text = "报修时长：" + model.repairsTime!
        cell.nameL.text = "接单人：" + model.sendEmpName!
        cell.detailL.text = model.dealDesc
        cell.addressL.text = model.address
        
        cell.delegate = self
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 15
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dataArr[indexPath.row] as! DispatchOrderReturnObjModel

        let vc = OrderDetailVC()
        vc.workNo = model.workNo
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getData() {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ]
            
            self.view.beginLoading()
          
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: workSendPageUrl, modelClass: "DispatchOrderModel" , response: { (obj) in
                
                let model = obj as! DispatchOrderModel
                
                if model.statusCode == 800 {
                    
  
                    
                    if((model.returnObj?.count)! > 0){
                        
                        self.dataArr.addObjects(from: model.returnObj!)
                        self.tableView.reloadData()
                        
                    }else{
                        
                        self.tableView.configBlankPage(EaseBlankPageType(rawValue: 0)!, hasData: false, hasError: false, reloadButtonBlock: nil)
                    }
                    
                    
                }
                
                self.view.endLoading()
                
            }, failture: { (error) in
                
                self.view.endLoading()
                
            })
            
            
        }
        
        
        
    }
    
    func dispatchMethod(index: Int) {
        
        let model = self.dataArr[index] as! DispatchOrderReturnObjModel

        let vc = SelectWorkerVCViewController()
        vc.lat = model.latitude
        vc.lon = model.longitude
        vc.workNo = model.workNo
        self.navigationController?.pushViewController(vc, animated: true)
        
        
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
