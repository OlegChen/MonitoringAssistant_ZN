//
//  EnergyCompareVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/19.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit
import Charts


class EnergyCompareVC: BaseVC ,ChartViewDelegate {

    @IBOutlet var chartView: LineChartView!
    @IBOutlet var sliderX: UISlider!
    @IBOutlet var sliderY: UISlider!
    @IBOutlet var sliderTextX: UITextField!
    @IBOutlet var sliderTextY: UITextField!
    
    
    var shouldHideData: Bool = false

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "黄金对标"
        
        
        //折线图：
        
        chartView = LineChartView.init(frame: CGRect(x:0, y:100, width:300, height:300))
        self.view.addSubview(chartView)
        
        chartView.delegate = self
        
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        
        chartView.chartDescription?.enabled = false
        chartView.legend.enabled = false

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
        chartView.xAxis.gridLineDashLengths = [10, 10]
        chartView.xAxis.gridLineDashPhase = 0
        
        chartView.xAxis.labelPosition = .bottom      //只显示底部的X轴
        
        chartView.xAxis.drawLabelsEnabled = true
        let xAxisLabels = ["1月","2月","3月","4月","5月","6月","7月","8月","9月","10月","11月","12月"]
//        let xAxisLabels = ["1","2","3","4","5","6","7","8","9","10","11","12"]
        chartView.xAxis.axisMaximum = Double(xAxisLabels.count - 1)

        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values:xAxisLabels)
        chartView.xAxis.setLabelCount(xAxisLabels.count , force: true)


        
        

        
        let leftAxis = chartView.leftAxis
        leftAxis.removeAllLimitLines()

        leftAxis.axisMaximum = 200
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
        
        chartView.animate(xAxisDuration: 2.5)
        
        updateChartData()

        
    }
    
    
     func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount(Int(20), range: UInt32(100))
    }
    
    
    
    func setDataCount(_ count: Int, range: UInt32) {
        let values = (0..<count).map { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val, icon: UIImage.init(named: ""))
        }
        let set1 = LineChartDataSet(values: values, label: "")
        set1.drawIconsEnabled = false
        
        set1.lineDashLengths = [5, 2.5]
        set1.highlightLineDashLengths = [5, 2.5]
        set1.setColor(.black)
        set1.setCircleColor(.black)
        set1.lineWidth = 1
        set1.circleRadius = 3
        set1.drawCircleHoleEnabled = false
        set1.valueFont = .systemFont(ofSize: 9)
        set1.formLineDashLengths = [5, 2.5]
        set1.formLineWidth = 1
        set1.formLineWidth = 15
        
//        let gradientColors = [ChartColorTemplates.colorFromString("#00ff0000").cgColor,
//                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//        let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//        set1.fillAlpha = 1
//        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//        set1.drawFilledEnabled = true
        let data = LineChartData(dataSet: set1)

        
        chartView.data = data
        
    }
    
//    // TODO: Refine data creation
//    func setDataCount(_ count: Int, range: UInt32) {
//        let colors = ChartColorTemplates.vordiplom()[0...2]
//        
//        let block: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
//            let val = Double(arc4random_uniform(range) + 3)
//            return ChartDataEntry(x: Double(i), y: val)
//        }
//        let dataSets = (0..<3).map { i -> LineChartDataSet in
//            let yVals = (0..<count).map(block)
//            let set = LineChartDataSet(values: yVals, label: "DataSet \(i)")
//            set.lineWidth = 2.5
//            set.circleRadius = 4
//            set.circleHoleRadius = 2
//            let color = colors[i % colors.count]
//            set.setColor(color)
//            set.setCircleColor(color)
//            
//            return set
//        }
//        
//        dataSets[0].lineDashLengths = [5, 5]
//        dataSets[0].colors = ChartColorTemplates.vordiplom()
//        dataSets[0].circleColors = ChartColorTemplates.vordiplom()
//        
//        let data = LineChartData(dataSets: dataSets)
//        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
//        chartView.data = data
//    }
//    
    /*
    override func optionTapped(_ option: Option) {
        switch option {
        case .toggleFilled:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.drawFilledEnabled = !set.drawFilledEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleCircles:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.drawCirclesEnabled = !set.drawCirclesEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleCubic:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .cubicBezier) ? .linear : .cubicBezier
            }
            chartView.setNeedsDisplay()
            
        case .toggleStepped:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .stepped) ? .linear : .stepped
            }
            chartView.setNeedsDisplay()
            
        case .toggleHorizontalCubic:
            for set in chartView.data!.dataSets as! [LineChartDataSet] {
                set.mode = (set.mode == .cubicBezier) ? .horizontalBezier : .cubicBezier
            }
            chartView.setNeedsDisplay()
            
        default:
            super.handleOption(option, forChartView: chartView)
        }
    }
 */
 
    @IBAction func slidersValueChanged(_ sender: Any?) {
        sliderTextX.text = "\(Int(sliderX.value))"
        sliderTextY.text = "\(Int(sliderY.value))"
        
        self.updateChartData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
