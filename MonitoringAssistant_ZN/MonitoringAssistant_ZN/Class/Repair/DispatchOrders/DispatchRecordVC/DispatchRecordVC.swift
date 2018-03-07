//
//  DispatchRecordVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/7.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class DispatchRecordVC: BaseVC ,UITableViewDelegate,UITableViewDataSource {
    
    var workNo : NSString?
    
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工单记录"
        self.view.backgroundColor = .white//RGBCOLOR(r: 240, 240, 240)
        
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 0, 0))
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.register(UINib.init(nibName: "DispatchRecordCell" , bundle: nil), forCellReuseIdentifier:DispatchRecordCell_id )
        
        self.getdata()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DispatchRecordCell_id) as? DispatchRecordCell
        
        let model = self.dataArr[indexPath.row] as! DispatchRecordListReturnObjModel
        
        
        cell?.dateL.text = model.createDate
        cell?.nameL.text = "维修师：" + model.sendEmpName!
        cell?.statusL.text = "??????"
        
        cell?.setLine(isFirst: (indexPath.row == 0 ? true : false ), isLast: (indexPath.row == (self.dataArr.count - 1) ? true : false ))
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
    }
    
    func getdata() {
        
        self.view.beginLoading()
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "workNo":self.workNo
                ] as [String : Any]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: workSendListUrl, modelClass: "DispatchRecordListModel", response: { (obj) in
                
                let model = obj as! DispatchRecordListModel
                
                if(model.statusCode == 800){
                    
                    self.dataArr.addObjects(from: model.returnObj!)
                    
                    self.tableView.reloadData()
                    
                }
                
                self.view.endLoading()
                
            }, failture: { (error) in
                
                self.view.endLoading()
            })
            
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
