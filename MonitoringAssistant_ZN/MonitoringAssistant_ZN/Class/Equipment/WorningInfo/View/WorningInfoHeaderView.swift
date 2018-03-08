//
//  WorningInfoHeaderView.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Charts


class WorningInfoHeaderView: UIView ,ChartViewDelegate{
    
    @IBOutlet weak var chartsView: CombinedChartView!
    
    
    @IBOutlet weak var yearNumL: UILabel!
    @IBOutlet weak var yearRateL: UILabel!
    
    @IBOutlet weak var ring1: MKRingSingleView!
    @IBOutlet weak var ring2: MKRingSingleView!
    @IBOutlet weak var ring3: MKRingSingleView!
    @IBOutlet weak var ring4: MKRingSingleView!
    @IBOutlet weak var ring5: MKRingSingleView!
    
    @IBOutlet weak var ring1RateL: UILabel!
    @IBOutlet weak var ring1NumL: UILabel!
    
    @IBOutlet weak var ring2RateL: UILabel!
    @IBOutlet weak var ring2NumL: UILabel!
    
    @IBOutlet weak var ring3RateL: UILabel!
    @IBOutlet weak var ring3NumL: UILabel!
    
    @IBOutlet weak var ring4RateL: UILabel!
    @IBOutlet weak var ring4NumL: UILabel!
    
    @IBOutlet weak var ring5RateL: UILabel!
    @IBOutlet weak var ring5NumL: UILabel!
    
    
    
    lazy var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.negativeSuffix = " "
        formatter.positiveSuffix = " "
        
        return formatter
    }()
    
    let months = ["1", "2", "3",
                  "4", "5", "6",
                  "7", "8", "9",
                  "10", "11", "12"]
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.ring1.ringWidth = 5
        self.ring2.ringWidth = 5
        self.ring3.ringWidth = 5
        self.ring4.ringWidth = 5
        self.ring5.ringWidth = 5
        
        self.ring1.ring1StartColor = RGBCOLOR(r: 173, 181, 183)
        self.ring1.ring1EndColor = RGBCOLOR(r: 173, 181, 183)
        
        self.ring2.ring1StartColor = RGBCOLOR(r: 213, 82, 83)
        self.ring2.ring1EndColor = RGBCOLOR(r: 213, 82, 83)
        
        self.ring3.ring1StartColor = RGBCOLOR(r: 51, 214, 135)
        self.ring3.ring1EndColor = RGBCOLOR(r: 51, 214, 135)
        
        self.ring4.ring1StartColor = RGBCOLOR(r: 240, 181, 83)
        self.ring4.ring1EndColor = RGBCOLOR(r:  240, 181, 83)
        
        self.ring5.ring1StartColor = RGBCOLOR(r: 83, 198, 187)
        self.ring5.ring1EndColor = RGBCOLOR(r: 83, 198, 187)
        
        
        
        chartsView.delegate = self
        
        chartsView.chartDescription?.enabled = false
        
        chartsView.drawBarShadowEnabled = false
        chartsView.highlightFullBarEnabled = false
        
        chartsView.scaleXEnabled = false
        chartsView.scaleYEnabled = false
        
        chartsView.chartDescription?.enabled = false
        chartsView.legend.enabled = false
        
        
        chartsView.drawOrder = [DrawOrder.line.rawValue,
                               DrawOrder.line.rawValue]
        
        chartsView.xAxis.labelPosition = .bottom      //只显示底部的X轴
        //        chartsView.xAxis.forceLabelsEnabled = true
        chartsView.xAxis.drawGridLinesEnabled = false;//不绘制网格线
        chartsView.xAxis.setLabelCount(12 , force: false)
        chartsView.xAxis.spaceMax = 1 //设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        chartsView.xAxis.spaceMin = 1
        
        chartsView.xAxis.drawLabelsEnabled = true
        let xAxisLabels = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        chartsView.xAxis.axisMaximum = Double(xAxisLabels.count - 1)
        chartsView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisLabels)
        chartsView.xAxis.setLabelCount(xAxisLabels.count , force: false)
        
        
        let leftAxis = chartsView.leftAxis
        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        leftAxis.axisMaximum = 3000
        leftAxis.axisMinimum = 0
        leftAxis.spaceMax = 500
        leftAxis.spaceMin = 500
        leftAxis.drawGridLinesEnabled = false
        
        let rightAxis = chartsView.rightAxis
        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 100
        rightAxis.axisMinimum = 0
        leftAxis.drawGridLinesEnabled = false
        //        rightAxis.granularityEnabled = false
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)

        let data = CombinedChartData()
        chartsView.data = data
    }
    
    func updateArray(array:NSArray) {
        
        let data = CombinedChartData()
        
        data.lineData = self.generateLineData(dataArray: array)
        data.lineData = self.generateRateLineData(dataArray: array)
        
        chartsView.data = data
        
    }
    
    
    func generateLineData(dataArray:NSArray) -> LineChartData {
        let entries = (0..<dataArray.count).map { (i) -> ChartDataEntry in
            
            let model = dataArray[i] as! WorningInfoAlarmMonthsModel
            
            return ChartDataEntry(x: Double(model.name!)! , y: (Double(model.sumCnt!)!) )
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
        
        set.axisDependency = .left
        
        return LineChartData(dataSet: set)
    }
    
    func generateRateLineData(dataArray:NSArray) -> LineChartData {
        let entries = (0..<dataArray.count).map { (i) -> ChartDataEntry in
            
            let model = dataArray[i] as! WorningInfoAlarmMonthsModel
            
            return ChartDataEntry(x: Double(model.name!)! , y: (Double(model.proportion!)!/100) )
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
    
    
    func setTypesData(array:NSArray) {
        
        
        for i in 0..<array.count {
            
            let model = array[i] as! WorningInfoAlarmTypesModel
            
            if(model.code == "1"){
                
                self.ring1.ring1.progress = Double(model.proportion!)! / 100
                self.ring1NumL.text = model.sumCnt
                self.ring1RateL.text = model.proportion! + "%"
                
            }else  if(model.code == "2"){
                
                self.ring2.ring1.progress = Double(model.proportion!)! / 100
                self.ring2NumL.text = model.sumCnt
                self.ring2RateL.text = model.proportion! + "%"
                
            }else  if(model.code == "3"){
                
                self.ring3.ring1.progress = Double(model.proportion!)! / 100
                self.ring3NumL.text = model.sumCnt
                self.ring3RateL.text = model.proportion! + "%"
            }else  if(model.code == "4"){
                
                self.ring4.ring1.progress = Double(model.proportion!)! / 100
                self.ring4NumL.text = model.sumCnt
                self.ring4RateL.text = model.proportion! + "%"
            }else  if(model.code == "5"){
                
                self.ring5.ring1.progress = Double(model.proportion!)! / 100
                self.ring5NumL.text = model.sumCnt
                self.ring5RateL.text = model.proportion! + "%"
            }else{
                
                
            }
            
        }
        
        
    }

}
