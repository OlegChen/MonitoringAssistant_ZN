//
//  SelectWorkerVCViewController.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/23.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class SelectWorkerVCViewController: BaseVC,UITableViewDelegate,UITableViewDataSource ,UIAlertViewDelegate{

    var lat : String?
    var lon : String?
    var workNo : String?
    
    //派单 还是转派
    var workSendId : String?
    
    var selectedWorkerModle : SelectWorkerReturnObjModel?
    
    
    var tableView : UITableView!
    
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "选派工人"

        self.view.backgroundColor = .white
        
        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 80, 0))
        }
        self.tableView.register(UINib.init(nibName: "SelectWorkerVCCell" , bundle: nil), forCellReuseIdentifier: SelectWorkerVCCell_id)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
      
        
        
        self.getData()
        
        self.setupSureBtn()
        
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectWorkerVCCell_id) as! SelectWorkerVCCell
        
        let model = self.dataArr[indexPath.row] as! SelectWorkerReturnObjModel
        
        cell.label1.text = model.empName
        cell.label2.text = model.compCnt
        cell.label3.text = model.waitCnt
        cell.label4.text = model.distance! + "km"
        
        cell.selectBtn.isSelected = model.isSelected

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        for i in 0..<self.dataArr.count {
            
            let model = self.dataArr[i] as! SelectWorkerReturnObjModel

            model.isSelected = (i == indexPath.row ? true : false)
            
            if(i == indexPath.row){self.selectedWorkerModle = model }
            
        }
        self.tableView.reloadData()
        
    }
    
    func getData() {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "workNo" : self.workNo,
                        "longitude": self.lon,
                        "latitude":self.lat
            ]
            
            self.view.beginLoading()
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: sendEmpListUrl, modelClass: "SelectWorkerModel", response: { (obj) in
                
                self.view.endLoading()
                
                let model = obj as! SelectWorkerModel
                
                if model.statusCode == 800 {
                    
                    if ((model.returnObj?.count)! > 0){
                        
                        self.setupTableViewHeaderView()
                        
                        self.dataArr.addObjects(from: model.returnObj!)
                        self.tableView.reloadData()
                        
                    }else{
                        
                        self.tableView.configBlankPage(EaseBlankPageType(rawValue: 0)!, hasData: false, hasError: false, reloadButtonBlock: nil)
                    }
                    
                
                }else{
                    
                     self.tableView.configBlankPage(EaseBlankPageType(rawValue: 0)!, hasData: false, hasError: true, reloadButtonBlock: nil)
                    
                }
                
                
            }, failture: { (error) in
                
                self.view.endLoading()
               
                
            })
            
            
        }
        
    }
    
    
    func setupSureBtn() {
        
        let btn = UIButton()
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-30)
            make.bottom.equalTo(self.view).offset(-20)
            make.height.equalTo(45)
        }
        btn.layer.cornerRadius = 4
        btn.backgroundColor = RGBCOLOR(r: 71, 143, 183)
        btn.setTitle("派  单", for: UIControlState.normal)
        btn.setTitleColor(.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(sureBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
        
    }
    
    @objc func sureBtnClick(btn: UIButton) {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "workNo" : self.workNo,
                        "workSendId": self.workSendId,
                        "sendEmpNo":self.selectedWorkerModle?.empNo,
                        "sendEmpName":self.selectedWorkerModle?.empName
            ]
            NetworkService.networkPostrequest(parameters: para as! [String : String], requestApi: workSendUrl, modelClass: "BaseModel", response: { (obj) in
                
                let model = obj as! BaseModel
                
                if model.statusCode == 800{
                    
                    let alertView = UIAlertView(title: "提示", message: "派单成功", delegate: nil, cancelButtonTitle: "确定")
                    alertView.tag = 1000
                    alertView.delegate = self
                    alertView.show()
                    
                }else{
                    
                    let alertView = UIAlertView(title: "提示", message: "派单失败", delegate: nil, cancelButtonTitle: "确定")
                    alertView.show()
                }
                
                
            }) { (error) in
                
                
                
            }
        }
      
        
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if(alertView.tag == 1000){
            

            //获取viewController的个数
            for i in 0..<(self.navigationController?.viewControllers.count)! {
                
                if self.navigationController?.viewControllers[i].isKind(of: DispatchOrderVC.self) == true {
                    
                    _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! DispatchOrderVC, animated: true)
                    break
                }
            }
        }
    }
    

    
    func setupTableViewHeaderView() {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.frame = CGRect(x:0 , y : 0 , width:ScreenW , height: 50)
        let view = UIView()
        headerView.addSubview(view)
        view.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(headerView).offset(0)
            make.right.equalTo(headerView).offset(-15)
            make.left.equalTo(headerView).offset(15)
            make.height.equalTo(35)
        }
        view.layer.borderColor = UIColor.init(red: 208/255, green: 220/255, blue: 230/255, alpha: 1.0).cgColor
        view.layer.borderWidth = 0.5
        view.backgroundColor = RGBCOLOR(r: 234, 240, 245)
        
        let titleArr = ["选派","维修工","已完成","待维修","距离"]
        for i in 0..<5  {
            
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = RGBCOLOR(r: 58, 58, 58)
            label.text = titleArr[i]
            label.textAlignment = .center
            view.addSubview(label)
            label.snp.makeConstraints({ (make) in
                
                let width = (ScreenW - 30 - 35) / 4
                make.left.equalTo(view).offset( (i < 2 ? (Double( i ) *  Double( 35)): (35 + Double( i - 1) *  Double( width )))  )
                make.top.equalTo(view).offset(0)
                make.bottom.equalTo(view).offset(0)
                make.width.equalTo(i == 0 ? 35 : width)
                
            })
        }
        
        
        self.tableView.tableHeaderView = headerView
        
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
