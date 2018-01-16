//
//  FanBtn.h
//  扇形按钮
//
//  Created by jhtxch on 16/4/20.
//  Copyright © 2016年 jhtxch. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FanBtn;

@protocol FanBtnDelegate <NSObject>

@optional
- (void)clickBtn:(FanBtn *)btn;

@end

@interface FanBtn : UIButton

@property(nonatomic, copy)   NSString *text;
@property(nonatomic, copy)   NSString *iconImgName;

@property(nonatomic, strong) UIColor *btnColor;
@property(nonatomic, strong) UIColor *pressBtnColor;

@property(nonatomic, strong) UIColor *lineColor;
@property(nonatomic, assign) CGPoint circleCenter;
@property(nonatomic, assign) CGFloat radius;
@property(nonatomic, assign) CGFloat angle;
@property(nonatomic, assign) CGFloat startAngle;
@property(nonatomic, assign) CGMutablePathRef path;//用于判断点击是否在画出来图形中
@property(nonatomic, assign) id<FanBtnDelegate> delegate;
//@property(nonatomic, strong) UILabel *textLabel;
@property(nonatomic, strong) UIImageView *icon;


@end
