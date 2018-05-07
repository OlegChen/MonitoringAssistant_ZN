//
//  onlineRepaire.swift
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/9.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit


class onlineRepaire: BaseVC ,BMKLocationAuthDelegate ,BMKLocationManagerDelegate{

    var container : olineRepaireContentTableview!
    
    var locationManager : BMKLocationManager!
    var completionBlock : BMKLocatingCompletionBlock!
    
//    var longitudeStr : Double = 0
//    var latitudeStr : Double = 0

    var location : CLLocationCoordinate2D?
    
    
    @IBOutlet weak var sureBtn: UIButton!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "故障报修"
        
        self.sureBtn.layer.shadowColor = UIColor.black.cgColor
        self.sureBtn.layer.shadowOffset = CGSize(width:2 , height:2)
        self.sureBtn.layer.shadowOpacity = 0.3
        self.sureBtn.layer.shadowRadius = 3
        
        BMKLocationAuth.sharedInstance().checkPermision(withKey: "T861GXQXTnAYjvF1MxfGlGpXGgFg4yhY", authDelegate: self)
        
        locationManager = BMKLocationManager.init()
        locationManager.delegate = self as! BMKLocationManagerDelegate
        locationManager.coordinateType = BMKLocationCoordinateType.BMK09LL
        
        locationManager.distanceFilter = kCLDistanceFilterNone;
        //设置预期精度参数
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        //设置应用位置类型
        locationManager.activityType = CLActivityType.other;
        //设置是否自动停止位置更新
        locationManager.pausesLocationUpdatesAutomatically = false;
        //设置是否允许后台定位
        locationManager.allowsBackgroundLocationUpdates = false;
        //设置位置获取超时时间
        locationManager.locationTimeout = 5;
        //设置获取地址信息超时时间
        locationManager.reGeocodeTimeout = 5;
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        locationManager.requestLocation(withReGeocode: true, withNetworkState: false) { (location, netWorkState, error) in
            
            let loc = location as! BMKLocation

            if (loc.location != nil) {//得到定位信息
                
                self.location = loc.location?.coordinate
                
            }
            
            if (loc.rgcData != nil) {
                
                var str : String!
                
                str = (loc.rgcData?.city)! + (loc.rgcData?.district)!
                
                if let street = loc.rgcData?.street {
                    
                    str = str + street
                }
                
                if let streetNum = loc.rgcData?.streetNumber {
                    
                    str = str + streetNum
                }
                
                if  let poi : BMKLocationPoi = loc.rgcData?.poiList.first {
                    
                    str = str + poi.name
                }
                
                self.container.address.text = str

            }
            
        }
        
        
    }
    
    
    @IBAction func sureBtnClick(_ sender: UIButton) {
        
        weak var weakSelf = self // ADD THIS LINE AS WELL
        
        if(self.location == nil){
            
            ZNCustomAlertView.handleTip("定位失败,查看设置中定位是否打开", isShowCancelBtn: false, completion: { (isSure) in
                
            })
            
            return
        }
        
        
        if ((container.wokerName.text!.characters.count > 0) && (container.tel.text!.characters.count == 11) && (container.address.text!.characters.count > 0) && (container.contentTextView.text.characters.count > 0) && (container.selectedRepaireTypeModel != nil)){
            
            

            //手机号正则
            let regex = "^(13[0-9]|14[579]|15[0-3,5-9]|16[6]|17[0135678]|18[0-9]|19[89])\\d{8}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
            let isValid = predicate.evaluate(with: self.container.tel.text)
            print(isValid ? "正确的手机号" : "错误的手机号")
            if isValid {
                
                
            }else{
                
                ZNCustomAlertView.handleTip("请填写正确的手机号", isShowCancelBtn: false, completion: { (isure) in
                    
                })
                
                return
            }
            
            //报修内容不能全是空格
            
            var count : Int = 0
            
            for i in container.contentTextView.text.characters {
                print(i)
                
                if (i == " "){
                    
                    count = count + 1
                }
                
            }
       
            if count == container.contentTextView.text.count{
                
                ZNCustomAlertView.handleTip("请填写报修内容", isShowCancelBtn: false, completion: { (sisure) in
                    
                })
                
                return
            }
            
            
            YJProgressHUD.showProgress(nil, in: UIApplication.shared.keyWindow)

            UserCenter.shared.userInfo { (islogin, userInfo) in
                
//                let index = self.longitudeStr.index((self.longitudeStr.startIndex), offsetBy: 8 )
                
                
                let dic = [
                           "companyCode":userInfo.companyCode ,
                           "orgCode":userInfo.orgCode ,
                           "empNo":userInfo.empNo ,
                           "empName":userInfo.empName,
                           "contactMan":self.container.wokerName.text,
                           "tel": self.container.tel.text,
                           "address" : self.container.address.text,
                           "workType" : self.container.selectedRepaireTypeModel?.workType,
                           "repairsDesc" : self.container.contentTextView.text,
                           "longitude": String(format:"%f", self.location!.longitude) ,
                           "latitude": String(format:"%f", self.location!.latitude)
                    ] as [String : Any]
                
                let para = NSMutableDictionary.init(dictionary:dic )

                
                
                if((self.container.imageArr.count) > 0){
                    
                    let imgArr = NSMutableArray()
                    
                    for i in 0..<(weakSelf?.container.imageArr.count)! {
                        
                        let image = weakSelf?.container.imageArr[i] as! UIImage
//                        let data = UIImageJPEGRepresentation(image as! UIImage,0.1);
                        
                        let data = image.compress(withMaxLength: 3 * 1024 * 1024)
                        
                        print( Double((data?.count)!)/1024.0/1024.0)
                        
                        let imageBase64String = data!.base64EncodedString()
                        
                        imgArr.add(imageBase64String)
                        
                    }
                    
                    
                    
                    let data = try? JSONSerialization.data(withJSONObject: imgArr, options: JSONSerialization.WritingOptions.prettyPrinted)
                    let strJson = NSString(data:data!, encoding: String.Encoding.utf8.rawValue)
                    
                    para.setValue(imgArr.componentsJoined(by: ","), forKey:"base64ListIOS" )
                    para.setValue("1", forKey: "isIOS")
                }
 
                NetworkService.networkPostrequest(parameters: para as! [String : Any], requestApi: commitUrl, modelClass: "BaseModel", response: { (obj) in
                    
                    let model = obj as! BaseModel
                    
                    if(model.statusCode == 800){
                        
                        self.navigationController?.popViewController(animated: true)
                    }else{
                        
                        ZNCustomAlertView.handleTip(model.msg, isShowCancelBtn: false, completion: { (issure) in
                            
                        })
                        
                    }
                    
                    YJProgressHUD.hide()
                    
                }, failture: { (error) in
                    
                    
                    YJProgressHUD.hide()
                })
                
                
            }
            
        }else{
            
            var tip = ""
            
            
              if (!(container.wokerName.text!.characters.count > 0)){
                
                tip = "请填写维修人员"
                
              }else if (!(container.tel.text!.characters.count > 0)){
                
                tip = "请填写联系电话"
              }else if (!(container.tel.text!.characters.count == 11)){
                
                tip = "请填写正确的手机号"
              }else if( !(container.address.text!.characters.count > 0) ){
                
                tip = "请填写具体位置"
                
              }else if( container.selectedRepaireTypeModel == nil){
                
                tip = "请选择报修类型"
                
              }else if( !(container.contentTextView.text.characters.count > 0)){
                
                tip = "请填写报修内容"
            }
            
            
            ZNCustomAlertView.handleTip(tip, isShowCancelBtn: false, completion: { (isSure) in
                
            })
            
        }
        
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "containerView"  {

            self.container = segue.destination as! olineRepaireContentTableview

        }

    }
    

}




