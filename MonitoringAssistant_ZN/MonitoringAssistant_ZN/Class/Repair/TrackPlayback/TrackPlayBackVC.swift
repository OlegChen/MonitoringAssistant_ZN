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
        
        self.fd_interactivePopDisabled = true
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
        _mapView?.zoomLevel = 13
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    // MARK: -----------  mapview delegate
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        
        
    }
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {

        
        let newAnnotationView = CustomMapAnnotationView.init(annotation: annotation, reuseIdentifier: "12345")
        
        let custAnnotation = annotation as! CustPointAnnotation
        
        
        newAnnotationView?.centerOffset = CGPoint(x:10, y:-20) ;
        
        
        let companyStr = "机构：" + (custAnnotation.Model?.companyAlias)!
        let nameStr = "联系人：" + (custAnnotation.Model?.empName)!
        let telStr = "电话：" + (custAnnotation.Model?.mobile)!
        
        
        let Width1 = self.textSize(text: companyStr, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000 ,height: 20))
        let Width2 = self.textSize(text: nameStr, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000 ,height: 20))
        let Width3 = self.textSize(text: telStr, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000 ,height: 20))
        
        let maxW = max(Width1.width + 20,Width2.width + 20,Width3.width + 20)
        
        let popW = maxW > (ScreenW - 80) ? (ScreenW - 80) : maxW
        
        let custView = TrackPlayBackPopView.init(frame: CGRect(x: 0 , y : 0 , width:popW - 5  , height: 120 ))
            custView.delegate = self
            custView.model = custAnnotation.Model
            custView.companyL.text = companyStr
            custView.nameL.text = nameStr
            custView.TelL.text = telStr
        
        newAnnotationView?.nameLabel.text = custAnnotation.Model?.empName
        
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
                        
                        if let m : TrackPlayBackReturnObjModel = model.returnObj?.first {
                            
                            self._mapView?.centerCoordinate = CLLocationCoordinate2D.init(latitude:Double(m.companyLatitude!)!, longitude:Double(m.longitude!)!)
                            
                        }
                        
                        
                    }
                    
                    
                }, failture: { (error) in
                    
                    
                })
                
                
            }
        
        
        
    }
    
    func AddAnnotations(array:NSArray) {
        
        let itemArray : NSMutableArray = []
        let pointsArray = NSMutableArray()
        
        for var model in array {
            
            let m = model as! TrackPlayBackReturnObjModel
            
            let item = CustPointAnnotation()
            item.coordinate = CLLocationCoordinate2D.init(latitude: Double(m.latitude!)! , longitude: Double(m.longitude!)!)
            item.Model = m
            itemArray.add(item)
            
            let point : BMKMapPoint =  BMKMapPointForCoordinate(item.coordinate);
            pointsArray.add(point)
            
        }
        
        self._mapView?.addAnnotations(itemArray as! [Any])
        
//        self.mapViewFit(pointArray: pointsArray)

        
    }
    
    func TrackBtnClick(model: TrackPlayBackReturnObjModel) {
        
        let VC = TrackDetailVC()
        VC.WorkerModel = model
        self.navigationController?.pushViewController(VC, animated: true)
        
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
