//
//  EnergyCompareVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Charts


class EnergyCompareVC: BaseVC ,ChartViewDelegate ,EnergyCompareContentVCDelegate ,UITableViewDelegate,UITableViewDataSource{
    func refreshData() {
        
        self.getdataWithType(type: "1")
        
    }
    


    var segment : UISegmentedControl!
    
    
    
    var tableView : UITableView!
//    var headView : EnergyCompareHeadView!
    
    var content0 : EnergyCompareContentVC!
    var content1 : EnergyCompareContentVC!
    var content2 : EnergyCompareContentVC!
    var content3 : EnergyCompareContentVC!

    var ReturnObjModel : EnergyCompareReturnObjModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "黄金对标"
        
        
        self.view.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        
        
        self.tableView = UITableView(frame:CGRect(x:0 , y : CGFloat(NavHeight) , width:ScreenW , height: ScreenH - CGFloat(NavHeight)))
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        self.tableView.snp.makeConstraints { (make) in

            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight), 0 , 0, 0))
        }
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView.es.addPullToRefresh {

            [weak self] in
            
            self?.getdataWithType(type: "1")
        }
        
        let view = UIView()
        view.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        view.height = 466 + 63
        
        let topView = UIView()
        topView.backgroundColor = .white
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(view).offset(0)
            make.top.equalTo(view).offset(0)
            make.height.equalTo(53)
        }
        
        
        let SegmentControl = MXSegmentedControl()
        SegmentControl.cornerRadius = 4
        SegmentControl.textColor = UIColor.white
        SegmentControl.selectedTextColor = RGBCOLOR(r: 11, 46, 77)
        SegmentControl.borderColor = RGBCOLOR(r: 11, 46, 77)
        SegmentControl.borderWidth = 1
        SegmentControl.backgroundColor = RGBCOLOR(r: 11, 46, 77)
        SegmentControl.boxColor = UIColor.white
        SegmentControl.boxOpacity = 1.0
        SegmentControl.separatorColor = RGBCOLOR(r: 11, 46, 77)
        SegmentControl.separatorWidth = 1
        SegmentControl.indicatorHeight = 0
        SegmentControl.font = UIFont.systemFont(ofSize: 15)

        SegmentControl.animation.duration = 0
        
        SegmentControl.append(title: "总耗能")
        SegmentControl.append(title: "水耗能")
        SegmentControl.append(title: "电耗能")
        SegmentControl.append(title: "气耗能")
        topView.addSubview(SegmentControl)
        SegmentControl.frame = CGRect(x: 15  , y: 13 , width: ScreenW - 30 , height:27)
        

        let myScrollView = UIScrollView()
        myScrollView.contentSize = CGSize(width:Double(ScreenW)*4 ,height:466)
        view.addSubview(myScrollView)
        myScrollView.frame =  CGRect(x:0 , y:53 + 10 , width:Double(ScreenW) , height:(ScreenH - 466 - 63) > 0 ? (Double(ScreenH) - NavHeight - 63) : 466)
        myScrollView.backgroundColor = .white
        myScrollView.isPagingEnabled = true
        
        for i in 0..<4 {
            
            let content = EnergyCompareContentVC()
            content.delegate = self
            self.addChildViewController(content)
            if(i == 0){
                
                self.content0 = content
            }else if(i == 1){
                self.content1 = content
            }else if(i == 2){
                self.content2 = content
            }else if(i == 3){
                self.content3 = content
            }
            
            myScrollView.addSubview(content.view)
            content.view.frame = CGRect(x:Double(i) * Double(ScreenW) , y:0 , width:Double(ScreenW) , height:(ScreenH - 466 - 63) > 0 ? (Double(ScreenH) - NavHeight) : 466)

        }
        
        SegmentControl.scrollView = myScrollView
        
        
        self.tableView.tableHeaderView = view;
        
        
        
        self.getdataWithType(type: "1")   //1：总能耗2：水能耗3：电能耗4：气能耗
        self.view.beginLoading()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell.init(style: UITableViewCellStyle.default, reuseIdentifier: "123123")
        
        
        return cell
    }
    

//    @objc func onChange(sender: UISegmentedControl) {
//        // 印出選到哪個選項 從 0 開始算起
//        print(sender.selectedSegmentIndex)
//
//        if ((self.ReturnObjModel) != nil) {
//
//            // 印出這個選項的文字
//            print(sender.titleForSegment(at: sender.selectedSegmentIndex) as Any)
//
//            switch sender.selectedSegmentIndex{
//            case 0: //相当于if
//                self.headView.updateData(model: (self.ReturnObjModel?.totalGoldStandardVo)!)
//            case 1: // 相当于else if
//                self.headView.updateData(model: (self.ReturnObjModel?.waterGoldStandardVo)!)
//            case 2: // 相当于else if
//                self.headView.updateData(model: (self.ReturnObjModel?.eleGoldStandardVo)!)
//            case 3: // 相当于else if
//                self.headView.updateData(model: (self.ReturnObjModel?.gasGoldStandardVo)!)
//            default: // 相当于else
//                print("没有评级")
//            }
//
//        }
//
//    }
    
    
    func getdataWithType(type:String) {
        
        UserCenter.shared.userInfo { (isLogin, userInfo) in
            
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ,"type":type]

            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: goldStandardDataUrl, modelClass: "EnergyCompareModel", response: { (obj) in
                
                let model = obj as! EnergyCompareModel
                
                if(model.statusCode == 800){
                    
                    self.ReturnObjModel = model.returnObj
 
                        self.content0.setData(model: (model.returnObj?.totalGoldStandardVo)!)
                    
                        self.content1.setData(model: (model.returnObj?.waterGoldStandardVo)!)
                    
                        self.content2.setData(model: (model.returnObj?.eleGoldStandardVo)!)
                    
                        self.content3.setData(model: (model.returnObj?.gasGoldStandardVo)!)
                    
                }
                
                self.view.endLoading()
                
                self.tableView.es.stopPullToRefresh()

                
            }, failture: { (error) in
                
                self.view.endLoading()
                
                self.tableView.es.stopPullToRefresh()

            })
        }

        
    }
    
//    func setHeadView() {
//
//        let headerView = UIView()
//        headerView.frame = CGRect(x:0 , y : 0, width:ScreenW , height: 522)
//
//        let view = (Bundle.main.loadNibNamed("EnergyCompareHeadView", owner: nil, options: nil)![0] as! EnergyCompareHeadView)
//        self.headView = view
//        headerView.addSubview(view)
//        view.frame = headerView.bounds
//        self.tableView.tableHeaderView = headerView
//
//    }
    

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
