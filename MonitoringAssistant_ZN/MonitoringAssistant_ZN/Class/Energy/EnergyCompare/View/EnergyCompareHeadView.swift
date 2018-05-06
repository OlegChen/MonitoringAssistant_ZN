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
    
    
    
    @IBOutlet weak var leftTop: NSLayoutConstraint!
    @IBOutlet weak var righTop: NSLayoutConstraint!
    
    @IBOutlet weak var leftBottom: NSLayoutConstraint!
    
    @IBOutlet weak var righBottom: NSLayoutConstraint!
    
    
    func updateData(model:EnergyCompareStandardVoModel)  {
        
        self.label1.text = String(format: "%.2f", model.preUseEnergy!) //String(model.preUseEnergy!)
        self.label2.text = String(format: "%.2f", model.actualUseEnergy!)
        self.label3.text = String(format: "%.2f", model.industryStandard!)
        self.label4.text = String(format: "%.2f", model.planUseEnergy!)
        
        self.setDataCount(array: model.monthUseEnergies! as! NSArray)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let w = (ScreenW / 2.0 - 50) / 2.0
        leftTop.constant = -w
        righTop.constant = w
        leftBottom.constant = -w
        righBottom.constant = w
        
        //折线图：

        chartView.isUserInteractionEnabled = false
        
        chartView.noDataTextColor = UIColor.clear
        
        chartView.delegate = self
        
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false
        chartView.xAxis.drawGridLinesEnabled = false;
        chartView.leftAxis.axisMinimum = 0
        
        chartView.xAxis.labelTextColor = RGBCOLOR(r: 86, 86, 86)
        chartView.leftAxis.labelTextColor = RGBCOLOR(r: 86, 86, 86)
        
        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()
        
        leftAxis.gridLineDashLengths = [4, 0]
        leftAxis.gridColor = RGBCOLOR(r: 210, 210, 210)
        leftAxis.drawLimitLinesBehindDataEnabled = false
        leftAxis.labelFont = UIFont.systemFont(ofSize: 8)
        
        leftAxis.setLabelCount(7, force: true)
        
        
        chartView.rightAxis.enabled = false
        
        let marker = BalloonMarker(color: UIColor(white: 180/255, alpha: 1),
                                   font: .systemFont(ofSize: 12),
                                   textColor: .white,
                                   insets: UIEdgeInsets(top: 8, left: 8, bottom: 20, right: 8))
        marker.chartView = chartView
        marker.minimumSize = CGSize(width: 80, height: 40)
        chartView.marker = marker
        
        chartView.legend.form = .line
        
        chartView.animate(xAxisDuration: 0)
        
//        updateChartData()
        

        
    }
    
    
    
    // TODO: Refine data creation
    func setDataCount(array:NSArray) {

        let xAxisLabels = NSMutableArray()
        
        for i in 0..<array.count {
            
            let model = array[i] as! EnergyCompareMonthUseEnergiesModel
            xAxisLabels.add(model.monthStr!)
        }
        chartView.xAxis.labelPosition = .bottom      //只显示底部的X轴
        chartView.xAxis.spaceMax = 1 //设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
        chartView.xAxis.spaceMin = 1
        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.drawLabelsEnabled = true
        chartView.xAxis.axisMaximum = Double(xAxisLabels.count-1)
        
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisLabels as! [String])
        chartView.xAxis.setLabelCount(xAxisLabels.count , force: true)
        
        chartView.xAxis.labelFont = UIFont.systemFont(ofSize: 8)
        
        
        var maxleftNum : Double = 100
        
        let dataSets = (0..<4).map { j -> LineChartDataSet in
            
          
            let yVals = (0..<array.count).map {
                
                i -> ChartDataEntry in
                
                let model = array[i] as! EnergyCompareMonthUseEnergiesModel
                
                let val = j == 0 ? Double(model.preUseEnergy!) : ( j == 1 ? Double(model.actualUseEnergy!) : (j == 2 ? Double(model.industryStandard!) : Double(model.planUseEnergy!)) ) //Double()
                let month : String = String(model.monthStr!)
                
                
                if maxleftNum < val {
                    
                    maxleftNum = val
                }
                
                return ChartDataEntry(x: Double(i), y: val)
                
            }
            
            chartView.leftAxis.axisMaximum = maxleftNum
            
            
            let set = LineChartDataSet(values: yVals, label: "DataSet \(j)")
            set.drawCirclesEnabled = true
            set.drawValuesEnabled = false
            set.drawValuesEnabled = false
            set.mode = .horizontalBezier
            set.lineWidth = 1.5
            set.circleRadius = 3
            set.circleHoleRadius = 2
            
            set.drawIconsEnabled = false
            set.drawVerticalHighlightIndicatorEnabled = false
            set.setDrawHighlightIndicators(false)
            
            var color : [UIColor]!
            var circleColor : [UIColor]!
            
            switch j {
                
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
 
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
    }

}
