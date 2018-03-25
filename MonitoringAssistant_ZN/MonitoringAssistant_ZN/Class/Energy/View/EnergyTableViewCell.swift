//
//  EnergyTableViewCell.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let EnergyTableViewCell_id = "EnergyTableViewCell"

class EnergyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var iconImgView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var imgBtn: UIButton!
    
    
    @IBAction func imgBtnClick(_ sender: UIButton) {
        
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.imgView.clipsToBounds = true
        self.imgView.isHidden = true
        self.imgBtn.clipsToBounds = true
        self.imgBtn.adjustsImageWhenHighlighted = false
        
        self.titleL.font=UIFont.boldSystemFont(ofSize: 15)
        
//        titleL.layer.shadowColor = UIColor.black.cgColor;
//        titleL.layer.shadowOffset = CGSize(width:2, height:2);
//        titleL.layer.shadowOpacity = 0.7;
//        titleL.layer.shadowRadius = 5;
//
    }
    
    func setuptitleAndImg(title:String , Img:String) {
        
        self.titleL.text = title
        
        self.imgBtn.setBackgroundImage(UIImage.init(named: Img), for: .normal)
        self.imgBtn.setBackgroundImage(UIImage.init(named: Img), for: .highlighted)
        

        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
