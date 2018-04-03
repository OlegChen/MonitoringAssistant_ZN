//
//  ZNCustomAlertView.m
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/3.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

#import "ZNCustomAlertView.h"
#import "ZNCustomAlertContentView.h"

@interface ZNCustomAlertView ()

@property (copy, nonatomic) void(^completion)(BOOL sure);
@property (nonatomic,strong) ZNCustomAlertContentView *alertView;

@end

@implementation ZNCustomAlertView

+ (instancetype)shareManager{
    static ZNCustomAlertView *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}


+ (instancetype)handleTip:(NSString *)content isShowCancelBtn:(BOOL)isShow completion:(void(^)(BOOL sure))block{
    
    ZNCustomAlertView *manager = [self shareManager];

    manager.completion = block;
//    [manager p_setupWithTipStr:content animate:NO];
    [manager p_show];
    manager.alertView.contentL.text = content;
    manager.alertView.cancelBtn.hidden = !isShow;
    __weak typeof(manager) weakManager = manager;
    manager.alertView.SureCompletion = ^(BOOL sure) {
        
        block(sure);
        [weakManager p_dismiss];
    };
    
    return manager;
    
    
}


- (instancetype)init
{
    self = [super init];
    if (self) {

        _alertView = [[[NSBundle mainBundle]loadNibNamed:@"ZNCustomAlertContentView" owner:self options:nil]objectAtIndex:0];
        
        
    }
    return self;
}

- (void)p_show{
    //初始状态
    _alertView.backgroundColor = [UIColor clearColor];
    _alertView.contentView.alpha = 0;
    _alertView.frame = [UIScreen mainScreen].bounds;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.alertView];
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.18];
        _alertView.contentView.alpha = 1;
    } completion:^(BOOL finished) {
        
        
    }];
}

+ (void)dismiss{
    
    ZNCustomAlertView*manager = [self shareManager];
    [manager p_dismiss];
}


- (void)p_dismiss{
    //    _curTweet = nil;
    _completion = nil;
    [UIView animateWithDuration:0.3 animations:^{
        _alertView.backgroundColor = [UIColor clearColor];
        _alertView.contentView.alpha = 0;
    } completion:^(BOOL finished) {
        [_alertView removeFromSuperview];
    }];
}

@end
