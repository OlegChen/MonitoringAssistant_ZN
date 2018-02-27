//
//  OrderDetailVC.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/25.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit


class OrderDetailVC: BaseVC ,UITableViewDelegate,UITableViewDataSource {

    var workNo : String?
    
    var headView : OrderDetailHeaderView?
    
    var dataModel : WorkOrderDetailModel?
    
    
    var tableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工单详情"
        self.view.backgroundColor = RGBCOLOR(r: 240, 240, 240)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "派单记录", target: self, action: #selector(toDispatchOrderListVC))

        self.tableView = UITableView()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0, 80, 0))
        }
        self.tableView.register(UINib.init(nibName: "OrderDetailCell" , bundle: nil), forCellReuseIdentifier: OrderDetailCell_id)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        headerView.frame = CGRect(x:0 , y : 0 , width:ScreenW , height: 220)
       
        let view = (Bundle.main.loadNibNamed("OrderDetailHeaderView", owner: nil, options: nil)![0] as! OrderDetailHeaderView)
        self.headView = view
        headerView.addSubview(view)
        
        self.tableView.tableHeaderView = headerView
    
        self.setupBottomBtn()
        self.getdata()
    
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: OrderDetailCell_id) as? OrderDetailCell
        cell?.levelL.text = self.dataModel?.returnObj?.urgencyName
        cell?.contentL.text = self.dataModel?.returnObj?.repairsDesc
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return dataModel == nil ? 86 :  CGFloat((self.dataModel?.returnObj?.cellHeight)!)
    }
    
    func setupBottomBtn() {
        
        let btn = UIButton()
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.tableView.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(45)
            make.right.equalTo(self.view).offset(-45)
            make.height.equalTo(50)
        }
        btn.layer.cornerRadius = 4
        btn.backgroundColor = RGBCOLOR(r: 71, 143, 183)
        btn.setTitle("派  单", for: UIControlState.normal)
        btn.setTitleColor(.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.addTarget(self, action: #selector(sureBtnClick(btn:)), for: UIControlEvents.touchUpInside)
        
    }
    
    @objc func sureBtnClick(btn: UIButton) {
        
        let vc = SelectWorkerVCViewController()
        vc.lat = self.dataModel?.returnObj?.latitude
        vc.lon = self.dataModel?.returnObj?.longitude
        vc.workNo = self.dataModel?.returnObj?.workNo
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func toDispatchOrderListVC() {
        
        
        
        
    }
    
    
    func getdata() {
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "workNo":self.workNo
            ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: workOrderDetailUrl, modelClass: "WorkOrderDetailModel", response: { (obj) in
                
                let model = obj as! WorkOrderDetailModel
                
                self.headView?.titleL.text = (model.returnObj?.workName)! + " | " + (model.returnObj?.workType)!
                self.headView?.longTimeL.text = (model.returnObj?.repairsTime)! + "分钟"
                self.headView?.dateL.text = model.returnObj?.createDateStr
                self.headView?.nameL.text = model.returnObj?.sendEmpName
                self.headView?.connectPersonL.text = model.returnObj?.contactMan
                self.headView?.telL.text = model.returnObj?.tel
                self.headView?.addressL.text = model.returnObj?.address
                
                self.dataModel = model
                
                
                
                
                //
//                self.dataArr.addObjects(from: model.returnObj!)
                self.tableView.reloadData()
                
            }) { (error) in
                
            }
            
        }
        
    }
    
    func setupImagefooter() {
        
        let view = UIView()
        
        let imgW = (ScreenW - 15 * 4) / 3
        
        for i in 0..<(self.dataModel?.returnObj?.workDealImgs?.count)! {
            
            let img = UIImageView.init()
            img.contentMode = UIViewContentMode.scaleAspectFill
            
            let urlStr = self.dataModel?.returnObj?.workDealImgs![i] as! String
            img.kf.setImage(with: URL(string: urlStr))
            view.addSubview(img)
            let l = i % 3
            let row = i / 3
            img.snp.makeConstraints({ (make) in
                
                make.left.equalTo(view).offset(15 + CGFloat(l) * (imgW + 15))
                make.top.equalTo(view).offset(15 + CGFloat(row) * (imgW + 15))
                make.size.equalTo(CGSize(width: imgW, height: imgW))
            })
            
        }
        
        let height = 15 +  CGFloat((self.dataModel?.returnObj?.workDealImgs?.count)!) / 3 * (imgW + 15)
        
        view.frame = CGRect(x: 0 , y : 0 , width: ScreenW , height: height )
        
        self.tableView.tableFooterView = view
        
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
