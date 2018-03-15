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
        
        self.title = "派单记录"
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
        
        let dateStr = self.timeStampToString(timeStamp: model.createDate!)
        
        cell?.dateL.text = dateStr.substring(to: dateStr.index(dateStr.startIndex, offsetBy:11))
        cell?.timeL.text = dateStr.substring(from: dateStr.index(dateStr.startIndex, offsetBy: 11))
        cell?.nameL.text = "维修师：" + model.sendEmpName!
        
        var statusStr = ""
        let str = model.type!
        switch str {
        case "1":
            statusStr = "派单"
        case "2":
            statusStr = "改派"
        case "3":
            statusStr = "抢单"
        default:
            break
        }
        
        let Str2 = model.stauts!
        switch Str2 {
        case "1":
            statusStr =  statusStr + "派单/抢单"
        case "2":
            statusStr = statusStr + "接收"
        case "3":
            statusStr = statusStr + "到场"
        case "4":
            statusStr = statusStr + "完成"
        case "8":
            statusStr = statusStr + "取消"
        case "9":
            statusStr = statusStr + "改派"
        default:
            break
        }
        
        cell?.statusL.text = statusStr
        
        cell?.setLine(isFirst: (indexPath.row == 0 ? true : false ), isLast: (indexPath.row == (self.dataArr.count - 1) ? true : false ))
        
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
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

    
    func timeStampToString(timeStamp:String)->String {
        
//        let string = NSString(string: timeStamp)
        
        let timestampDoubleInSec:Double = Double(timeStamp)!/1000
        
//        let timeSta:TimeInterval = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat="yyyy年MM月dd日 HH:mm"
        
        let date = NSDate(timeIntervalSince1970:  TimeInterval(timestampDoubleInSec))
        
        print(dfmatter.string(from: date as Date))
        return dfmatter.string(from: date as Date)
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
