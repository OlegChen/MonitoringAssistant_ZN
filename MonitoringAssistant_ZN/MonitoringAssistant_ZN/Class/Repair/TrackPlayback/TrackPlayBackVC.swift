//
//  TrackPlayBackVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class TrackPlayBackVC: BaseVC , BMKMapViewDelegate,TrackPlayBackPopViewDelegate{

    var _mapView: BMKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "工人分布"
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        _mapView?.zoomLevel = 13
    
        
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
        
        let custView = TrackPlayBackPopView.init(frame: CGRect(x: 0 , y : 0 , width: 120 , height: 120 ))
            custView.delegate = self
            custView.model = custAnnotation.Model
            custView.companyL.text = "机构：" + (custAnnotation.Model?.companyAlias)!
            custView.nameL.text = "联系人：" + (custAnnotation.Model?.empName)!
            custView.TelL.text = "电话：" + (custAnnotation.Model?.mobile)!
        
        
        let popView = BMKActionPaopaoView.init(customView: custView )
        
        newAnnotationView?.paopaoView = nil
        newAnnotationView?.paopaoView = popView
        
        return newAnnotationView;

    }

    
    func getData() {
        
            
            
            weak var weakSelf = self // ADD THIS LINE AS WELL
            
            UserCenter.shared.userInfo { (islogin, userInfo) in
                
                let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ]
                
                
                NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: getAllEmpPointUrl, modelClass: "TrackPlayBackModel" , response: { (obj) in
                    
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
    
    func TrackBtnClick(model: TrackPlayBackReturnObjModel) {
        
        let VC = TrackDetailVC()
        VC.WorkerModel = model
        self.navigationController?.pushViewController(VC, animated: true)
        
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
