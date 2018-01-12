//
//  PCH.swift
//  MonitoringAssistant_ZN
//
//  Created by apple on 2018/1/12.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

import UIKit


func PrintLog<N>(message:N,fileName:String = #file,methodName:String = #function,lineNumber:Int = #line){
    #if DebugType
        print("\(fileName as NSString)\n方法:\(methodName)\n行号:\(lineNumber)\n打印信息\(message)");
    #endif
}

func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor
{
    return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
}

