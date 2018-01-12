//
//  ViewController.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/12.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let para : Dictionary = [        "versionNum" : "1.0.0",
                                         "origin" : "002001"
        ]
        
        
        
        NetworkService.networkPostrequest(parameters: para, requestApi: "http://172.168.1.234:1106/teacher/loginTeacherByMobile", modelClass: "ceshiModel", response: { (response) in
            
            let ceshi :ceshiModel = response as! ceshiModel
            
            print(ceshi)
            
            
        }, failture: { (error) in
            
            
            
        })
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

