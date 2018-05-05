//
//  EnergyMonitorVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EnergyMonitorVC: BaseVC , BMKMapViewDelegate {

    var _mapView: BMKMapView?

    var model : moniterDataModel?
    
    
    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "用能监测"
        
        self.fd_interactivePopDisabled = true
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: CGFloat(NavHeight), width: self.view.frame.width, height: self.view.frame.height - CGFloat(NavHeight)))
        self.view.addSubview(_mapView!)
        _mapView?.isRotateEnabled  = false
        
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
    
    // MARK: -----------  mapview delegate
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        
        
    }

    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
    
        let custAnnotation = annotation as! monitorCustomAnnotation

//        if custAnnotation.model == nil {
//
//            let newAnnotationView = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "centerAnnotation")
//
//            newAnnotationView?.image = UIImage.init(named: "位置")
//            newAnnotationView?.animatesDrop = false //设置该标点动画显示
//            newAnnotationView?.annotation = annotation;
//
//
//            return newAnnotationView;
//
//
//        }else{

        
            let AnnotationViewID = "123123"
            
    //            var newAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as?  BMKPinAnnotationView
    //
    //            if newAnnotation == nil {
            
            let newAnnotation : monitorCustomPinAnnotation  = monitorCustomPinAnnotation.init(annotation: annotation, reuseIdentifier: AnnotationViewID)

            let popView = Bundle.main.loadNibNamed("EnergyMonitorPopView", owner: nil, options: nil)?[0] as! EnergyMonitorPopView
            popView.width = 0
            popView.setData(stationNo:  (custAnnotation.model?.stationNo)!, typeName: (custAnnotation.model?.stationType)! == "032001" ? "锅炉房" : "换热站")


            let custPopView =  BMKActionPaopaoView.init(customView: popView)

            newAnnotation.paopaoView = nil
            newAnnotation.paopaoView = custPopView
            
            newAnnotation.model = custAnnotation.model

                // 从天上掉下效果
            newAnnotation.animatesDrop = false
                // 设置可拖拽
            newAnnotation.isDraggable = false
                //设置大头针图标
            
            if (custAnnotation.model?.stationType == "032001") {
                
                //锅炉房
                
                newAnnotation.image = UIImage.init(named: "蓝标")
            }else {
                
                newAnnotation.image = UIImage.init(named: "紫标")
                
            }
            
         
            return newAnnotation;
            
            
            
            
//        }
        
    
        }
    
    func mapView(_ mapView: BMKMapView!, annotationViewForBubble view: BMKAnnotationView!) {
        


        
    }
    
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        

        
    }
    
    func getData() {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL

        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: moniterDataUrl, modelClass: "moniterDataModel" , response: { (obj) in
                
                let model = obj as! moniterDataModel
                
                self.model = model
                
                self.dataArr.addObjects(from: (model.returnObj?.points)!)

                if let centerLatValue = model.returnObj?.centerLat, let lat = Double(centerLatValue) ,let centerLonValue = model.returnObj?.centerLon, let lon = Double(centerLonValue) {
                    // am
                    weakSelf?._mapView?.centerCoordinate = CLLocationCoordinate2D.init(latitude: lat, longitude:lon)
                }

                //
                self.AddAnnotations(array: self.dataArr )
                
            }) { (error) in
                
            }
            
        }
        
    }
    
    func AddAnnotations(array:NSArray) {
        
        let itemArray : NSMutableArray = []
        
        let pointsArray = NSMutableArray()
        
        
        for var model in array {
            
            let m = model as! moniterDataPointsModel
            
            let item = monitorCustomAnnotation()
            item.coordinate = CLLocationCoordinate2D.init(latitude: Double(m.latitude!)! , longitude: Double(m.longitude!)!)
            item.model = m
            itemArray.add(item)
            
            let point : BMKMapPoint =  BMKMapPointForCoordinate(item.coordinate);
            pointsArray.add(point)

        }

        self._mapView?.addAnnotations(itemArray as! [Any])
        
        self.mapViewFit(pointArray: pointsArray)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute:
            {
                
                self._mapView?.centerCoordinate = CLLocationCoordinate2D.init(latitude: Double((self.model?.returnObj?.centerLat)!)!, longitude:  Double((self.model?.returnObj?.centerLon)!)!)
        })
        
    

      
        
        
        
    }
    
    
    
    func mapViewFit(pointArray: NSArray!) {
        
        if pointArray.count < 1 {
            
            return
        }
        
        let pt = pointArray[0] as! BMKMapPoint
        var ltX = pt.x
        var rbX = pt.x
        var ltY = pt.y
        var rbY = pt.y

        for i in 1..<pointArray.count {
            
            let pt = pointArray[Int(i)] as! BMKMapPoint
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setData(stationNo:String , typeName:String , completionHandler: @escaping (_ width:Double , _ model:StationDetailModel) -> Void) {
        
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "stationNo":stationNo ]
            
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: moniterPointDataUrl, modelClass: "StationDetailModel", response: { (obj) in
                
                let model = obj as! StationDetailModel
                
                
                let titleWidth = self.textSize(text: ((model.returnObj?.stationName)!), font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width: 1000 ,height: 20))
                let addressWidth = self.textSize(text: ("地址：" + (model.returnObj?.address != nil ? (model.returnObj?.address)! : "--")), font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width: 1000 ,height: 20))
                
                let maxW = max(titleWidth.width + 50, addressWidth.width + 50)
                
                var w = 0.0
                
                
                if maxW < 180 {
                    
                    w = 180
                }else if maxW > (ScreenW - 60){
                    
                    w = Double(ScreenW - 60)
                    
                }else{
                    
                    w = Double(maxW)
                    
                }
                
                completionHandler(w, model)
                
                
            }, failture: { (error) in
                
                
            })
            
            
        }
        
    }
    
    
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size
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
