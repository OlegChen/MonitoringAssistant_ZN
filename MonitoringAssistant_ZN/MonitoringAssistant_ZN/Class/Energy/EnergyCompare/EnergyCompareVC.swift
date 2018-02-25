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
        
        
        let mySegmentedControl = UISegmentedControl(
            items: ["早餐","午餐","晚餐","宵夜"])
        
        mySegmentedControl.tintColor = UIColor.black
        mySegmentedControl.backgroundColor = UIColor.lightGray
        
        mySegmentedControl.selectedSegmentIndex = 0
        mySegmentedControl.addTarget(self, action: #selector(self.onChange), for: .valueChanged)
        
        mySegmentedControl.frame.size = CGSize(
            width: ScreenW * 0.8, height: 30)
        mySegmentedControl.center = CGPoint(
            x: ScreenW * 0.5,
            y: CGFloat(NavHeight + 20.0))
        self.view.addSubview(mySegmentedControl)
        
        
        
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

        
        self.getdataWithType(type: "1")   //1：总能耗2：水能耗3：电能耗4：气能耗
        
        
    }
    
    
     func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
        
        self.setDataCount(Int(20), range: UInt32(100))
    }
    
    
    
    // TODO: Refine data creation
    func setDataCount(_ count: Int, range: UInt32) {
        let colors = ChartColorTemplates.vordiplom()[0...2]
        
        let block: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let dataSets = (0..<3).map { i -> LineChartDataSet in
            let yVals = (0..<count).map(block)
            let set = LineChartDataSet(values: yVals, label: "DataSet \(i)")
            set.drawCirclesEnabled = true
            set.mode = .horizontalBezier
            set.lineWidth = 1.5
            set.circleRadius = 3
            set.circleHoleRadius = 2
            let color = colors[i % colors.count]
            set.setColor(color)
            set.setCircleColor(color)
            
            return set
        }
        
//        dataSets[0].lineDashLengths = [5, 5]
//        dataSets[0].colors = ChartColorTemplates.vordiplom()
//        dataSets[0].circleColors = ChartColorTemplates.vordiplom()
        
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        chartView.data = data
    }
    
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
 

    @objc func onChange(sender: UISegmentedControl) {
        // 印出選到哪個選項 從 0 開始算起
        print(sender.selectedSegmentIndex)
        
        // 印出這個選項的文字
        print(
            sender.titleForSegment(
                at: sender.selectedSegmentIndex))
    }
    
    func getdataWithType(type:String) {
        
        UserCenter.shared.userInfo { (isLogin, userInfo) in
            
            let para = ["companyCode":userInfo.companyCode ,"orgCode":userInfo.orgCode ,"empNo":userInfo.empNo ,"empName":userInfo.empName ,"type":type]

            NetworkService.networkPostrequest(parameters:para as! [String : String], requestApi: goldStandardDataUrl, modelClass: "", response: { (obj) in
                
                
                
            }, failture: { (error) in
                
            })
        }

        
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
