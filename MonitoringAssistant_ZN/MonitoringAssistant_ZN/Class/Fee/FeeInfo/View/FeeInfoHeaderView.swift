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
        
        
        maxFeeL.font = UIFont.boldSystemFont(ofSize: 14)
        averageFeeL.font = UIFont.boldSystemFont(ofSize: 14)
        minFeeL.font = UIFont.boldSystemFont(ofSize: 14)
        
        
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
        
        chartView.xAxis.labelPosition = .bottom      //只显示底部的X轴
//        chartView.xAxis.forceLabelsEnabled = true
        chartView.xAxis.drawGridLinesEnabled = false;//不绘制网格线
//        chartView.xAxis.setLabelCount(12 , force: false)
        chartView.xAxis.spaceMax = 1 //设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        chartView.xAxis.spaceMin = 1


        let leftAxis = chartView.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 2500
        leftAxis.axisMinimum = 0
        leftAxis.spaceMax = 500
        leftAxis.spaceMin = 500
        leftAxis.drawGridLinesEnabled = false


        let rightAxis = chartView.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 100
        rightAxis.axisMinimum = 0
        rightAxis.drawGridLinesEnabled = false
        
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)


        
//        self.updateChartData()
        
        
        
        
    }
    
    
    func updateChartData(data:NSArray) {
//        if self.shouldHideData {
//            chartView.data = nil
//            return
//        }
        
        
        self.setChartData(dataArray: data)
    }
    
    func setChartData(dataArray:NSArray) {
        
        let data = CombinedChartData()
        data.lineData = generateLineData(dataArray: dataArray)
        data.barData = generateBarData(dataArray: dataArray)
      
        chartView.xAxis.axisMaximum = data.xMax + 0.25
        
        chartView.data = data
    }
    
    
    func generateLineData(dataArray:NSArray) -> LineChartData {

        
        let entries = (0..<dataArray.count).map { (i) -> ChartDataEntry in
            
            let model = dataArray[i] as! ReturnObjChargeRateVosModel
            
            return ChartDataEntry(x: Double(model.monthStr!)! , y: (Double(model.proportion!)!/100) )
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
        
        set.axisDependency = .right
        
        return LineChartData(dataSet: set)
    }
    
    
    func generateBarData(dataArray:NSArray) -> BarChartData {
        
        
        let xAxisLabels = NSMutableArray()
        xAxisLabels.add("")
        for i in 0..<dataArray.count {
            
            let model = dataArray[i] as! ReturnObjChargeRateVosModel
            xAxisLabels.add(model.monthStr ?? "")
        }
        
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = Double(xAxisLabels.count-1)
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisLabels as! [String])
        chartView.xAxis.setLabelCount(xAxisLabels.count , force: true)
        
        
        let start = 0
        let yVals = (start..<dataArray.count).map { (i) -> BarChartDataEntry in
             let model = dataArray[i] as! ReturnObjChargeRateVosModel
            
        return BarChartDataEntry(x: Double(model.monthStr!)!, y: Double(model.sumRealFee!)!)
        }
        
        var set1: BarChartDataSet! = nil

        set1 = BarChartDataSet(values: yVals, label: "The year 2017")
        set1.colors = [UIColor.init(red: 71/255.0, green: 143/255.0, blue: 183/255.0, alpha: 1.0)]
        set1.drawValuesEnabled = false
    
        set1.axisDependency = .left
        
        let data = BarChartData(dataSet: set1)
        data.barWidth = 0.4
        
        return data

        
    }
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
