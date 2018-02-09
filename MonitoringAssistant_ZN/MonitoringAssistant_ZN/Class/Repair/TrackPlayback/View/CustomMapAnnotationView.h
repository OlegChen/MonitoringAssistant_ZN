//
//  CustomMapAnnotationView.h
//  YunDi_Student
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 Fengyun Diyin Technologies (Beijing) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import "TeacherListDataModel.h"

@class CustomMapAnnotationView;


@protocol CustomMapAnnotationViewDelegate <NSObject>

- (void)AnnotationHeaderImageClickWithTeacherId:(NSString *)teacherId WithAnno:(CustomMapAnnotationView *)view;

@end


@interface CustomMapAnnotationView : BMKAnnotationView



//@property (nonatomic ,strong) TeacherListDataModel *teacherModel;


@property (nonatomic ,weak) id <CustomMapAnnotationViewDelegate> CustomAnnotationDelegate;

@end
