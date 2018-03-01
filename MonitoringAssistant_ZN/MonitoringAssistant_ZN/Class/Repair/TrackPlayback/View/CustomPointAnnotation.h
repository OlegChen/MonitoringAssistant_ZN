//
//  CustomPointAnnotation.h
//  YunDi_Student
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 Fengyun Diyin Technologies (Beijing) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import "MonitoringAssistant_"

@interface CustomPointAnnotation : BMKPointAnnotation

@property (nonatomic ,strong) TrackPlayBackReturnObjModel *Model;

@end
