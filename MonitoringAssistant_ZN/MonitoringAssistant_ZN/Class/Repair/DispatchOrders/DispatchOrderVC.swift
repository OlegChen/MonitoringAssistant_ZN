//
//  DispatchOrderVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import ESPullToRefresh

class DispatchOrderVC: BaseVC,UITableViewDelegate,UITableViewDataSource,DispatchOrderVCCellDelegate {

    var tableView : UITableView!
    
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    var pageNo = 0
    
    
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
        
        self.tableView.es.addPullToRefresh {
            
            [weak self] in
            self?.getData(pageNo: 1)
            
        }
        
        self.tableView.es.addInfiniteScrolling {
            
            [weak self] in
            self?.getData(pageNo: (self?.pageNo)! + 1)
            
        }
        
        self.view.beginLoading()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getData(pageNo: 1)
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return self.dataArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DispatchOrderVCCell_id) as! DispatchOrderVCCell
        
        let model = self.dataArr[indexPath.row] as! DispatchOrderResultModel
        
        cell.index = indexPath.section
        
        
        cell.titleL.text = model.workName! + " | " + model.workName!
        cell.dateL.text = "报修时间：" + model.createDateStr!
        cell.longTimeL.text = "报修时长：" + model.repairsTime! + "分钟"
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
        
        let model = self.dataArr[indexPath.row] as! DispatchOrderResultModel

        let vc = OrderDetailVC()
        vc.workNo = model.workNo
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func getData(pageNo:Int) {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "pageNum":String(pageNo),
                        "pageSize":"15",
                        ]
          
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: workSendPageUrl, modelClass: "DispatchOrderModel" , response: { (obj) in
                
                let model = obj as! DispatchOrderModel
                
                if model.statusCode == 800 {
                    
                    self.pageNo = pageNo
                    
                    if (pageNo == 1){
                        
                        self.dataArr.removeAllObjects()
                    }
                    
                    self.dataArr.addObjects(from: (model.returnObj?.result!)!)
                    self.tableView.reloadData()
                    
                    if((model.returnObj?.totalCount)! == 0){
                        
                        self.tableView.configBlankPage(EaseBlankPageType(rawValue: 0)!, hasData: false, hasError: false, reloadButtonBlock: nil)
                    }
                    
                    self.tableView.es.stopPullToRefresh()

                    self.tableView.es.stopLoadingMore()
                    
                    if(pageNo == model.returnObj?.totalPage){
                        self.tableView.es.noticeNoMoreData()
                    }else{
                        self.tableView.es.resetNoMoreData()
                    }
                    
                }
                
                self.view.endLoading()
                
            }, failture: { (error) in
                
                self.view.endLoading()
                
            })
            
            
        }
        
        
        
    }
    
    func dispatchMethod(index: Int) {
        
        let model = self.dataArr[index] as! DispatchOrderResultModel

        let vc = SelectWorkerVCViewController()
        vc.lat = model.latitude
        vc.lon = model.longitude
        vc.workNo = model.workNo
        vc.workSendId = model.workSendId
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
