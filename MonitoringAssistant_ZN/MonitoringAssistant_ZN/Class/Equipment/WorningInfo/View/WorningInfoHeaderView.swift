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
    
    @IBOutlet weak var chartsView: LineChartView!
    
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view3: UIView!
    
    
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
        
        
        self.yearNumL.font = UIFont.boldSystemFont(ofSize: 14)
        self.yearRateL.font = UIFont.boldSystemFont(ofSize: 14)
        
        ring1NumL.font = UIFont.boldSystemFont(ofSize: 13)
        ring2NumL.font = UIFont.boldSystemFont(ofSize: 13)
        ring3NumL.font = UIFont.boldSystemFont(ofSize: 13)
        ring4NumL.font = UIFont.boldSystemFont(ofSize: 13)
        ring5NumL.font = UIFont.boldSystemFont(ofSize: 13)
        
        
        view1.cornerRadius = 4
        view2.cornerRadius = 4
        view3.cornerRadius = 4
        
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
    
        
        chartsView.scaleXEnabled = false
        chartsView.scaleYEnabled = false
        
        chartsView.chartDescription?.enabled = false
        chartsView.legend.enabled = false
        
        chartsView.xAxis.labelPosition = .bottom      //只显示底部的X轴
        //        chartsView.xAxis.forceLabelsEnabled = true
        chartsView.xAxis.drawGridLinesEnabled = false;//不绘制网格线
        chartsView.xAxis.spaceMax = 1 //设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        chartsView.xAxis.spaceMin = 1

        
        
//        let leftAxis = chartsView.leftAxis
//        leftAxis.removeAllLimitLines()
//
//        leftAxis.labelTextColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
//        leftAxis.axisMinimum = 0
//        leftAxis.spaceMax = 5000
//        leftAxis.spaceMin = 5000
//        leftAxis.drawGridLinesEnabled = false
//        leftAxis.gridLineDashLengths = [4, 3]
//        leftAxis.drawLimitLinesBehindDataEnabled = false
        
        let rightAxis = chartsView.rightAxis
        rightAxis.removeAllLimitLines()

//        rightAxis.labelTextColor = .red
        rightAxis.axisMaximum = 100
        rightAxis.axisMinimum = 0
        rightAxis.drawGridLinesEnabled = false
        //        rightAxis.granularityEnabled = false
        rightAxis.valueFormatter = DefaultAxisValueFormatter(formatter: formatter)

        
        let leftAxis = chartsView.leftAxis
        leftAxis.removeAllLimitLines()
        leftAxis.axisMinimum = 0
        leftAxis.spaceMax = 5000
        leftAxis.spaceMin = 5000
        
        leftAxis.gridLineDashLengths = [4, 3]
        leftAxis.drawLimitLinesBehindDataEnabled = false
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartsView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartsView.marker = marker
        
        chartsView.legend.form = .line
        
        
        let data = LineChartData(dataSets: [])
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9))
        
        chartsView.data = data
    }
    
    func updateArray(array:NSArray) {
        
        
        self.generateLineData(dataArray: array)
        
        
    }
    
    
    func generateLineData(dataArray:NSArray) {
        
        let xAxisLabels = NSMutableArray()
        for i in 0..<dataArray.count {
            
            let model = dataArray[i] as! WorningInfoAlarmMonthsModel
            xAxisLabels.add(model.name ?? "")
        }
        
        chartsView.xAxis.drawLabelsEnabled = true
        chartsView.xAxis.axisMinimum = 0
        chartsView.xAxis.axisMaximum = Double(xAxisLabels.count - 1)
        chartsView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisLabels as! [String])
        chartsView.xAxis.setLabelCount(xAxisLabels.count , force: true)
        
        
        
        let yVals1 = (0..<dataArray.count).map { (i) -> ChartDataEntry in
            let model = dataArray[i] as! WorningInfoAlarmMonthsModel

            return ChartDataEntry(x: Double(i), y: Double(model.sumCnt!)!)
        }
        
        let yVals2 = (0..<dataArray.count).map { (i) -> ChartDataEntry in
            let model = dataArray[i] as! WorningInfoAlarmMonthsModel

            return ChartDataEntry(x: Double(i), y: Double(model.proportion!))
        }
        
        
        let set1 = LineChartDataSet(values: yVals1, label: "DataSet 1")
        set1.axisDependency = .left
        set1.setColor(RGBCOLOR(r: 204, 28, 32))
        set1.circleRadius = 0
        set1.lineWidth = 1
        set1.fillAlpha = 0.1
        set1.fillColor = RGBCOLOR(r: 204, 28, 32)
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        set1.drawFilledEnabled = true
        set1.drawValuesEnabled = false
        
        let set2 = LineChartDataSet(values: yVals2, label: "DataSet 2")
        set2.axisDependency = .right
        set2.setColor(RGBCOLOR(r: 0, 128, 169))
        set2.circleRadius = 2
        set2.setCircleColor(RGBCOLOR(r: 0, 128, 169))
        set2.lineWidth = 1
        set2.fillAlpha = 65/255
        set2.fillColor = .red
        set2.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set2.drawCircleHoleEnabled = false
        set2.drawValuesEnabled = false
        
        
        let data = LineChartData(dataSets: [set1, set2])
        data.setValueTextColor(.white)
        data.setValueFont(.systemFont(ofSize: 9))
        
        chartsView.data = data
        
        
//        let set = LineChartDataSet(values: entries, label: "Line DataSet")
//        set.setColor(UIColor(red: 254/255, green: 214/255, blue: 49/255, alpha: 1))
//        set.lineWidth = 1
//        set.setCircleColor(UIColor(red: 254/255, green: 214/255, blue: 49/255, alpha: 1))
//        set.circleRadius = 2
//        set.circleHoleRadius = 0
//        //        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
//        set.mode = .linear
//        set.drawValuesEnabled = false
//        set.axisDependency = .left
//
    }
    
//    func generateRateLineData(dataArray:NSArray) -> LineChartData {
//        let entries = (0..<dataArray.count).map { (i) -> ChartDataEntry in
//
//            let model = dataArray[i] as! WorningInfoAlarmMonthsModel
//
//            return ChartDataEntry(x: Double(model.name!)! , y: (Double(model.proportion!)!/100) )
//        }
//
//        let set = LineChartDataSet(values: entries, label: "Line DataSet")
//        set.setColor(UIColor(red: 254/255, green: 214/255, blue: 49/255, alpha: 1))
//        set.lineWidth = 1
//        set.setCircleColor(UIColor(red: 254/255, green: 214/255, blue: 49/255, alpha: 1))
//        set.circleRadius = 2
//        set.circleHoleRadius = 0
//        //        set.fillColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
//        set.mode = .linear
//        set.drawValuesEnabled = false
//        //        set.valueFont = .systemFont(ofSize: 10)
//        //        set.valueTextColor = UIColor(red: 240/255, green: 238/255, blue: 70/255, alpha: 1)
//
//        set.axisDependency = .right
//
//        return LineChartData(dataSet: set)
//    }
//
    
    func setTypesData(array:NSArray) {
        
        
        for i in 0..<array.count {
            
            let model = array[i] as! WorningInfoAlarmTypesModel
            
            if(model.code == "1"){
                
                self.setRingClolor(color: RGBCOLOR(r: 176, 183, 186), rate: Double(model.proportion!) / 100, ringView: self.ring1)
                self.ring1.ring1.progress = Double(model.proportion!) / 100
                self.ring1NumL.text = model.sumCnt
                self.ring1RateL.text = String(model.proportion!) + "%"
                
            }else  if(model.code == "2"){
                
                self.setRingClolor(color: RGBCOLOR(r: 203, 80, 76), rate: Double(model.proportion!) / 100, ringView: self.ring2)
                self.ring2.ring1.progress = Double(model.proportion!) / 100
                self.ring2NumL.text = model.sumCnt
                self.ring2RateL.text = String(model.proportion!) + "%"
                
            }else  if(model.code == "3"){
                
                self.setRingClolor(color: RGBCOLOR(r: 91, 206, 128), rate: Double(model.proportion!) / 100, ringView: self.ring3)
                self.ring3.ring1.progress = Double(model.proportion!) / 100
                self.ring3NumL.text = model.sumCnt
                self.ring3RateL.text = String(model.proportion!) + "%"
            }else  if(model.code == "4"){
                
                self.setRingClolor(color: RGBCOLOR(r: 240, 181, 60), rate: Double(model.proportion!) / 100, ringView: self.ring4)
                self.ring4.ring1.progress = Double(model.proportion!) / 100
                self.ring4NumL.text = model.sumCnt
                self.ring4RateL.text = String(model.proportion!) + "%"
            }else  if(model.code == "5"){
                
                self.setRingClolor(color: RGBCOLOR(r: 81, 188, 180), rate: Double(model.proportion!) / 100, ringView: self.ring5)
                self.ring5.ring1.progress = Double(model.proportion!) / 100
                self.ring5NumL.text = model.sumCnt
                self.ring5RateL.text = String(model.proportion!) + "%"
            }else{
                
                
            }
            
        }
        
        
    }
    
    func setRingClolor(color:UIColor , rate:Double ,ringView:MKRingSingleView) {
        
        if(rate == 0){
            
            ringView.ring1.startColor = UIColor.clear
            ringView.ring1.endColor = UIColor.clear
            
        }else{
            
            ringView.ring1.startColor = color
            ringView.ring1.endColor = color
            
        }
        
    }
    

}
