//
//  CustPointAnnotation.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/3/1.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit

enum starOrEnd:Int {

    case star = 100
    case end = 200
}

class CustPointAnnotation: BMKPointAnnotation {
    
    var Model : TrackPlayBackReturnObjModel?
    
    var isStartAnno = 0
    

}
