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

    lazy var dataArr : NSMutableArray = {
        
        let array = NSMutableArray()
        return array
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "用能监测"
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        
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
    
            let AnnotationViewID = "123123"
            
//            var newAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: AnnotationViewID) as?  BMKPinAnnotationView
//
//            if newAnnotation == nil {
        
                var newAnnotation = BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: AnnotationViewID)
                
                let popView = Bundle.main.loadNibNamed("EnergyMonitorPopView", owner: nil, options: nil)?[0] as! EnergyMonitorPopView
                let custPopView =  BMKActionPaopaoView.init(customView: popView)
        
        
        let custAnnotation = annotation as! monitorCustomAnnotation
        popView.titleL.text  = custAnnotation.model?.stationName
        popView.label1.text = custAnnotation.model?.stationNo
        popView.label2.text = custAnnotation.model?.stationType
        
                
                newAnnotation?.paopaoView = nil
                newAnnotation?.paopaoView = custPopView
//            }
        
            //BMKPinAnnotationView.init(annotation: annotation, reuseIdentifier: AnnotationViewID)  //as! BMKPinAnnotationView //[[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 从天上掉下效果
        newAnnotation?.animatesDrop = false
            // 设置可拖拽
        newAnnotation?.isDraggable = false
            //设置大头针图标
        newAnnotation?.image = UIImage.init(named: "未标题-1")
            
//            if (newAnnotation.paopaoView as AnyObject).isKind(of: EnergyMonitorPopView.self) == false {
//
//
//            }
            
     
            
        return newAnnotation;
            
    
        }
    
    
    func getData() {
        
        
        weak var weakSelf = self // ADD THIS LINE AS WELL

        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ]
            
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: moniterDataUrl, modelClass: "moniterDataModel" , response: { (obj) in
                
                let model = obj as! moniterDataModel
                
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
        
        
        for var model in array {
            
            let m = model as! moniterDataPointsModel
            
            let item = monitorCustomAnnotation()
   
            item.coordinate = CLLocationCoordinate2D.init(latitude: Double(m.latitude!)! , longitude: Double(m.longitude!)!)
            
            item.model = m
            
            itemArray.add(item)

        }

        self._mapView?.addAnnotations(itemArray as! [Any])

        
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
