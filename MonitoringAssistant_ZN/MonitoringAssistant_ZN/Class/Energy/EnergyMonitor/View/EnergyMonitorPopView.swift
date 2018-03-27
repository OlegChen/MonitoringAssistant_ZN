//
//  EnergyMonitorPopView.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/16.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class EnergyMonitorPopView: UIView {
    
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    @IBOutlet weak var label5: UILabel!
    
    @IBOutlet weak var label6: UILabel!
    
    
    var rectangleShaplayer : CAShapeLayer!
    var triangleShaplayer : CAShapeLayer!

    
    func setData(stationNo:String , typeName:String) {
        
        
        UserCenter.shared.userInfo { (islogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,
                        "orgCode":userInfo.orgCode ,
                        "empNo":userInfo.empNo ,
                        "empName":userInfo.empName,
                        "stationNo":stationNo ]
            
           
            NetworkService.networkGetrequest(parameters: para as! [String : String], requestApi: moniterPointDataUrl, modelClass: "StationDetailModel", response: { (obj) in
                
                let model = obj as! StationDetailModel
                
                self.titleL.text  = (model.returnObj?.stationName)! + "#" + typeName
                self.label1.text = "地址：" + (model.returnObj?.address != nil ? (model.returnObj?.address)! : "--")
                self.label2.text = "联系人：" + (model.returnObj?.contactMan != nil ? (model.returnObj?.contactMan)! : "--")
                self.label3.text = "电话：" + (model.returnObj?.tel != nil ? (model.returnObj?.tel)! : "--")
                self.label4.text = "累计用电：" + (model.returnObj?.accumulatedEle != nil ? (model.returnObj?.accumulatedEle)! : "--") + "kwh"
                self.label5.text = "累计用水：" + (model.returnObj?.accumulatedWater != nil ? (model.returnObj?.accumulatedWater)! : "--") + "t"
                self.label6.text = "累计用气：" + (model.returnObj?.accumulatedGas != nil ? (model.returnObj?.accumulatedGas)! : "--") + "m³"
                
                
                let titleWidth = self.textSize(text: self.titleL.text!, font: UIFont.systemFont(ofSize: 15), maxSize: CGSize(width: 1000 ,height: 20))
                let addressWidth = self.textSize(text: self.label1.text!, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000 ,height: 20))
                let telWidth = self.textSize(text: self.label3.text!, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000 ,height: 20))
                let eleWidth = self.textSize(text: self.label4.text!, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000 ,height: 20))
                let waterWidth = self.textSize(text: self.label5.text!, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000 ,height: 20))
                let gasWidth = self.textSize(text: self.label6.text!, font: UIFont.systemFont(ofSize: 12), maxSize: CGSize(width: 1000 ,height: 20))
                
                let maxW = max(titleWidth.width + 50, addressWidth.width + 50, telWidth.width + 50, eleWidth.width + 50 , waterWidth.width + 50 , gasWidth.width + 50)
                
                
                
                if maxW < 180 {
                    
                    self.x = -90
                    self.width = 180
                }else if maxW > (ScreenW - 60){
                    self.x = -(ScreenW - 60) / 2.0
                    self.width = ScreenW - 60
                    
                }else{
                    
                    self.x = -(maxW / 2.0)
                    self.width = maxW
                    
                }
                
                let path : UIBezierPath = UIBezierPath.init(roundedRect: CGRect(x: 10 ,y:10 ,width: maxW - 20 , height:235-30), cornerRadius: 6)
                self.rectangleShaplayer.path = path.cgPath
                
                let path1 = UIBezierPath()
                path1.move(to: CGPoint(x:maxW / 2.0 + 5 , y :205 ))
                path1.addLine(to: CGPoint(x:maxW / 2.0 , y :235 ))
                path1.addLine(to: CGPoint(x:maxW / 2.0 + 40 , y :205 ))
                path1.close()
                self.triangleShaplayer.path = path1.cgPath
                
                self.layoutIfNeeded()
                
                
            }, failture: { (error) in
                
                
            })
            
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear


        let shapLayer : CAShapeLayer = CAShapeLayer()
        self.rectangleShaplayer = shapLayer
//        let path : UIBezierPath = UIBezierPath.init(roundedRect: CGRect(x: 10 ,y:10 ,width: 280 - 20 , height:235-30), cornerRadius: 6)
//        shapLayer.path = path.cgPath
        self.layer.insertSublayer(shapLayer, at: 0)
        shapLayer.fillColor = UIColor.white.cgColor


        let shapLayer1 : CAShapeLayer = CAShapeLayer()
        self.triangleShaplayer = shapLayer1
//        let path1 = UIBezierPath()
//        path1.move(to: CGPoint(x:145 , y :205 ))
//        path1.addLine(to: CGPoint(x:140 , y :235 ))
//        path1.addLine(to: CGPoint(x:180 , y :205 ))
//        path1.close()
//        shapLayer1.path = path1.cgPath
        self.layer.insertSublayer(shapLayer1, at: 0)
        shapLayer1.fillColor = UIColor.white.cgColor
        
        
        self.layer.shadowColor = UIColor.black.cgColor;
        self.layer.shadowOffset = CGSize(width:2, height:2);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 5;
        
        
    }
    
    func textSize(text : String , font : UIFont , maxSize : CGSize) -> CGSize{
        return text.boundingRect(with: maxSize, options: [.usesLineFragmentOrigin], attributes: [NSAttributedStringKey.font : font], context: nil).size
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
