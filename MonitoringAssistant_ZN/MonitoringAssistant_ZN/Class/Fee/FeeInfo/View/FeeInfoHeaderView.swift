//
//  FeeInfoHeaderView.swift
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/2/13.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Charts

class FeeInfoHeaderView: UIView ,ChartViewDelegate{
    
    
    @IBOutlet weak var maxFeeL: UILabel!
    @IBOutlet weak var averageFeeL: UILabel!
    @IBOutlet weak var minFeeL: UILabel!
    
    @IBOutlet weak var chartView: CombinedChartView!
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " %"
        formatter.positiveSuffix = " %"
        
        return formatter
    }()
    
    let months = ["1", "2", "3",
                  "4", "5", "6",
                  "7", "8", "9",
                  "10", "11", "12"]
    
    override func awakeFromNib() {
        
        
        chartView.delegate = self
        
        chartView.chartDescription?.enabled = false
        
        chartView.drawBarShadowEnabled = false
        chartView.highlightFullBarEnabled = false
        
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false
        
        
        chartView.drawOrder = [DrawOrder.bar.rawValue,
                               DrawOrder.line.rawValue]
        
//        let l = chartView.legend
//        l.wordWrapEnabled = true
//        l.horizontalAlignment = .center
//        l.verticalAlignment = .bottom
//        l.orientation = .horizontal
//        l.drawInside = false
        //        chartView.legend = l
        
//        let rightAxis = chartView.rightAxis
//        rightAxis.axisMinimum = 0
        
//        let leftAxis = chartView.leftAxis
//        leftAxis.axisMinimum = 0
        
        chartView.xAxis.labelPosition = .bottom      //只显示底部的X轴
//        chartView.xAxis.forceLabelsEnabled = true
        chartView.xAxis.drawGridLinesEnabled = false;//不绘制网格线
        chartView.xAxis.setLabelCount(12 , force: false)
        chartView.xAxis.spaceMax = 1 //设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        chartView.xAxis.spaceMin = 1

//        chartView.xAxis.drawLabelsEnabled = true
//        let xAxisLabels = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
//        chartView.xAxis.axisMaximum = Double(xAxisLabels.count - 1)
//        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisLabels)
//        chartView.xAxis.setLabelCount(xAxisLabels.count , force: false)

//        chartView.leftAxis.drawLabelsEnabled = true
//        let leftAxisLabels = ["0","500","1000","1500","2000","2500"]
//        chartView.leftAxis.axisMaximum = Double(leftAxisLabels.count )
//        chartView.leftAxis.valueFormatter = IndexAxisValueFormatter(values:leftAxisLabels
//        )
//        chartView.leftAxis.setLabelCount(leftAxisLabels.count , force: true)

        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 2500
        leftAxis.axisMinimum = 0
        leftAxis.spaceMax = 500
        leftAxis.spaceMin = 500
        leftAxis.drawGridLinesEnabled = false
//        leftAxis.granularityEnabled = true
        
//        leftAxis.drawLabelsEnabled = true
//        leftAxis.axisMaximum = 2500
        
//        chartView.rightAxis.drawLabelsEnabled = true
//        let rightAxisLabels = ["0%","20%","40%","60%","80%","100%"]
//        chartView.rightAxis.axisMaximum = Double(rightAxisLabels.count + 1)
//        chartView.rightAxis.valueFormatter = IndexAxisValueFormatter(values:rightAxisLabels
//        )
//        chartView.rightAxis.setLabelCount(rightAxisLabels.count , force: true)
//        chartView.rightAxis.labelTextColor = .red
//        chartView.rightAxis.granularityEnabled = true

        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 100
        rightAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
//        rightAxis.granularityEnabled = false
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)


        
        self.updateChartData()
        
        
        
        
    }
    
    
     func updateChartData() {
//        if self.shouldHideData {
//            chartView.data = nil
//            return
//        }
        
        self.setChartData()
    }
    
    func setChartData() {
        let data = CombinedChartData()
        data.lineData = generateLineData()
        data.barData = generateBarData()
      
        chartView.xAxis.axisMaximum = data.xMax + 0.25
        
        chartView.data = data
    }
    
    
    func generateLineData() -> LineChartData {
        let entries = (0..<12).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(i) + 1, y: Double(arc4random_uniform(100)) )
        }
        
        let set = LineChartDataSet(values: entries, label: "Line DataSet")
        set.setColor(UIColor(red: 254/255, green: 214/255, blue: 49/255, alpha: 1))
        set.lineWidth = 1
        set.setCircleColor(UIColor(red: 254/255, green: 214/255, blue: 49/255, alpha: 1))
        set.circleRadius = 2
        set.circleHoleRadius = 0
//        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        set.mode = .linear
        set.drawValuesEnabled = false
//        set.valueFont = .systemFont(ofSize: 10)
//        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
        
        set.axisDependency = .right
        
        return LineChartData(dataSet: set)
    }
    
    
    
    func generateBarData() -> BarChartData {
        
        let start = 1
        let range : UInt32 = 2500
        
        let yVals = (start..<13).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
//            if arc4random_uniform(100) < 25 {
//                return BarChartDataEntry(x: Double(i), y: val, icon: UIImage(named: "icon"))
//            } else {
                return BarChartDataEntry(x: Double(i), y: val)
//            }
        }
        
        var set1: BarChartDataSet! = nil
//        if let set = chartView.data?.dataSets.first as? BarChartDataSet {
//            set1 = set
//            set1.values = yVals
//            chartView.data?.notifyDataChanged()
//            chartView.notifyDataSetChanged()
//        } else {
            set1 = BarChartDataSet(values: yVals, label: "The year 2017")
            set1.colors = [UIColor.init(red: 71/255.0, green: 143/255.0, blue: 183/255.0, alpha: 1.0)]
            set1.drawValuesEnabled = false
        
            set1.axisDependency = .left

            
            let data = BarChartData(dataSet: set1)
            data.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            data.barWidth = 0.4
            
            return data

//        }
        
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
