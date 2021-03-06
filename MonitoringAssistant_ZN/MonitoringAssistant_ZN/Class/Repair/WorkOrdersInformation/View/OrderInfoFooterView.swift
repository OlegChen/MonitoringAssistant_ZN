//
//  OrderInfoFooterView.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/18.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Charts

class OrderInfoFooterView: UIView , ChartViewDelegate {
    
    @IBOutlet weak var chartsView: PieChartView!
    

    @IBOutlet weak var completeRateL: UILabel!
    @IBOutlet weak var completeNumL: UILabel!
    
    @IBOutlet weak var RepairIngRateL: UILabel!
    @IBOutlet weak var RepairIngNumL: UILabel!
    
    @IBOutlet weak var ArrangedRateL: UILabel!
    @IBOutlet weak var ArrangedNumL: UILabel!
    
    @IBOutlet weak var ReceivedRateL: UILabel!
    @IBOutlet weak var ReceivedNumL: UILabel!
    
    @IBOutlet weak var cancleRateL: UILabel!
    @IBOutlet weak var cancleNumL: UILabel!
    
    
    
    func setDataArray(array:NSArray) {
        
        self.setDataCount(array)
        chartsView.animate(xAxisDuration: 0.5, easingOption: .linear)
        
        for  i in 0..<array.count {
            
            let model = array[i] as! OrderInfoStatusWorkStutVosModel
            
            let legend = (Bundle.main.loadNibNamed("legendView", owner: nil, options: nil)![0] as! legendView)
            
            legend.titleL.text = model.name
            legend.numL.text = model.cnt! + "个"
            legend.rateL.text = String(model.proportion!) + "%"
            
            self.addSubview(legend)
            legend.snp.makeConstraints({ (make) in
                
                make.top.equalTo(self.chartsView.snp.bottom).offset(10 + i * (25 + 2))
                make.left.right.equalTo(self).offset(0)
                make.height.equalTo(25)
            })
            
            if let codeStr = model.code {
                
                switch (codeStr) {
                case "043001":
                    //("已受理");
                    legend.legendView.backgroundColor = RGBCOLOR(r: 101, 148, 242)
                case "043002":
                    //("已安排");
                    legend.legendView.backgroundColor = RGBCOLOR(r: 90, 190, 220)
                case "043003":
                    //("修理中");
                    legend.legendView.backgroundColor = RGBCOLOR(r: 37, 219, 200)
                case "043004":
                    //("已完成");
                    legend.legendView.backgroundColor = RGBCOLOR(r: 128, 206, 52)
                case "043009":
                    //("取消");
                    legend.legendView.backgroundColor = RGBCOLOR(r: 164, 120, 250)
                default:
                    break
                }
                
                
            }
            
        }
        
    }
    

    
    override func awakeFromNib() {
        
        self.setup(pieChartView: chartsView)
        
        chartsView.delegate = self
        
        chartsView.legend.enabled = false
        chartsView.setExtraOffsets(left: 0, top: 10, right: 0, bottom: 0)
        
        chartsView.noDataTextColor = UIColor.clear

        
//        chartsView.drawEntryLabelsEnabled = false
        //        set.drawValuesEnabled = !set.drawValuesEnabled
        
        
        
//        self.setDataCount(Int(4), range: UInt32(100))
        
        
    }
    
    
    func setDataCount(_ Array: NSArray) {
        
        
        let entries = (0..<Array.count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            
            let model = Array[i] as! OrderInfoStatusWorkStutVosModel
            
            print(model.name)
            print(model.proportion)
            
            return PieChartDataEntry(value: model.proportion! / 100.0,
                                     label: model.name  /*parties[i % parties.count]*/)
        } //model.proportion! > 0 ?  model.name : ""
        
        let set = PieChartDataSet(values: entries, label: "Election Results")
        set.sliceSpace = 0
        set.selectionShift = 5
        set.drawValuesEnabled = false
        
        let ReceivedColor = [UIColor(red: 101/255, green: 148/255, blue: 242/255, alpha: 1)]
        let arrangedColor = [UIColor(red: 90/255, green: 190/255, blue: 220/255, alpha: 1)]
        let RepairingColor = [UIColor(red: 37/255, green: 219/255, blue: 200/255, alpha: 1)]
        let CompleteColor = [UIColor(red: 128/255, green: 207/255, blue: 52/255, alpha: 1)]
        let cancleColor = [UIColor(red: 160/255, green: 120/255, blue: 250/255, alpha: 1)]
 
        set.colors = ReceivedColor
            + arrangedColor
            + RepairingColor
            + CompleteColor
            + cancleColor

        
        set.valueLinePart1OffsetPercentage = 0.85
        set.valueLinePart1Length = 0.5
        set.valueLinePart2Length = 0.4
        set.valueLineWidth = 0.5 //折线的粗细
        set.valueLineColor = UIColor.black //折线颜色
      

                set.xValuePosition = .outsideSlice
//                set.yValuePosition = .outsideSlice
        
        let data = PieChartData(dataSet: set)
    
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        chartsView.data = data
        chartsView.highlightValues(nil)
 
 
        
    }
    
    
    func setup(pieChartView chartView: PieChartView) {
        
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false

        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 20, top: 10, right: 20, bottom: 10)

        chartView.drawCenterTextEnabled = false
 
        
        
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "工单数量\n123123个")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        //        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
        //                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        //        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = false
        chartView.rotationAngle = 0
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
        
        chartsView.legend.enabled = false

 
        
        
        chartsView.layer.shadowColor = UIColor.darkGray.cgColor;
        chartsView.layer.shadowOffset = CGSize(width:2, height:2);
        chartsView.layer.shadowOpacity = 0.5;
        chartsView.layer.shadowRadius = 5;
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
