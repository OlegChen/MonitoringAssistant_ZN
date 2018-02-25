//
//  FeeInfoVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/13.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class FeeInfoVC: BaseVC,UITableViewDelegate,UITableViewDataSource {
    
    var tableView : UITableView?
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    var headerView : FeeInfoHeaderView?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "收费信息"
        
        self.tableView = UITableView.init()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        self.tableView?.snp.makeConstraints({ (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 0, 0))
        })
        self.tableView?.register(UINib.init(nibName: "FeeInfoTableViewCell", bundle: nil), forCellReuseIdentifier:FeeInfoTableViewCell_id )
        
        let view = UIView.init()
        view.frame = CGRect(x: 0, y: 0 , width:ScreenW ,height: 360 )
        
        let headerView = Bundle.main.loadNibNamed("FeeInfoHeaderView", owner: nil, options: nil)?[0] as! FeeInfoHeaderView
        self.headerView = headerView
        view.addSubview(headerView)
        headerView.frame = view.bounds
        self.tableView?.tableHeaderView = view;
        
        //数据
        self.getData()
        
        // Do any additional setup after loading the view.
    }

    func getData() {
        
        UserCenter.shared.userInfo { (islogin, model) in
            
            let para = ["companyCode":model.companyCode , "orgCode" :model.orgCode , "empNo" : model.empNo , "empName" : model.empName ]
            
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: FeeUrl, modelClass: "FeeModel", response: { (obj) in
                
                let model = obj as! FeeModel
                
                self.headerView?.maxFeeL.text = model.returnObj?.maxSumRealFee
                self.headerView?.averageFeeL.text = model.returnObj?.avgSumRealFee
                self.headerView?.minFeeL.text = model.returnObj?.minSumRealFee
                
                self.dataArr.removeAllObjects()
                self.dataArr.addObjects(from: (model.returnObj?.chargeRateVos)!)
                self.tableView?.reloadData()
                
            }, failture: { (errow) in
                
            })
    
        }
        
        
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : FeeInfoTableViewCell = tableView.dequeueReusableCell(withIdentifier: FeeInfoTableViewCell_id) as! FeeInfoTableViewCell
        
        let model = self.dataArr[indexPath.row] as! ReturnObjChargeRateVosModel
        cell.dateL.text = model.dateStr
        cell.feeL.text = model.sumRealFee
        cell.percentL.text = model.proportion
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor.init(red: 245/255.0, green:  245/255.0, blue:  245/255.0, alpha: 1.0)
        
        let label = UILabel()
        label.text = "记录"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.init(red: 58/255.0, green: 58/255.0, blue: 58/255.0, alpha: 1.0)
        view.addSubview(label)
        label.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(view)
            make.left.equalTo(view).offset(15)
        }
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
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
