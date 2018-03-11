//
//  bottomPlayView.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/3/11.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit


//创建协议
protocol bottomPlayViewDelegate:NSObjectProtocol
{
    //
    func playBtnClick(btn:UIButton)
}

class bottomPlayView: UIView {

    weak var delegate:bottomPlayViewDelegate?
    
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBAction func playBtnClick(_ sender: UIButton) {
        
        if delegate != nil
        {
            delegate?.playBtnClick(btn: sender)
        }
        sender.isSelected = !sender.isSelected

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.progressView.progress = 0.0
        
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 1.5);

        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
