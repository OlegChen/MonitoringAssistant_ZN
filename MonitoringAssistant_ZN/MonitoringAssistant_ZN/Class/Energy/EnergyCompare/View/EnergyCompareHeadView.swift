//
//  EnergyCompareHeadView.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/9.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Charts

class EnergyCompareHeadView: UIView ,ChartViewDelegate{

    @IBOutlet weak var chartView: LineChartView!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    @IBOutlet weak var label4: UILabel!
    
    
    func updateData(model:EnergyCompareStandardVoModel)  {
        
        self.label1.text = model.preUseEnergy
        self.label2.text = model.actualUseEnergy
        self.label3.text = model.industryStandard
        self.label4.text = model.planUseEnergy
        
        self.setDataCount(array: model.monthUseEnergies! as! NSArray)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        
        //折线图：
        
//        chartView = LineChartView.init(frame: CGRect(x:0, y:100, width:300, height:300))
//        sel.addSubview(chartView)
        
        chartView.delegate = self
        
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false;
        
        //        chartView.dragEnabled = true
        //        chartView.setScaleEnabled(true)
        //        chartView.pinchZoomEnabled = true
        
        // x-axis limit line
        //        let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
        //        llXAxis.lineWidth = 4
        //        llXAxis.lineDashLengths = [10, 10, 0]
        //        llXAxis.labelPosition = .rightBottom
        //        llXAxis.valueFont = .systemFont(ofSize: 10)
        //网格线
//        chartView.xAxis.gridLineDashLengths = [10, 10]
//        chartView.xAxis.gridLineDashPhase = 0
        
        chartView.xAxis.labelPosition = .bottom      //只显示底部的X轴
        chartView.xAxis.spaceMax = 1 //设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        chartView.xAxis.spaceMin = 1
        chartView.xAxis.drawLabelsEnabled = true
        let xAxisLabels = ["","1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
        chartView.xAxis.axisMaximum = Double(xAxisLabels.count)

        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisLabels)
        chartView.xAxis.setLabelCount(xAxisLabels.count , force: false)
        
        
        
        
        
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        
        leftAxis.axisMaximum = 3000
        leftAxis.axisMinimum = 0
        leftAxis.gridLineDashLengths = [5, 5]
        leftAxis.drawLimitLinesBehindDataEnabled = true
        
        chartView.rightAxis.enabled = false
        
        //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
        //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        chartView.legend.form = .line
        
        //        sliderX.value = 45
        //        sliderY.value = 100
        //        slidersValueChanged(nil)
        
        chartView.animate(xAxisDuration: 0)
        
//        updateChartData()
        

        
    }
    
    
    
    // TODO: Refine data creation
    func setDataCount(array:NSArray) {
        
//        let block: (_ index:Int,_ model:EnergyCompareMonthUseEnergiesModel) -> ChartDataEntry = {
//            (index:Int,model:EnergyCompareMonthUseEnergiesModel) -> ChartDataEntry in
//
//            let val = Double(arc4random_uniform(range) + 3)
//            return ChartDataEntry(x: Double(model.monthStr), y: Double(model.))
//        }
        let dataSets = (0..<4).map { i -> LineChartDataSet in
            

            
            let yVals = (0..<array.count).map {
                
                i -> ChartDataEntry in
                
                let model = array[i] as! EnergyCompareMonthUseEnergiesModel
                
                let val = i == 0 ? Double(model.preUseEnergy!) : ( i == 1 ? Double(model.actualUseEnergy!) : (i == 2 ? Double(model.industryStandard!) : Double(model.planUseEnergy!)) ) //Double()
                let month : String = model.monthStr!
                
                return ChartDataEntry(x: Double(month.replacingOccurrences(of: "月", with: ""))!, y: val!)
                
            }
            let set = LineChartDataSet(values: yVals, label: "DataSet \(i)")
            set.drawCirclesEnabled = true
            set.drawValuesEnabled = false
            
            set.mode = .horizontalBezier
            set.lineWidth = 1.5
            set.circleRadius = 3
            set.circleHoleRadius = 2
            
            var color : [UIColor]!
            var circleColor : [UIColor]!
            
            switch i {
                
                case 0 :
                    color =
                        [UIColor.init(red: 206/255, green: 97/255, blue: 98/255, alpha: 1.0)]
                circleColor = [UIColor.init(red: 206/255, green: 97/255, blue: 98/255, alpha: 1.0)]
                case 1 :
                    color =
                        [UIColor.init(red: 56/255, green: 185/255, blue: 177/255, alpha:  1.0)]
                circleColor = [UIColor.init(red: 56/255, green: 185/255, blue: 177/255, alpha:  1.0)]
                case 2 :
                    color =
                        [UIColor.init(red: 61/255, green: 181/255, blue: 150/255, alpha:  1.0)]
                circleColor = [UIColor.init(red: 61/255, green: 181/255, blue: 150/255, alpha:  1.0)]
                case 3 :
                    color =
                        [UIColor.init(red: 0/255, green: 142/255, blue: 192/255, alpha:  1.0)]
                circleColor = [UIColor.init(red: 0/255, green: 142/255, blue: 192/255, alpha:  1.0)]
            default:
                print("")
            }

            set.colors = color
            set.circleColors = circleColor
            
            return set
        }
        
        //        dataSets[0].lineDashLengths = [5, 5]
        //        dataSets[0].colors = ChartColorTemplates.vordiplom()
        //        dataSets[0].circleColors = ChartColorTemplates.vordiplom()
 
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
    }

}
