//
//  TrackDetailVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class TrackDetailVC: BaseVC , BMKMapViewDelegate{
    
    var WorkerModel : TrackPlayBackReturnObjModel?
    
     var _mapView: BMKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "轨迹回放"
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        
        self.setDateSelectView()
        
        self.getData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        _mapView?.viewWillAppear()
        _mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated);
        
        _mapView?.viewWillDisappear()
        _mapView?.delegate = nil // 不用时，置nil
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // MARK: -----------  mapview delegate
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        
        
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        
        let newAnnotationView = CustomMapAnnotationView.init(annotation: annotation, reuseIdentifier: "12345")
        //
        //        let popView = Bundle.main.loadNibNamed("EnergyMonitorPopView", owner: nil, options: nil)?[0] as! EnergyMonitorPopView
        //        let custPopView =  BMKActionPaopaoView.init(customView: popView)
        
        
        let custAnnotation = annotation as! CustPointAnnotation
        
        
        newAnnotationView?.centerOffset = CGPoint(x:10, y:-20) ;
//
//        let custView = TrackPlayBackPopView.init(frame: CGRect(x: 0 , y : 0 , width: 120 , height: 120 ))
//        custView.delegate = self
//        let popView = BMKActionPaopaoView.init(customView: custView )
//
//        newAnnotationView?.paopaoView = nil
//        newAnnotationView?.paopaoView = popView
        
        return newAnnotationView;
        
    }
    
    func setDateSelectView() {
        
        let dateView = UIView()
        dateView.backgroundColor = .gray
        self.view.addSubview(dateView)
        dateView.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.view).offset(NavHeight)
            make.left.right.equalTo(self.view).offset(0)
            make.height.equalTo(120)
            
        }
        
        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 230, 230, 230)
        dateView.addSubview(line)
        line.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(self.view)
            make.left.right.equalTo(self.view).offset(20)
            make.right.right.equalTo(self.view).offset(-20)
            make.height.equalTo(0.5)
        }
        
        let dateL = UILabel()
        dateL.text = "选择查询日期"
        dateView.addSubview(dateL)
        dateL.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateView.snp.top).offset(30)
            make.left.equalTo(dateView).offset(20)
        }
        
        
        let dateBtn = UIButton()
        dateBtn.addTarget(self, action: #selector(selectDate), for: UIControlEvents.touchUpInside)
        dateView.addSubview(dateBtn)
        dateBtn.snp.makeConstraints { (make) in
            
            make.top.equalTo(dateView).offset(0)
            make.left.equalTo(dateView).offset(0)
            make.right.equalTo(dateView).offset(0)
            make.height.equalTo(60)
            
        }
        
        
        
        
        let startTimeL = UILabel()
        startTimeL.text = "选择开始时间"
        dateView.addSubview(startTimeL)
        startTimeL.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateView.snp.top).offset(90)
            make.left.equalTo(dateView).offset(20)
        }
        
        let selectStartTimeBtn = UIButton()
        selectStartTimeBtn.backgroundColor = .red
        selectStartTimeBtn.addTarget(self, action: #selector(selectStartTime), for: UIControlEvents.touchUpInside)
        dateView.addSubview(selectStartTimeBtn)
        selectStartTimeBtn.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(dateView.snp.bottom).offset(0)
            make.left.equalTo(dateView).offset(0)
            make.right.equalTo(dateView).offset(-ScreenW / 2.0)
            make.height.equalTo(60)
            
        }
        
        
        let endTimeL = UILabel()
        endTimeL.text = "选择结束时间"
        dateView.addSubview(endTimeL)
        endTimeL.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateView.snp.top).offset(90)
            make.left.equalTo(dateView.snp.centerX).offset(20)
        }
        
        
        let selectEndTimeBtn = UIButton()
        selectEndTimeBtn.backgroundColor = .orange
        selectEndTimeBtn.addTarget(self, action: #selector(selectEndTime), for: UIControlEvents.touchUpInside)
        dateView.addSubview(selectEndTimeBtn)
        selectEndTimeBtn.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(dateView.snp.bottom).offset(0)
            make.left.equalTo(dateView).offset(ScreenW / 2.0)
            make.right.equalTo(dateView).offset(0)
            make.height.equalTo(60)
            
        }
        
    }
    
    func getData() {
        
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
        
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":self.WorkerModel?.empNo ,
                        "empName":self.WorkerModel?.empName,
                        "startTime":"2018-02-23 13:28",
                        "endTime":"2018-02-28 13:28",
                        ]
            
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: getEmpPointsUrl, modelClass: "TrackPlayBackModel" , response: { (obj) in
                
                let model = obj as! TrackPlayBackModel
                
                if model.statusCode == 800 {
                    
                    self.AddAnnotations(array: model.returnObj! as NSArray)
                    
                    
                }
                
                
            }, failture: { (error) in
                
                
            })
            
            
        }
        
        
        
    }
    
    func AddAnnotations(array:NSArray) {
        
        let itemArray : NSMutableArray = []
        
        
        for var model in array {
            
            let m = model as! TrackPlayBackReturnObjModel
            
            let item = CustPointAnnotation()
            
            item.coordinate = CLLocationCoordinate2D.init(latitude: Double(m.latitude!)! , longitude: Double(m.longitude!)!)
            
            item.Model = m
            
            itemArray.add(item)
            
        }
        
        self._mapView?.addAnnotations(itemArray as! [Any])
        
        
    }
    
    @objc func selectDate () {
        
        
        
    }
    
    @objc func selectStartTime () {
        
        
        
    }
    
    @objc func selectEndTime () {
        
        
        
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
