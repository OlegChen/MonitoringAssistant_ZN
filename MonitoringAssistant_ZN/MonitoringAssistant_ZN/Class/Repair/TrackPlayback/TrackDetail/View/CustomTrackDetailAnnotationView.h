//
//  CustomMapAnnotationView.h
//  YunDi_Student
//
//  Created by apple on 2018/1/24.
//  Copyright © 2018年 Fengyun Diyin Technologies (Beijing) Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <BaiduMapAPI_Map/BMKMapComponent.h>

@class CustomTrackDetailAnnotationView;


@protocol CustomTrackDetailAnnotationViewDelegate <NSObject>

//- (void)AnnotationHeaderImageClickWithTeacherId:(NSString *)teacherId WithAnno:(CustomMapAnnotationView *)view;

@end



@interface CustomTrackDetailAnnotationView : BMKAnnotationView

@property (nonatomic ,copy) NSString *img;

//@property (nonatomic ,strong) TrackPlayBackReturnObjModel *teacherModel;


@property (nonatomic ,weak) id <CustomTrackDetailAnnotationViewDelegate> CustomAnnotationDelegate;

@end
