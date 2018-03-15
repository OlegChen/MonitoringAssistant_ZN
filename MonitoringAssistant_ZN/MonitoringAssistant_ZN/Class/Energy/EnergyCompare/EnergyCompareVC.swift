//
//  EnergyCompareVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Charts


class EnergyCompareVC: BaseVC ,ChartViewDelegate {


    var segment : UISegmentedControl!
    
    
    
    var tableView : UITableView!
    var headView : EnergyCompareHeadView!
    

    var ReturnObjModel : EnergyCompareReturnObjModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "黄金对标"
        
        
        self.view.backgroundColor = RGBCOLOR(r: 245, 245, 245)
        
        let topView = UIView()
        topView.backgroundColor = .white
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(self.view).offset(0)
            make.top.equalTo(self.view).offset(NavHeight)
            make.height.equalTo(60)
        }
        
        
        let mySegmentedControl = UISegmentedControl(
            items: ["总耗能","水耗能","电耗能","气耗能"])
        self.segment = mySegmentedControl
        mySegmentedControl.tintColor = RGBCOLOR(r: 11, 46, 77)
//        mySegmentedControl.backgroundColor = RGBCOLOR(r: 11, 46, 77)
//        mySegmentedControl.borderColor = RGBCOLOR(r: 11, 46, 77)
        mySegmentedControl.selectedSegmentIndex = 0
        mySegmentedControl.addTarget(self, action: #selector(self.onChange), for: .valueChanged)
        
        mySegmentedControl.frame.size = CGSize(
            width: ScreenW * 0.8, height: 35)
        mySegmentedControl.center = CGPoint(
            x: ScreenW * 0.5,
            y: CGFloat(30.0))
        topView.addSubview(mySegmentedControl)
        
        
        
        self.tableView = UITableView(frame:CGRect(x:0 , y : CGFloat(NavHeight + 20.0 + 30 + 10) , width:ScreenW , height: 412))
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(CGFloat(NavHeight + 60 + 10), 0 , 0, 0))
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.getdataWithType(type: "1")   //1：总能耗2：水能耗3：电能耗4：气能耗
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    
    /*
    override func optionTapped(_ option: Option) {
        switch option {
        case .toggleFilled:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.drawFilledEnabled = !set.drawFilledEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleCircles:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.drawCirclesEnabled = !set.drawCirclesEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleCubic:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
            }
            chartView.setNeedsDisplay()
            
        case .toggleStepped:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .stepped) ? .linear : .stepped
            }
            chartView.setNeedsDisplay()
            
        case .toggleHorizontalCubic:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
            }
            chartView.setNeedsDisplay()
            
        default:
            super.handleOption(option, forChartView: chartView)
        }
    }
 */
 

    @objc func onChange(sender: UISegmentedControl) {
        // 印出選到哪個選項 從 0 開始算起
        print(sender.selectedSegmentIndex)
        
        if ((self.ReturnObjModel) != nil) {
            
            // 印出這個選項的文字
            print(sender.titleForSegment(at: sender.selectedSegmentIndex) as Any)
            
            switch sender.selectedSegmentIndex{
            case 0: //相当于if
                self.headView.updateData(model: (self.ReturnObjModel?.totalGoldStandardVo)!)
            case 1: // 相当于else if
                self.headView.updateData(model: (self.ReturnObjModel?.waterGoldStandardVo)!)
            case 2: // 相当于else if
                self.headView.updateData(model: (self.ReturnObjModel?.eleGoldStandardVo)!)
            case 3: // 相当于else if
                self.headView.updateData(model: (self.ReturnObjModel?.gasGoldStandardVo)!)
            default: // 相当于else
                print("没有评级")
            }
            
        }

    }
    
    func getdataWithType(type:String) {
        
        UserCenter.shared.userInfo { (isLogin, userInfo) in
            
            self.view.beginLoading()
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ,"type":type]

            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: goldStandardDataUrl, modelClass: "EnergyCompareModel", response: { (obj) in
                
                let model = obj as! EnergyCompareModel
                
                if(model.statusCode == 800){
                    
                    self.setHeadView()
                    
                    self.ReturnObjModel = model.returnObj
                    var m : EnergyCompareStandardVoModel!
                    if(self.segment.selectedSegmentIndex == 0){
                        
                        m = (model.returnObj?.totalGoldStandardVo)!
                    }else if(self.segment.selectedSegmentIndex == 1){
                        
                        m = (model.returnObj?.waterGoldStandardVo)!
                    }else if(self.segment.selectedSegmentIndex == 2){
                        
                        m = (model.returnObj?.eleGoldStandardVo)!
                    }else if(self.segment.selectedSegmentIndex == 3){
                        
                        m = (model.returnObj?.gasGoldStandardVo)!
                    }
                    
                    self.headView.updateData(model:m)
                }
                
                self.view.endLoading()
                
            }, failture: { (error) in
                
                self.view.endLoading()
            })
        }

        
    }
    
    func setHeadView() {
        
        let headerView = UIView()
        headerView.frame = CGRect(x:0 , y : 0, width:ScreenW , height: 522)
        
        let view = (Bundle.main.loadNibNamed("EnergyCompareHeadView", owner: nil, options: nil)![0] as! EnergyCompareHeadView)
        self.headView = view
        headerView.addSubview(view)
        view.frame = headerView.bounds
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
