//
//  OrderInfoHeaderView.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/18.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Charts

class OrderInfoHeaderView: UIView , ChartViewDelegate{
    
    @IBOutlet weak var chartsView: PieChartView!
    
    @IBOutlet weak var telPersentL: UILabel!
    
    @IBOutlet weak var telNumL: UILabel!
    
    @IBOutlet weak var OnsiteRepairPercentL: UILabel!
    
    @IBOutlet weak var OnsiteRepairNumL: UILabel!
    
    
    @IBOutlet weak var appRepairPercentL: UILabel!
    
    @IBOutlet weak var appRepairNumL: UILabel!
    
    @IBOutlet weak var WXRepairPercentL: UILabel!
    
    @IBOutlet weak var WXRepairNumL: UILabel!
    
    
    func setDataArray(array:NSArray) {
        
        self.setDataCount(array)
        
        for  i in 0..<array.count {
            
            let model = array[i] as! OrderInfoStatusWorkStutVosModel
            
            if let codeStr = model.code {
                
                switch (codeStr) {
                case "040001":
                    //("客户来电");
                    self.telNumL.text = model.cnt! + "个"
                    self.telPersentL.text = String(model.proportion!) + "%"
                case "040002":
                    //("现场报修");
                    self.OnsiteRepairNumL.text = model.cnt! + "个"
                    self.OnsiteRepairPercentL.text = String(model.proportion!) + "%"
                case "040003":
                    //("移动APP报修");
                    self.appRepairNumL.text = model.cnt! + "个"
                    self.appRepairPercentL.text = String(model.proportion!) + "%"
                case "040004":
                    //("微信端报修");
                    self.WXRepairNumL.text = model.cnt! + "个"
                    self.WXRepairPercentL.text = String(model.proportion!) + "%"
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
        
//         chartView.drawEntryLabelsEnabled = !chartView.drawEntryLabelsEnabled
//        set.drawValuesEnabled = !set.drawValuesEnabled

        
        chartsView.animate(xAxisDuration: 0, easingOption: .easeOutBack)
        
//        self.setDataCount(Int(4), range: UInt32(100))

        
        chartsView.layer.shadowColor = UIColor.darkGray.cgColor;
        chartsView.layer.shadowOffset = CGSize(width:2, height:2);
        chartsView.layer.shadowOpacity = 0.5;
        chartsView.layer.shadowRadius = 5;
        
    }
    
    
    func setDataCount(_ array: NSArray) {
        
        let model = array.firstObject as! OrderInfoStatusWorkStutVosModel

        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "工单数量\n" + model.sumCnt! + "个")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 16)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 15)!,
                                  .foregroundColor : UIColor.black], range: NSRange(location: 0, length: centerText.length ))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 15)!,
                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length, length: 0))
        chartsView.centerAttributedText = centerText;

        
        
        let entries = (0..<array.count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            
            let model = array[i] as! OrderInfoStatusWorkStutVosModel

            print(model.name)
            print(model.proportion)
            
            return PieChartDataEntry(value: model.proportion! / 100.0,
                                     label: "" /*parties[i % parties.count]*/)
        }
        
        let set = PieChartDataSet(values: entries, label: "Election Results")
        set.sliceSpace = 0
        set.selectionShift = 2
        set.drawValuesEnabled = false
        
        set.colors = [UIColor(red: 101/255, green: 148/255, blue: 238/255, alpha: 1)] +
            [UIColor(red: 37/255, green: 220/255, blue: 200/255, alpha: 1)] +
        [UIColor(red: 157/255, green: 114/255, blue: 238/255, alpha: 1)] +
        [UIColor(red: 87/255, green: 184/255, blue: 214/255, alpha: 1)]
        
   
      
//        set.valueLinePart1OffsetPercentage = 0.8
//        set.valueLinePart1Length = 0.2
//        set.valueLinePart2Length = 0.4
//        set.xValuePosition = .outsideSlice
//        set.yValuePosition = .outsideSlice
        
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
        chartView.usePercentValuesEnabled = false
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.85
//        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)

        chartView.drawCenterTextEnabled = true
        
        
        chartView.drawHoleEnabled = true
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
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
