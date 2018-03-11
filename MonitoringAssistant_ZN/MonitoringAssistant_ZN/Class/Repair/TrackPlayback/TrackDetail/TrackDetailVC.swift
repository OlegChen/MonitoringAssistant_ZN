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
    var selectRow = 0

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
    
    var midAnnotation : CustPointAnnotation?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "轨迹回放"
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        
        
        self.setCalendarView()
        
        self.setSelectTimeView()
        
        self.setDateSelectView()  //顶部view

        self.setbottonPlayView()
        
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
        
        let newAnnotationView = CustomTrackDetailAnnotationView.init(annotation: annotation, reuseIdentifier: "12345")
        newAnnotationView?.img = custAnnotation.Model?.headUrl
        
        
        newAnnotationView?.centerOffset = CGPoint(x:10, y:-20) ;
        newAnnotationView?.animatesDrop = false
        
//
//        let custView = TrackPlayBackPopView.init(frame: CGRect(x: 0 , y : 0 , width: 120 , height: 120 ))
//        custView.delegate = self
//        let popView = BMKActionPaopaoView.init(customView: custView )
//
//        newAnnotationView?.paopaoView = nil
//        newAnnotationView?.paopaoView = popView
        
        return newAnnotationView;
        
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor overlay: BMKOverlay!) -> BMKOverlayView! {
        
        if let overlayTemp = overlay as? BMKPolyline {
            let polylineView = BMKPolylineView(overlay: overlay)
            if overlayTemp == polyLine {
                polylineView?.strokeColor = UIColor(red: 0, green: 1, blue: 0, alpha: 1)
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd"
        print(formatter.string(from: date))
        
        
        self.DateStr = formatter.string(from: date)
        self.Date_L?.text = "查询日期 " + formatter.string(from: date)
        self.selectDate()
        
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
            
            make.top.equalTo(self.view).offset(-210)
            make.left.right.equalTo(self.view).offset(0)
            make.height.equalTo(210)
            
        }
        
        let img = UIImageView()
        timeView.addSubview(img)
        img.contentMode = UIViewContentMode.scaleAspectFill
        img.image = UIImage.init(named: "watch")
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
        
        
        let hour = UILabel()
        hour.text = "时"
        hour.font = UIFont.systemFont(ofSize: 12)
        hour.textColor = RGBCOLOR(r: 83, 147, 185)
        timeView.addSubview(hour)
        hour.snp.makeConstraints { (make) in
            make.centerY.equalTo(timePicker.snp.centerY).offset(-7)
            make.centerX.equalTo(timePicker.snp.centerX).offset(0)
        }
        
        let min = UILabel()
        min.text = "分"
        min.font = UIFont.systemFont(ofSize: 12)
        min.textColor = RGBCOLOR(r: 83, 147, 185)
        timeView.addSubview(min)
        min.snp.makeConstraints { (make) in
            make.centerY.equalTo(timePicker.snp.centerY).offset(-7)
            make.centerX.equalTo(timePicker.snp.centerX).offset(50)
        }
        
        let line = UIView()
        timeView.addSubview(line)
        line.backgroundColor = UIColor.lightGray
        line.snp.makeConstraints { (make) in
            
            make.left.right.equalTo(timeView).offset(0)
            make.height.equalTo(0.5)
            make.bottom.equalTo(timeView.snp.bottom).offset(-40)
            
        }
        
        
        let cancleBtn = UIButton()
        timeView.addSubview(cancleBtn)
        cancleBtn.setTitleColor(RGBCOLOR(r: 83 , 147, 185), for: UIControlState.normal)
        cancleBtn.setTitle("取消", for: UIControlState.normal )
        cancleBtn.addTarget(self, action: #selector(timeCancleBtnClick), for: UIControlEvents.touchUpInside)
        cancleBtn.snp.makeConstraints { (make)in
            
            make.bottom.equalTo(timeView.snp.bottom).offset(0)
            make.left.equalTo(timeView).offset(0)
            make.size.equalTo(CGSize(width:ScreenW / 2 , height:40))
        }
        
        let sureBtn = UIButton()
        timeView.addSubview(sureBtn)
        sureBtn.setTitleColor(RGBCOLOR(r: 83, 147, 185), for: UIControlState.normal)
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
        self.closeSelectTimeView()
    
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
        self.closeSelectTimeView()
        
        
        self.getData()
        
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
                            "startTime":self.DateStr! + " " + self.StartTimeStr!,
                            "endTime":self.DateStr! + " " + self.EndTimeStr!,
                            ]
                
                NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: getEmpPointsUrl, modelClass: "TrackPlayBackModel" , response: { (obj) in
                    
                    let model = obj as! TrackPlayBackModel
                    
                    if model.statusCode == 800 {
                        
                        self.Data = model
                        
                        let count = Int(model.returnObj!.count)
                        if( count > 0){
                            
                            let array = NSMutableArray()
                            array.add(model.returnObj?.first as Any)
                            array.add(model.returnObj?.last as Any)
                            
                            self.AddAnnotations(array: array as NSArray)
                            self.bottomplayview.isHidden = false

                        }else{
                            
                            self.bottomplayview.isHidden = true
                            
                        }
                        
                        
                        self.addTrackLine(array: model.returnObj! as NSArray)

                    }
                    
                    
                }, failture: { (error) in
                    
                    
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
            
          self.closeSelectDateView()
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
            self.closeSelectTimeView()
        }
        
    }
    
    @objc func selectEndTime () {
        
        if self.isShowDateView{
            
            self.closeSelectDateView()
        }
        
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
            
            self.pickerView?.tag = selectTimeType.endTimeType.rawValue
           self.closeSelectTimeView()
        }
        
    }
    
    func closeSelectTimeView() {
        
        self.selectRow = 0
        
        self.isShowTimeView = false
        self.timeSelectView.snp.updateConstraints({ (make) in
            
            make.top.equalTo(self.view).offset(-210)
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
        title.font = UIFont.systemFont(ofSize: 13)
        title.textColor = RGBCOLOR(r: 58, 58, 58)
        
        //改变选中行颜色（设置一个全局变量，在选择结束后获取到当前显示行，记录下来，刷新picker）
        if (row == selectRow) {
            //改变当前显示行的字体颜色，如果你愿意，也可以改变字体大小，状态
            title.textColor = RGBCOLOR(r: 83, 147, 185)
        }

        
        return title
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var HourStr : String = "00"
        var minStr : String = "00"
        
        component == 0 ? (HourStr = self.HourArray[row] as! String) : (minStr = self.minuteArray[row] as! String)
        
        self.cacheTime = HourStr + ":" + minStr
        
        
        //记录下滚动结束时的行数
        selectRow = row;
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
            
            make.left.right.bottom.equalTo(self.view).offset(0)
            make.height.equalTo(70)
        }

    }
    
    func playBtnClick(btn: UIButton) {
        
        if !btn.isSelected {
            
            let item = CustPointAnnotation()
            let m = self.Data?.returnObj!.first
            item.coordinate = CLLocationCoordinate2D.init(latitude: Double(m!.latitude!)! , longitude: Double(m!.longitude!)!)
            item.Model = m
            self.midAnnotation = item
            _mapView.addAnnotation(item)
            
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
            
            _mapView.removeAnnotation(self.midAnnotation)
            self.bottomplayview.progressView.progress = 0.0
            
            self.stropPlayTrackaAni()
            self.timerCount = 0
            return
            
        }
        
        let m = self.Data?.returnObj![self.timerCount]
        
        UIView.animate(withDuration: 0.1) {
            
            self.midAnnotation?.coordinate =  CLLocationCoordinate2D.init(latitude: Double(m!.latitude!)! , longitude: Double(m!.longitude!)!)
            
            self.bottomplayview.progressView.progress = Float(Float(self.timerCount) / Float(((self.Data?.returnObj?.count)! - 1)))
        }
        
  
        
        self.timerCount += 1
        
    }
    
    func stropPlayTrackaAni() {
        
        guard let timer1 = self.timer
            else{ return }
        timer1.invalidate()
        
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
