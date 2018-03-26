//
//  EnergyTableViewCell.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/18.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

let EnergyTableViewCell_id = "EnergyTableViewCell"

protocol EnergyTableViewCellDelegate : NSObjectProtocol {
    
    func BtnSelected( index: Int );
    
}


class EnergyTableViewCell: UITableViewCell {
    
    var index : Int?
    var delegate:EnergyTableViewCellDelegate?

    
    @IBOutlet weak var iconImgView: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBOutlet weak var imgBtn: UIButton!
    
    
    @IBAction func imgBtnClick(_ sender: UIButton) {
        
        if((delegate) != nil)
        {
            self.delegate?.BtnSelected(index: self.index!)
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.imgView.clipsToBounds = true
        self.imgView.isHidden = true
        self.imgBtn.clipsToBounds = true
        self.imgBtn.adjustsImageWhenHighlighted = false
//        self.imgBtn.addTarget(self, action: #selector(touchdown), for: UIControlEvents.touchDown)
        
//        self.titleL.font=UIFont.boldSystemFont(ofSize: 15)
        
//        titleL.layer.shadowColor = UIColor.black.cgColor;
//        titleL.layer.shadowOffset = CGSize(width:2, height:2);
//        titleL.layer.shadowOpacity = 0.7;
//        titleL.layer.shadowRadius = 5;
//
    }
    
//    @objc func touchdown() {
//
//        self.imgBtn
//    }
    
    func setuptitleAndImg(title:String , Img:String) {
        
        self.titleL.text = title
        
        self.imgBtn.setBackgroundImage(UIImage.init(named: Img + "_untouch"), for: UIControlState.normal)
        self.imgBtn.setBackgroundImage(UIImage.init(named: Img + "_touch"), for: UIControlState.highlighted)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    

}
