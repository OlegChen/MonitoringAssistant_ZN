//
//  TrackDetailVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit


enum selectTimeType : Int {
    
    case startTimeType = 1000
    case endTimeType = 2000
}

class TrackDetailVC: BaseVC , BMKMapViewDelegate, FSCalendarDataSource, FSCalendarDelegate ,UIPickerViewDelegate,UIPickerViewDataSource{
    
    var WorkerModel : TrackPlayBackReturnObjModel?
    
    var pickerView : UIPickerView?
    
    
    private weak var calendar: FSCalendar!
    private weak var calendarContentView: UIView!
    
    var timeSelectView : UIView!

    
    var isShowTimeView = false
    var isShowDateView = false

    var DateStr : String?
    var StartTimeStr : String?
    var EndTimeStr : String?
    
    var Date_L : UILabel?
    var StartTime_L : UILabel?
    var EndTime_L : UILabel?
    
    var cacheTime : String = "00:00"
    
    
    
    lazy var HourArray = ["00","01","02","03","04","05","06","07","08","09","10",
                          "11","12","13","14","15","16","17","18","19","20",
                          "21","22","23","24",]
    
    
    lazy var minuteArray = ["00","01","02","03","04","05","06","07","08","09","10",
                            "11","12","13","14","15","16","17","18","19","20",
                            "21","22","23","24","25","26","27","28","29","30",
                            "31","32","33","34","35","36","37","38","39","40",
                            "41","42","43","44","45","46","47","48","49","50",
                            "51","52","53","54","55","56","57","58","59",
                            ]
    

    
     var _mapView: BMKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "轨迹回放"
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        
        
        self.setCalendarView()
        
        self.setSelectTimeView()
        
        self.setDateSelectView()  //顶部view

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
    
    
    func setCalendarView() {
        
        let height: CGFloat = 300
        
        let view = UIView(frame: CGRect(x: 0, y: CGFloat(-height), width: self.view.bounds.width, height: height))
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.view).offset(0)
            make.top.equalTo(self.view).offset(-300)
            make.size.equalTo(CGSize(width:self.view.bounds.width , height:height))

        }
        self.calendarContentView = view
        
        
        
        let calendar = FSCalendar(frame: view.bounds)
        calendar.appearance.titleDefaultColor = RGBCOLOR(r: 58, 58, 58)
        calendar.appearance.headerTitleColor = RGBCOLOR(r: 58, 58, 58)
        calendar.appearance.weekdayTextColor = RGBCOLOR(r: 58, 58, 58)
        calendar.appearance.headerMinimumDissolvedAlpha = 0
        calendar.calendarHeaderView.height = 55
        
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = RGBCOLOR(r: 58, 58, 58)
        calendar.appearance.subtitleTodayColor = RGBCOLOR(r: 150, 150, 150)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = UIColor.white
        view.addSubview(calendar)
        self.calendar = calendar
        calendar.snp.makeConstraints { (make) in
            
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
            
        }
        
        //创建点击跳转显示上一月和下一月button
        let preBtn = UIButton()
        view.addSubview(preBtn)
        preBtn.backgroundColor = .red
        preBtn.addTarget(self, action: #selector(preBtnClick), for: UIControlEvents.touchUpInside)
        preBtn.snp.makeConstraints { (make) in
            
            make.size.equalTo(CGSize(width:100 ,height:50))
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            
        }
        
        let nextBtn = UIButton()
        view.addSubview(nextBtn)
        nextBtn.backgroundColor = .red
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControlEvents.touchUpInside)
        nextBtn.snp.makeConstraints { (make) in
            
            make.size.equalTo(CGSize(width:100 ,height:50))
            make.right.equalTo(view.snp.right).offset(0)
            make.top.equalTo(view).offset(0)
            
        }
        
    }
    
    @objc func preBtnClick() {
        
        let currentMonth = self.calendar.currentPage
        let gregorian = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
     
        let previousMonth = gregorian?.date(byAdding: NSCalendar.Unit.month, value: -1, to: currentMonth, options: NSCalendar.Options(rawValue: 0))
        
        self.calendar.setCurrentPage(previousMonth!, animated: true)
    }
    
    @objc func nextBtnClick() {
        
        let currentMonth = self.calendar.currentPage
        let gregorian = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)

        let nextMonth = gregorian?.date(byAdding: NSCalendar.Unit.month, value: 1, to: currentMonth, options: NSCalendar.Options(rawValue: 0))
        
        self.calendar.setCurrentPage(nextMonth!, animated: true)
    }
    
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        if(self.calendar.isDate(inToday: date)){
        
            return "今天";
        }
        return nil;
        
    }
    
    func setDateSelectView() {
        
        let dateView = UIView()
//        self.dateSelectView = dateView
        dateView.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.8)
        self.view.addSubview(dateView)
        dateView.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.view).offset(NavHeight)
            make.left.right.equalTo(self.view).offset(0)
            make.height.equalTo(120)
            
        }
        
        let line = UIView()
        line.backgroundColor = RGBCOLOR(r: 180, 180 , 180)
        dateView.addSubview(line)
        line.snp.makeConstraints { (make) in
            
            make.top.equalTo(dateView.snp.centerY).offset(0)
            make.left.right.equalTo(self.view).offset(20)
            make.right.right.equalTo(self.view).offset(-20)
            make.height.equalTo(0.5)
        }
        
        let dateL = UILabel()
        dateL.text = "选择查询日期 --"
        self.Date_L = dateL
        dateL.font = UIFont.systemFont(ofSize: 14)
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
        startTimeL.text = "选择开始时间 --"
        self.StartTime_L = startTimeL
        startTimeL.font = UIFont.systemFont(ofSize: 14)
        dateView.addSubview(startTimeL)
        startTimeL.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateView.snp.top).offset(90)
            make.left.equalTo(dateView).offset(20)
        }
        
        let selectStartTimeBtn = UIButton()
        selectStartTimeBtn.addTarget(self, action: #selector(selectStartTime), for: UIControlEvents.touchUpInside)
        dateView.addSubview(selectStartTimeBtn)
        selectStartTimeBtn.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(dateView.snp.bottom).offset(0)
            make.left.equalTo(dateView).offset(0)
            make.right.equalTo(dateView).offset(-ScreenW / 2.0)
            make.height.equalTo(60)
            
        }
        
        
        let endTimeL = UILabel()
        endTimeL.text = "选择结束时间 --"
        self.EndTime_L = endTimeL
        endTimeL.font = UIFont.systemFont(ofSize: 14)
        dateView.addSubview(endTimeL)
        endTimeL.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateView.snp.top).offset(90)
            make.left.equalTo(dateView.snp.centerX).offset(20)
        }
        
        
        let selectEndTimeBtn = UIButton()
        selectEndTimeBtn.addTarget(self, action: #selector(selectEndTime), for: UIControlEvents.touchUpInside)
        dateView.addSubview(selectEndTimeBtn)
        selectEndTimeBtn.snp.makeConstraints { (make) in
            
            make.bottom.equalTo(dateView.snp.bottom).offset(0)
            make.left.equalTo(dateView).offset(ScreenW / 2.0)
            make.right.equalTo(dateView).offset(0)
            make.height.equalTo(60)
            
        }
        
    }
    
    func setSelectTimeView() {
        
        let timeView = UIView()
        self.timeSelectView = timeView
        timeView.backgroundColor = .white
        self.view.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.view).offset(-190)
            make.left.right.equalTo(self.view).offset(0)
            make.height.equalTo(190)
            
        }
        
        let img = UIImageView()
        timeView.addSubview(img)
        img.contentMode = UIViewContentMode.scaleAspectFill
        img.image = UIImage.init(named: "")
        img.backgroundColor = .red
        img.cornerRadius = 75
        img.clipsToBounds = true
        img.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(timeView)
            make.top.equalTo(timeView.snp.top).offset(0)
            make.size.equalTo(CGSize(width:150, height:150))
        }
        
        
        let timePicker = UIPickerView.init()
        self.pickerView = timePicker
        timeView.addSubview(timePicker)
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.snp.makeConstraints { (make) in
            
            make.center.equalTo(img)
            make.size.equalTo(CGSize(width:120, height:120))
        }
        
        
        let cancleBtn = UIButton()
        timeView.addSubview(cancleBtn)
        cancleBtn.setTitleColor(RGBCOLOR(r: 58, 58, 58), for: UIControlState.normal)
        cancleBtn.setTitle("取消", for: UIControlState.normal )
        cancleBtn.addTarget(self, action: #selector(timeCancleBtnClick), for: UIControlEvents.touchUpInside)
        cancleBtn.snp.makeConstraints { (make)in
            
            make.bottom.equalTo(timeView.snp.bottom).offset(0)
            make.left.equalTo(timeView).offset(0)
            make.size.equalTo(CGSize(width:ScreenW / 2 , height:40))
        }
        
        let sureBtn = UIButton()
        timeView.addSubview(sureBtn)
        sureBtn.setTitleColor(RGBCOLOR(r: 58, 58, 58), for: UIControlState.normal)
        sureBtn.setTitle("确定", for: UIControlState.normal )
        sureBtn.addTarget(self, action: #selector(timeSureBtnClick), for: UIControlEvents.touchUpInside)
        sureBtn.snp.makeConstraints { (make)in
            
            make.bottom.equalTo(timeView.snp.bottom).offset(0)
            make.right.equalTo(timeView.snp.right).offset(0)
            make.size.equalTo(CGSize(width:ScreenW / 2 , height:40))
        }
        
        
    }
    
    @objc func timeCancleBtnClick() {
        
        self.isShowTimeView = false
        self.timeSelectView.snp.updateConstraints({ (make) in
            make.top.equalTo(self.view).offset(-190)
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    
        self.pickerView?.selectRow(0, inComponent: 0, animated: false)
        self.pickerView?.selectRow(0, inComponent: 1, animated: false)
        
    }
    @objc func timeSureBtnClick() {
        
        if self.pickerView?.tag == selectTimeType.startTimeType.rawValue {
            
            self.StartTime_L?.text = "开始时间 " + self.cacheTime
            self.StartTimeStr = self.cacheTime
            
        }else if self.pickerView?.tag == selectTimeType.endTimeType.rawValue {
            
            self.EndTime_L?.text = "结束时间 " + self.cacheTime
            self.EndTimeStr = self.cacheTime
            
        }
        
        self.pickerView?.selectRow(0, inComponent: 0, animated: false)
        self.pickerView?.selectRow(0, inComponent: 1, animated: false)
        
        
        self.isShowTimeView = false
        self.timeSelectView.snp.updateConstraints({ (make) in
            make.top.equalTo(self.view).offset(-190)
        })
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日"
        print(formatter.string(from: datePicker.date))
        
        
        self.DateStr = formatter.string(from: datePicker.date)
        self.Date_L?.text = "查询日期：" + formatter.string(from: datePicker.date)
        self.selectDate()
        
    }
    
    func getData() {
        
        if((self.DateStr != nil) && (self.StartTimeStr != nil) && (self.EndTimeStr != nil)){
            
            weak var weakSelf = self // ADD THIS LINE AS WELL
            
            UserCenter.shared.userInfo { (islogin, userInfo) in
                
                let para = ["companyCode":userInfo.companyCode ,
                            "orgCode":userInfo.orgCode ,
                            "empNo":self.WorkerModel?.empNo ,
                            "empName":self.WorkerModel?.empName,
                            "startTime":self.DateStr! + "" + self.StartTimeStr!,
                            "endTime":self.DateStr! + "" + self.EndTimeStr!,
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
        
        if !self.isShowDateView {
            
            self.isShowDateView = true
            
            self.calendarContentView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(NavHeight + 120)

            })

            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()
            })
            
        }else{
            
            self.isShowDateView = false
            
            self.calendarContentView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(-300)
                
            })

            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    @objc func selectStartTime () {
        
        if !self.isShowTimeView {
            
            self.isShowTimeView = true
            
            self.pickerView?.tag = selectTimeType.startTimeType.rawValue
            
            self.timeSelectView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(NavHeight + 120)

            })

            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()

            }, completion: { (bool) in
                
                
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                
            })
            
        }else{
            
            self.isShowTimeView = false
            
            self.pickerView?.tag = selectTimeType.startTimeType.rawValue
            self.timeSelectView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(-190)
                
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    @objc func selectEndTime () {
        
        if !self.isShowTimeView {
            
            self.isShowTimeView = true
            
            self.pickerView?.tag = selectTimeType.endTimeType.rawValue

            self.timeSelectView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(NavHeight + 120)
                
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()
            })
            
        }else{
            
            self.isShowTimeView = false
            
            self.pickerView?.tag = selectTimeType.endTimeType.rawValue
            self.timeSelectView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(-190)
                
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()
            })
        }
        
    }
    
    //timePicker Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 2
        
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return component == 0 ? self.HourArray.count : self.minuteArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return 30
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let title = UILabel()
        title.frame = CGRect(x:0, y : 0 ,width: 60 , height: 40)
        title.textAlignment = NSTextAlignment.center
        title.text = component == 0 ? self.HourArray[row] as! String : self.minuteArray[row] as! String
        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = RGBCOLOR(r: 58, 58, 58)
        
        return title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var HourStr : String = "00"
        var minStr : String = "00"
        
        component == 0 ? (HourStr = self.HourArray[row] as! String) : (minStr = self.minuteArray[row] as! String)
        
        self.cacheTime = HourStr + ":" + minStr
        
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
