//
//  MKRingSingleView.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

@IBDesignable
class MKRingSingleView: UIView {
    
    let ring1 = MKRingProgressView()


    @IBInspectable var ring1StartColor: UIColor = .red {
        didSet {
            ring1.startColor = ring1StartColor
        }
    }
    
    @IBInspectable var ring1EndColor: UIColor = .yellow {
        didSet {
            ring1.endColor = ring1EndColor
        }
    }

    
    @IBInspectable var ringWidth: CGFloat = 8 {
        didSet {
            
            ring1.ringWidth = ringWidth

            setNeedsLayout()
        }
    }
    
    @IBInspectable var ringSpacing: CGFloat = 7 {
        didSet {
            
            ringSpacing = 7
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        ring1.backgroundRingColor = RGBCOLOR(r: 14, 54, 87)

        addSubview(ring1)
 
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ring1.frame = bounds
        
    }
}
