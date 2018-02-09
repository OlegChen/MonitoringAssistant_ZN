//
//  TrackPlayBackVC.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/2/8.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class TrackPlayBackVC: UIViewController , BMKMapViewDelegate{

    var _mapView: BMKMapView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(_mapView!)
    
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        _mapView?.delegate = self

        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated);
        _mapView?.delegate = nil

    }
    
    // MARK: -----------  mapview delegate
    func mapView(_ mapView: BMKMapView!, regionDidChangeAnimated animated: Bool) {
        
        
    }
    
//    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
//
//
//    }
    
    
    
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
