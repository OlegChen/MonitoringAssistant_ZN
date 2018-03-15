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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.imgView.clipsToBounds = true
        
        self.titleL.font=UIFont.boldSystemFont(ofSize: 15)
        
//        titleL.layer.shadowColor = UIColor.black.cgColor;
//        titleL.layer.shadowOffset = CGSize(width:2, height:2);
//        titleL.layer.shadowOpacity = 0.7;
//        titleL.layer.shadowRadius = 5;
//
    }
    
    func setuptitleAndImg(title:String , Img:String) {
        
        self.titleL.text = title
        self.imgView.image = UIImage.init(named: Img)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
