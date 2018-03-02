//
//  TrackPlayBackPopView.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

protocol TrackPlayBackPopViewDelegate:NSObjectProtocol
{
    //回调方法 传一个String类型的值
    func TrackBtnClick(model:TrackPlayBackReturnObjModel)
}

class TrackPlayBackPopView: UIView {

    weak var delegate:TrackPlayBackPopViewDelegate?

    var model : TrackPlayBackReturnObjModel?
    
    
    var companyL : UILabel!
    var nameL : UILabel!
    var TelL : UILabel!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    
//        self.backgroundColor = .red
        
        let bg = UIImageView()
        bg.image = UIImage.init(named: "未标题-2")
        self.addSubview(bg)
        bg.snp.makeConstraints { (make) in
            
            make.edges.equalTo(self).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
        
        
        companyL = UILabel()
        companyL.text = "机构："
        companyL.font = UIFont.systemFont(ofSize: 11)
        companyL.textColor = RGBCOLOR(r: 58, 58, 58)
        self.addSubview(companyL)
        companyL.snp.makeConstraints { (make) in
            
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-8);
            make.top.equalTo(self).offset(10);
            
        }
        
        nameL = UILabel()
        nameL.text = "联系人："
        nameL.font = UIFont.systemFont(ofSize: 11)
        nameL.textColor = RGBCOLOR(r: 58, 58, 58)
        self.addSubview(nameL)
        nameL.snp.makeConstraints { (make) in
            
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-8);
            make.top.equalTo(companyL.snp.bottom).offset(8);
            
        }
        
        
        TelL = UILabel()
        TelL.text = "电话："
        TelL.font = UIFont.systemFont(ofSize: 11)
        TelL.textColor = RGBCOLOR(r: 58, 58, 58)
        self.addSubview(TelL)
        TelL.snp.makeConstraints { (make) in
            
            make.left.equalTo(self).offset(8);
            make.right.equalTo(self).offset(-4);
            make.top.equalTo(nameL.snp.bottom).offset(8);
            
        }
        
        let btn = UIButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        btn.setTitle("轨迹回放", for: UIControlState.normal)
        btn.titleLabel?.textColor = .white
        btn.backgroundColor = RGBCOLOR(r: 54, 143, 182)
        btn.layer.cornerRadius = 4
        btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
        self.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            
            make.centerX.equalTo(self).offset(0);
            make.top.equalTo(TelL.snp.bottom).offset(12);
            make.size.equalTo(CGSize(width:80, height: 18))
            
        }
        
        
    }
    
    @objc func btnClick() {
        
        
        if delegate != nil {
            
            delegate?.TrackBtnClick(model: self.model!)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
