//
//  TrackDetailVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/2.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit


enum selectTimeType : Int {  //选择时、分view
    
    case startTimeType = 1000
    case endTimeType = 2000
}

class TrackDetailVC: BaseVC , BMKMapViewDelegate, FSCalendarDataSource, FSCalendarDelegate ,UIPickerViewDelegate,UIPickerViewDataSource,bottomPlayViewDelegate{
    
    var WorkerModel : TrackPlayBackReturnObjModel?
    
    var Data : TrackPlayBackModel?
    
    
    var pickerView : UIPickerView?
    
    /** 轨迹线 */
    var polyLine : BMKPolyline?
    
    private weak var calendar: FSCalendar!
    private weak var calendarContentView: UIView!
    
    var timeSelectView : UIView!
    var selectRow0 = 0
    var selectRow1 = 0

    var bottomplayview : bottomPlayView!

    var timer : Timer!
    var timerCount  = 0
    
    
    var isShowTimeView = false
    var isShowDateView = false

    var DateStr : String?
    var StartTimeStr : String?
    var EndTimeStr : String?
    
    var Date_L : UILabel?
    var StartTime_L : UILabel?
    var EndTime_L : UILabel?
    
    var cacheTime : String = "00:00"
    
    var nowHour : String!  //当前时间 小时
    
    
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
    

    
     var _mapView: BMKMapView!
    
    var workerAnnotation : CustPointAnnotation?
    var startAnnotation : CustPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "轨迹回放"
        
        self.fd_interactivePopDisabled = true
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        _mapView?.isRotateEnabled  = false
        
        self.setCalendarView()
        
        self.setSelectTimeView()
        
        self.setDateSelectView()  //顶部view

        self.setbottonPlayView()
        
        self.getData()
        
        
        
        //获取当前时间
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "HH:mm"
        print("当前日期时间：\(dformatter.string(from: now))")
        
        self.nowHour = dformatter.string(from: now)
        self.cacheTime = dformatter.string(from: now)
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        _mapView?.viewWillAppear()
        _mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
        
        
        //显示选中的工人位置
        let item = CustPointAnnotation()
        self.workerAnnotation = item
        item.coordinate = CLLocationCoordinate2D.init(latitude: Double(WorkerModel!.latitude!)! , longitude: Double(WorkerModel!.longitude!)!)
        let m = TrackPlayBackReturnObjModel()
        m.latitude = WorkerModel?.latitude
        m.longitude = WorkerModel?.longitude
        m.headUrl = WorkerModel?.headUrl;
        m.empName = WorkerModel?.empName
        item.Model = m
        _mapView.addAnnotation(item)
        _mapView.centerCoordinate = item.coordinate
        
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
        
        let custAnnotation = annotation as! CustPointAnnotation

        if (custAnnotation.isStartAnno == starOrEnd.star.rawValue) {

            let AnnotationViewID = "begain"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as! BMKPinAnnotationView?
            if annotationView == nil {
                annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)

                annotationView?.image  = UIImage.init(named: "起点")

            }
            return annotationView

        }else if (custAnnotation.isStartAnno == starOrEnd.end.rawValue) {

            let AnnotationViewID = "end"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as! BMKPinAnnotationView?
            if annotationView == nil {
                annotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: AnnotationViewID)

                annotationView?.image  = UIImage.init(named: "终点")

            }
            return annotationView

        }
        
//        let newAnnotationView = CustomTrackDetailAnnotationView.init(annotation: annotation, reuseIdentifier: "gwea")
//        newAnnotationView?.img = custAnnotation.Model?.headUrl
//        newAnnotationView?.name = custAnnotation.Model?.empName
//
//        newAnnotationView?.centerOffset = CGPoint(x:10, y:-20) ;
//        newAnnotationView?.animatesDrop = false
//
//
//
//        return newAnnotationView;
        
        
        
        let newAnnotationView = CustomMapAnnotationView.init(annotation: annotation, reuseIdentifier: "12345546")

        newAnnotationView?.centerOffset = CGPoint(x:10, y:-20) ;
        newAnnotationView?.nameLabel.text = custAnnotation.Model?.empName
        newAnnotationView?.img = custAnnotation.Model?.headUrl
        return newAnnotationView;
        
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        
        if let overlayTemp = overlay as? BMKPolyline {
            let polylineView = BMKPolylineView(overlay: overlay)
            if overlayTemp == polyLine {
                polylineView?.strokeColor = UIColor(red: 215/255.0, green: 49/255.0, blue: 53/255.0, alpha: 1)
                polylineView?.lineWidth = 1
                polylineView?.loadStrokeTextureImage(UIImage(named: "texture_arrow.png"))
            }
            return polylineView
        }
        
        return nil
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
        calendar.appearance.headerDateFormat = "yyyy年MM月"
        calendar.appearance.selectionColor = RGBCOLOR(r: 71, 143, 182)
        
        calendar.appearance.todayColor = .clear
        calendar.appearance.titleTodayColor = RGBCOLOR(r: 58, 58, 58)
        calendar.appearance.subtitleTodayColor = RGBCOLOR(r: 150, 150, 150)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = RGBCOLOR(r: 238, 238, 238)
        view.addSubview(calendar)
        self.calendar = calendar
        calendar.snp.makeConstraints { (make) in
            
            make.edges.equalTo(view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
            
        }
        
        //创建点击跳转显示上一月和下一月button
        let preBtn = UIButton()
        view.addSubview(preBtn)
        preBtn.setImage(UIImage.init(named: "左"), for: UIControlState.normal)
        preBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -40, 0, 0)
        preBtn.addTarget(self, action: #selector(preBtnClick), for: UIControlEvents.touchUpInside)
        preBtn.snp.makeConstraints { (make) in
            
            make.size.equalTo(CGSize(width:100 ,height:40))
            make.top.equalTo(view).offset(0)
            make.left.equalTo(view).offset(0)
            
        }
        
        let nextBtn = UIButton()
        view.addSubview(nextBtn)
        nextBtn.setImage(UIImage.init(named: "右"), for: UIControlState.normal)
        nextBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 40, 0, 0)
        nextBtn.addTarget(self, action: #selector(nextBtnClick), for: UIControlEvents.touchUpInside)
        nextBtn.snp.makeConstraints { (make) in
            
            make.size.equalTo(CGSize(width:100 ,height:40))
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
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: date))
        let a = self.dateIslastWithToday(date: formatter.string(from: date))
        
        return !a
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: date))
        
        
        self.DateStr = formatter.string(from: date)
        self.Date_L?.text = formatter.string(from: date)
        self.Date_L?.textColor = RGBCOLOR(r: 58, 58, 58)
        self.closeSelectDateView()
        
        self.getData()
        
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
        dateL.text = "选择查询日期"
        self.Date_L = dateL
        dateL.textColor = RGBCOLOR(r: 108 , 108, 108)
        dateL.font = UIFont.systemFont(ofSize: 15)
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
        self.StartTime_L = startTimeL
        startTimeL.textColor = RGBCOLOR(r: 108 , 108, 108)
        startTimeL.font = UIFont.systemFont(ofSize: 15)
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
        
        let midLine = UILabel()
        midLine.text = "----"
        midLine.textColor = RGBCOLOR(r: 58, 58, 58)
        midLine.font = UIFont.systemFont(ofSize: 14)
        dateView.addSubview(midLine)
        midLine.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateView.snp.top).offset(90)
            make.centerX.equalTo(dateView.snp.centerX).offset(0)
        }
        
        
        
        let endTimeL = UILabel()
        endTimeL.text = "选择结束时间"
        self.EndTime_L = endTimeL
        endTimeL.textColor = RGBCOLOR(r: 108 , 108, 108)
        endTimeL.font = UIFont.systemFont(ofSize: 15)
        dateView.addSubview(endTimeL)
        endTimeL.snp.makeConstraints { (make) in
            make.centerY.equalTo(dateView.snp.top).offset(90)
            make.right.equalTo(dateView).offset(-20)
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
        timeView.backgroundColor = RGBCOLOR(r: 238, 238, 238)
        self.view.addSubview(timeView)
        timeView.snp.makeConstraints { (make) in
            
            make.top.equalTo(self.view).offset(-280)
            make.left.right.equalTo(self.view).offset(0)
            make.height.equalTo(280)
            
        }
        
        let img = UIImageView()
        timeView.addSubview(img)
        img.contentMode = UIViewContentMode.scaleAspectFill
        img.image = UIImage.init(named: "watch")
        img.cornerRadius = 100
        img.clipsToBounds = true
        img.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(timeView)
            make.top.equalTo(timeView.snp.top).offset(20)
            make.size.equalTo(CGSize(width:190, height:190))
        }
        
        
        let timePicker = UIPickerView.init()
        self.pickerView = timePicker
        timeView.addSubview(timePicker)
        timePicker.dataSource = self
        timePicker.delegate = self
        timePicker.snp.makeConstraints { (make) in
            
            make.center.equalTo(img)
            make.size.equalTo(CGSize(width:150, height:150))
        }
        
        
        let hour = UILabel()
        hour.text = "时"
        hour.font = UIFont.systemFont(ofSize: 10)
        hour.textColor = RGBCOLOR(r: 83, 147, 185)
        timeView.addSubview(hour)
        hour.snp.makeConstraints { (make) in
            make.centerY.equalTo(timePicker.snp.centerY).offset(-7)
            make.centerX.equalTo(timePicker.snp.centerX).offset(-10)
        }
        
        let min = UILabel()
        min.text = "分"
        min.font = UIFont.systemFont(ofSize: 10)
        min.textColor = RGBCOLOR(r: 83, 147, 185)
        timeView.addSubview(min)
        min.snp.makeConstraints { (make) in
            make.centerY.equalTo(timePicker.snp.centerY).offset(-7)
            make.centerX.equalTo(timePicker.snp.centerX).offset(60)
        }
        
        let line = UIView()
        timeView.addSubview(line)
        line.backgroundColor = UIColor.lightGray
        line.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(timeView).offset(0)
            make.height.equalTo(1)
            make.bottom.equalTo(timeView.snp.bottom).offset(-50)
            
        }
        
        
        let cancleBtn = UIButton()
        timeView.addSubview(cancleBtn)
        cancleBtn.setTitleColor(RGBCOLOR(r: 83 , 147, 185), for: UIControlState.normal)
        cancleBtn.setTitle("取消", for: UIControlState.normal )
        cancleBtn.addTarget(self, action: #selector(timeCancleBtnClick), for: UIControlEvents.touchUpInside)
        cancleBtn.snp.makeConstraints { (make)in
            
            make.bottom.equalTo(timeView.snp.bottom).offset(0)
            make.left.equalTo(timeView).offset(0)
            make.size.equalTo(CGSize(width:ScreenW / 2 , height:50))
        }
        
        let sureBtn = UIButton()
        timeView.addSubview(sureBtn)
        sureBtn.setTitleColor(RGBCOLOR(r: 83, 147, 185), for: UIControlState.normal)
        sureBtn.setTitle("确定", for: UIControlState.normal )
        sureBtn.addTarget(self, action: #selector(timeSureBtnClick), for: UIControlEvents.touchUpInside)
        sureBtn.snp.makeConstraints { (make)in
            
            make.bottom.equalTo(timeView.snp.bottom).offset(0)
            make.right.equalTo(timeView.snp.right).offset(0)
            make.size.equalTo(CGSize(width:ScreenW / 2 , height:50))
        }
        
        
    }
    
    @objc func timeCancleBtnClick() {
        
        self.isShowTimeView = false
        self.closeSelectTimeView()
    
        
    }
    @objc func timeSureBtnClick() {
        
        if self.pickerView?.tag == selectTimeType.startTimeType.rawValue {
        
            let isToday = self.dateIsEqualToToday(date: self.DateStr!)
            
            if isToday {
                
                //时间对比
                let b = self.compareStartTimeAndEndTime(startTime: self.nowHour, endTime: self.cacheTime)
                
                if !b{
                    
                    ZNCustomAlertView.handleTip("请选择当前时间之前的时间", isShowCancelBtn: false, completion: { (issure) in
                        
                    })
                    
                    return
                }
                
            }
            
            
            self.StartTime_L?.text = self.cacheTime
            self.StartTime_L?.textColor = RGBCOLOR(r: 58, 58, 58)
            self.StartTimeStr = self.cacheTime
            
        }else if self.pickerView?.tag == selectTimeType.endTimeType.rawValue {
            
            if self.StartTimeStr != nil {
                
                let right = self.compareStartTimeAndEndTime(startTime: self.StartTimeStr!, endTime: self.cacheTime)
                
                if !right {
                    
                    ZNCustomAlertView.handleTip("结束时间不得小于开始时间", isShowCancelBtn: false, completion: { (issure) in
                        
                    })
                    return
                }
                
            }
            
            
            
            
            
            self.EndTime_L?.text = self.cacheTime
            self.EndTime_L?.textColor = RGBCOLOR(r: 58, 58, 58)
            self.EndTimeStr = self.cacheTime
            
            self.getData()

        }

        
        
        self.isShowTimeView = false
        self.closeSelectTimeView()
        
        
        
    }
    
    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy年MM月dd日"
        print(formatter.string(from: datePicker.date))
        
        
        self.DateStr = formatter.string(from: datePicker.date)
        self.Date_L?.text = formatter.string(from: datePicker.date)
        self.Date_L?.textColor = RGBCOLOR(r: 58, 58, 58)
        self.selectDate()
        
        
    }
    
    func getData() {
        
        if((self.DateStr != nil) && (self.StartTimeStr != nil) && (self.EndTimeStr != nil)){
            
            YJProgressHUD.showProgress(nil, in: UIApplication.shared.keyWindow)
            
            weak var weakSelf = self // ADD THIS LINE AS WELL
            
            UserCenter.shared.userInfo { (islogin, userInfo) in
                
                let para = ["companyCode":userInfo.companyCode ,
                            "orgCode":userInfo.orgCode ,
                            "empNo":self.WorkerModel?.empNo ,
                            "empName":self.WorkerModel?.empName,
                            "startTime":self.DateStr! + " " + self.StartTimeStr!,
                            "endTime":self.DateStr! + " " + self.EndTimeStr!,
                            ]
                
                NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: getEmpPointsUrl, modelClass: "TrackPlayBackModel" , response: { (obj) in
                    
                    YJProgressHUD.hide()
                    
                    let model = obj as! TrackPlayBackModel
                    
                    if model.statusCode == 800 {
                        
                        self.Data = model
                        
                        let count = Int(model.returnObj!.count)
                        if( count > 0){
                            
                            self._mapView.removeAnnotations(self._mapView.annotations)

                            
                            let array = NSMutableArray()
                            array.add(model.returnObj?.first as Any)
                            array.add(model.returnObj?.last as Any)
                            
                            self.AddAnnotations(array: array as NSArray)
                            self.bottomplayview.isHidden = false

                        }else{
                            
                            self.bottomplayview.isHidden = true
                            
                            self._mapView.removeAnnotations(self._mapView.annotations)
                            
                            ZNCustomAlertView.handleTip("所选取时间段内并无当前员工的活动记录。", isShowCancelBtn: false, completion: { (issure) in
                                
                                
                            })
                        }
                        
                        
                        self.addTrackLine(array: model.returnObj! as NSArray)

                    }
                    
                    
                }, failture: { (error) in
                    
                    YJProgressHUD.hide()
                    
                    
                })
                
                
            }
            
            
        }
        
    }
    
    func addTrackLine(array:NSArray) {
        
        
//        _mapView.removeAnnotations(_mapView.annotations)
        _mapView.removeOverlays(_mapView.overlays)
        
        
        var tempPoints = [CLLocationCoordinate2D]()
        
        
//        let globalQueue = DispatchQueue.global()
//        globalQueue.async {

            for (index ,value) in array.enumerated() {
                print(index, value)
                
                let model = value as! TrackPlayBackReturnObjModel
                
                let coor : CLLocationCoordinate2D = CLLocationCoordinate2D.init(latitude:Double(model.latitude!)!, longitude: Double(model.longitude!)!)
                
                tempPoints.append(coor)
                
            }
            
//            let mainQueue = DispatchQueue.main
//            mainQueue.async {
            
                self.polyLine = BMKPolyline.init(coordinates: &tempPoints, count: UInt(tempPoints.count))
                
                
                //添加路线,绘图
                if ((self.polyLine) != nil) {
                    self._mapView.add(self.polyLine)
                }
                
                // 清空 tempPoints 临时数组
                tempPoints = []
                
                // 根据polyline设置地图范围
                self.mapViewFitPolyLine(polyline: self.polyLine)
//
//            }
//
//        }
    }
    
    
    func mapViewFitPolyLine(polyline: BMKPolyline!) {
        
        if polyline.pointCount < 1 {
            
            return
            
        }
        
        
        let pt = polyline.points[0]
        
        var ltX = pt.x
        
        var rbX = pt.x
        
        var ltY = pt.y
        
        var rbY = pt.y
        
        
        
        for i in 1..<polyline.pointCount {
            
            let pt = polyline.points[Int(i)]
            
            if pt.x < ltX {
                ltX = pt.x
            }
            if pt.x > rbX {
                rbX = pt.x
            }
            
            if pt.y > ltY {
                ltY = pt.y
            }
            if pt.y < rbY {
                rbY = pt.y
            }
            
        }
        
        
        
        let rect = BMKMapRectMake(ltX, ltY, rbX - ltX, rbY - ltY)
        
        _mapView!.visibleMapRect = rect
        
        _mapView!.zoomLevel = _mapView!.zoomLevel - 0.3
        
    }
    
    func AddAnnotations(array:NSArray) {
        
        let itemArray : NSMutableArray = []
        
        for i in 0..<array.count{
            
            let m = array[i] as! TrackPlayBackReturnObjModel
            
            let item = CustPointAnnotation()
            
            item.coordinate = CLLocationCoordinate2D.init(latitude: Double(m.latitude!)! , longitude: Double(m.longitude!)!)
            item.isStartAnno = (i == 0 ? starOrEnd.star.rawValue : starOrEnd.end.rawValue)
            item.Model = m
            
            itemArray.add(item)
            
        }
        
        self.startAnnotation = itemArray.firstObject as! CustPointAnnotation
        
        self._mapView?.addAnnotations(itemArray as! [Any])
        
        
    }
    
    
    @objc func selectDate () {
        
        if self.isShowTimeView {
            self.closeSelectTimeView()
        }
        
        if !self.isShowDateView {
            
            self.isShowDateView = true
            
            self.calendarContentView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(NavHeight + 120)

            })

            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()
            })
            
        }else{
            
        }
        
    }
    
    func closeSelectDateView() {
        
        self.isShowDateView = false
        
        self.calendarContentView.snp.updateConstraints({ (make) in
            
            make.top.equalTo(self.view).offset(-300)
            
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.layoutIfNeeded()
        })
        
    }
    
    @objc func selectStartTime () {
        
        if self.isShowDateView{
            
            self.closeSelectDateView()
        }
        
        if self.DateStr == nil{
            
            ZNCustomAlertView.handleTip("请先选择日期时间", isShowCancelBtn: false, completion: { (issure) in
                
            })
            return
        }
        
        
        if !self.isShowTimeView {
            
            self.isShowTimeView = true
            
            self.pickerView?.tag = selectTimeType.startTimeType.rawValue
            
            self.timeSelectView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(NavHeight + 120)

            })
            
            if (self.StartTimeStr != nil){
                
                let arr = self.StartTimeStr?.components(separatedBy: ":")
               
                self.pickerView?.selectRow(Int((arr?.first!)!)! , inComponent: 0, animated: false)
                self.selectRow0 = Int((arr?.first!)!)!
                self.pickerView?.reloadComponent(0)
                
                self.pickerView?.selectRow(Int((arr?.last!)!)!, inComponent:1, animated: false)
                self.selectRow1 = Int((arr?.last!)!)!
                self.pickerView?.reloadComponent(1)

            }else{
                
                let arr = self.nowHour.components(separatedBy: ":")
                
                self.pickerView?.selectRow(Int(arr.first!)! , inComponent: 0, animated: false)
                self.selectRow0 = Int(arr.first!)!
                self.pickerView?.reloadComponent(0)
                
                self.pickerView?.selectRow(Int(arr.last!)!, inComponent:1, animated: false)
                self.selectRow1 = Int(arr.last!)!
                self.pickerView?.reloadComponent(1)
                

            }
            

            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()

            }, completion: { (bool) in
                
                
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                
            })
            
        }else{
            
            self.isShowTimeView = false
            
            self.pickerView?.tag = selectTimeType.startTimeType.rawValue
        }
        
    }
    
    @objc func selectEndTime () {
        
        if self.DateStr == nil{
            
            ZNCustomAlertView.handleTip("请先选择日期时间", isShowCancelBtn: false, completion: { (issure) in
                
            })
            return
        }
        
        if self.StartTimeStr == nil {
            
            ZNCustomAlertView.handleTip("请选择开始时间", isShowCancelBtn: false, completion: { (issure) in
                
            })
            
            return
            
        }
        
        
        if self.isShowDateView{
            
            self.closeSelectDateView()
        }
        
        if !self.isShowTimeView {
            
            self.isShowTimeView = true
            
            self.pickerView?.tag = selectTimeType.endTimeType.rawValue

            self.timeSelectView.snp.updateConstraints({ (make) in
                
                make.top.equalTo(self.view).offset(NavHeight + 120)
                
            })
            
            
            if (self.EndTimeStr != nil){
                
                let arr = self.EndTimeStr?.components(separatedBy: ":")
                
                self.pickerView?.selectRow(Int((arr?.first!)!)! , inComponent: 0, animated: false)
                self.selectRow0 = Int((arr?.first!)!)!
                self.pickerView?.reloadComponent(0)
                
                self.pickerView?.selectRow(Int((arr?.last!)!)!, inComponent:1, animated: false)
                self.selectRow1 = Int((arr?.last!)!)!
                self.pickerView?.reloadComponent(1)
                
            }else{
                
                let arr = self.StartTimeStr?.components(separatedBy: ":")
                
                self.pickerView?.selectRow(Int((arr?.first!)!)! , inComponent: 0, animated: false)
                self.selectRow0 = Int((arr?.first!)!)!
                self.pickerView?.reloadComponent(0)
                
                self.pickerView?.selectRow(Int((arr?.last!)!)!, inComponent:1, animated: false)
                self.selectRow1 = Int((arr?.last!)!)!
                self.pickerView?.reloadComponent(1)
                
                
            }
            
            
            UIView.animate(withDuration: 0.2, animations: {
                
                self.view.layoutIfNeeded()
            })
            
        }else{
            
            self.pickerView?.tag = selectTimeType.endTimeType.rawValue
        }
        
    }
    
    func closeSelectTimeView() {
        
        self.isShowTimeView = false
        self.timeSelectView.snp.updateConstraints({ (make) in
            
            make.top.equalTo(self.view).offset(-300)
        })
        
        UIView.animate(withDuration: 0.2, animations: {
            
            self.view.layoutIfNeeded()
        })
        
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
        title.font = UIFont.systemFont(ofSize: 15)
        title.textColor = RGBCOLOR(r: 58, 58, 58)
        
        //改变选中行颜色（设置一个全局变量，在选择结束后获取到当前显示行，记录下来，刷新picker）
        if(component == 0){
            if (row == selectRow0) {
                //改变当前显示行的字体颜色，如果你愿意，也可以改变字体大小，状态
                title.textColor = RGBCOLOR(r: 83, 147, 185)
            }
            
        }else{
            
            if (row == selectRow1) {
                //改变当前显示行的字体颜色，如果你愿意，也可以改变字体大小，状态
                title.textColor = RGBCOLOR(r: 83, 147, 185)
            }
        }
       
        
        //  设置横线的颜色，实现显示或者隐藏
        let line : UIView = pickerView.subviews[1]
        line.backgroundColor = UIColor.clear
        
        let line2 : UIView = pickerView.subviews[2]
        line2.backgroundColor = UIColor.clear
        
        return title
    }
    

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let arr = self.cacheTime.components(separatedBy: ":")
        
        var HourStr : String = arr.first!
        var minStr : String = arr.last!
        
        component == 0 ? (HourStr = self.HourArray[row] as! String) : (minStr = self.minuteArray[row] as! String)
        
        self.cacheTime = HourStr + ":" + minStr
        
        
        //记录下滚动结束时的行数
        component == 0 ? (selectRow0 = row) : (selectRow1 = row)
        //刷新picker，看上面的代理
        pickerView.reloadComponent(component)
    }
    
    func setbottonPlayView() {
        
        let bottom = (Bundle.main.loadNibNamed("bottomPlayView", owner: nil, options: nil)![0] as! bottomPlayView)
        self.bottomplayview = bottom
        bottom.isHidden = true
        self.view.addSubview(bottom)
        bottom.delegate = self
        bottom.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
            make.bottom.equalTo(self.view).offset(-20)
            make.height.equalTo(60)
        }
        
        bottom.layer.cornerRadius = 6
        bottom.layer.shadowColor = UIColor.darkGray.cgColor;
        bottom.layer.shadowOffset = CGSize(width:2, height:2);
        bottom.layer.shadowOpacity = 0.5;
        bottom.layer.shadowRadius = 5;

    }
    
    func playBtnClick(btn: UIButton) {
        
        if !btn.isSelected {
            
//            _mapView.removeAnnotation(self.startAnnotation)
//
//            let item = CustPointAnnotation()
//            let m = self.Data?.returnObj!.first
//            item.coordinate = CLLocationCoordinate2D.init(latitude: Double(m!.latitude!)! , longitude: Double(m!.longitude!)!)
//            item.Model = m
//            self.midAnnotation = item
//            _mapView.addAnnotation(item)
            
            //开始播放
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(starPlayTrackAni), userInfo: nil, repeats: true)
            
            
        }else{
            
            self.stropPlayTrackaAni()
        }
        
        
    }
    
    @objc func starPlayTrackAni() {
        
//        let arr = NSMutableArray()
//        arr.add(self.Data?.returnObj?.first)
//        arr.add(self.Data?.returnObj?.last)
//        arr.add(self.Data?.returnObj![self.timerCount])
        
        if(self.timerCount == (self.Data?.returnObj?.count)!){
            
                
            let m = self.Data?.returnObj![0]
            self.startAnnotation?.coordinate =  CLLocationCoordinate2D.init(latitude: Double(m!.latitude!)! , longitude: Double(m!.longitude!)!)
                
            self.bottomplayview.progressView.progress = 0.0
            self.bottomplayview.playBtn.isSelected = false
            self.stropPlayTrackaAni()
            self.timerCount = 0
            return
            
        }
        
        
        let m = self.Data?.returnObj![self.timerCount]
        
        UIView.animate(withDuration: 0.1) {
            
            self.startAnnotation?.coordinate =  CLLocationCoordinate2D.init(latitude: Double(m!.latitude!)! , longitude: Double(m!.longitude!)!)
            
            self.bottomplayview.progressView.progress = Float(Float(self.timerCount) / Float(((self.Data?.returnObj?.count)! - 1)))
        }
        
  
        
        self.timerCount += 1
        
    }
    
    func stropPlayTrackaAni() {
        
        guard let timer1 = self.timer
            else{ return }
        timer1.invalidate()
        
    }
    
    
    func compareStartTimeAndEndTime(startTime:String , endTime : String) -> (Bool) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        let date1 = formatter.date(from: startTime)! as NSDate
        let date2 = formatter.date(from: endTime)! as NSDate
        
        
        let result:ComparisonResult = date1.compare(date2 as Date)
        
        if result == ComparisonResult.orderedDescending{
            print("date1 > date2")

            return false
        }
        

        return true
        
    }
    
    func dateIslastWithToday(date:String ) -> (Bool) {

        let now = Date()
        // 创建一个日期格式器
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        print("当前日期时间：\(formatter.string(from: now))")
        
        let date2 = formatter.date(from: date)! as NSDate
        
        
        let result:ComparisonResult = now.compare(date2 as Date)
        
        if result == ComparisonResult.orderedDescending{
            print("now > date2")
            
            return false
        }
        
        
        return true
        
    }
    
    func dateIsEqualToToday(date:String) -> (Bool){
    
        // 获取本地时区
        let localZone : NSTimeZone = NSTimeZone.local as NSTimeZone
        
        let now : NSDate = NSDate()

        // 计算本地时区与 GMT 时区的时间差
        let second:Int = localZone.secondsFromGMT
        // 在 GMT 时间基础上追加时间差值，得到本地时间
        let date1 = now.addingTimeInterval(TimeInterval(second))
        
        // 创建一个日期格式器
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date2 = formatter.string(from: now as Date)
        
        
     
        if date ==  date2 {
            print("它们是同一天")
            
            return true
        }else {
            print("它们不是同一天")
            
            return false
        }
        

        return false
    
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
