/*
The MIT License (MIT)

Copyright (c) 2015 Max Konovalov

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/

import UIKit

@IBDesignable
class MKRingProgressGroupView: UIView {

    let ring1 = MKRingProgressView()
    let ring2 = MKRingProgressView()
    let ring3 = MKRingProgressView()
    let ring4 = MKRingProgressView()
    
    
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
    
    @IBInspectable var ring2StartColor: UIColor = .red {
        didSet {
            ring2.startColor = ring2StartColor
        }
    }
    
    @IBInspectable var ring2EndColor: UIColor = .blue {
        didSet {
            ring2.endColor = ring2EndColor
        }
    }
    
    @IBInspectable var ring3StartColor: UIColor = .red {
        didSet {
            ring3.startColor = ring3StartColor
        }
    }
    
    @IBInspectable var ring3EndColor: UIColor = .blue {
        didSet {
            ring3.endColor = ring3EndColor
        }
    }
    
    
    @IBInspectable var ring4StartColor: UIColor = .red {
        didSet {
            ring4.startColor = ring4StartColor
        }
    }
    
    @IBInspectable var ring4EndColor: UIColor = .blue {
        didSet {
            ring4.endColor = ring4EndColor
        }
    }
    
    @IBInspectable var ringWidth: CGFloat = 8 {
        didSet {
                        
            ring1.ringWidth = ringWidth
            ring2.ringWidth = ringWidth
            ring3.ringWidth = ringWidth
            ring4.ringWidth = ringWidth
            
            
            ring1.shadowOpacity = 0
            ring2.shadowOpacity = 0
            ring3.shadowOpacity = 0
            ring4.shadowOpacity = 0
            
            
            setNeedsLayout()
        }
    }
    
    @IBInspectable var ringSpacing: CGFloat = 7 {
        didSet {
            
            ringSpacing = 7
            setNeedsLayout()
        }
    }
    
    
    func setRing1_progress(value:Double){
            
            if(value == 0){
                
//                ring1.startColor = UIColor.clear
//                ring1.endColor = UIColor.clear
            }else{
                
                ring1.startColor = RGBCOLOR(r: 140, 219, 125)
                ring1.endColor = RGBCOLOR(r: 140, 219, 125)
                CATransaction.begin()
                CATransaction.setAnimationDuration(1.0)
                ring1.progress = value
                CATransaction.commit()
            }
        
    }
    
    func setRing2_progress(value:Double){
            
            if(value == 0){
                
//                ring2.startColor = UIColor.clear
//                ring2.endColor = UIColor.clear
            }else{
                
                ring2.startColor = RGBCOLOR(r: 67, 142, 185)
                ring2.endColor = RGBCOLOR(r: 67, 142, 185)
                CATransaction.begin()
                CATransaction.setAnimationDuration(1.0)
                ring2.progress = value
                CATransaction.commit()
            }
    }
    
    
    func setRing3_progress(value:Double)  {
        
        if(value == 0){
            
//            ring3.startColor = UIColor.clear
//            ring3.endColor = UIColor.clear
        }else{
            
            ring3.startColor = RGBCOLOR(r: 233, 155, 86)
            ring3.endColor = RGBCOLOR(r: 233, 155, 86)
            CATransaction.begin()
            CATransaction.setAnimationDuration(1.0)
            ring3.progress = value
            CATransaction.commit()
        }
        
        
    }

    
    func setRing4_progress(value:Double){
            
            if(value == 0){
                
//                ring4.startColor = UIColor.clear
//                ring4.endColor = UIColor.clear
            }else{
                
                ring4.startColor = RGBCOLOR(r: 165, 115, 255)
                ring4.endColor = RGBCOLOR(r: 165, 115, 255)
                CATransaction.begin()
                CATransaction.setAnimationDuration(1.0)
                ring4.progress = value
                CATransaction.commit()
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
        ring1.backgroundRingColor = RGBCOLOR(r: 240, 240, 240)
        ring2.backgroundRingColor = RGBCOLOR(r: 240, 240, 240)
        ring3.backgroundRingColor = RGBCOLOR(r: 240, 240, 240)
        ring4.backgroundRingColor = RGBCOLOR(r: 240, 240, 240)
        addSubview(ring1)
        addSubview(ring2)
        addSubview(ring3)
        addSubview(ring4)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        ring1.frame = bounds
        ring2.frame = bounds.insetBy(dx: ringWidth + ringSpacing, dy: ringWidth + ringSpacing)
        ring3.frame = bounds.insetBy(dx: 2 * ringWidth + 2 * ringSpacing, dy: 2 * ringWidth + 2 * ringSpacing)
        ring4.frame = bounds.insetBy(dx: 3 * ringWidth + 3 * ringSpacing, dy: 3 * ringWidth + 3 * ringSpacing)
        

    }

}
