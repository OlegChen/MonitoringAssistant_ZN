//
//  ZNCustomAlertContentView.m
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/3.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

#import "ZNCustomAlertContentView.h"

@interface ZNCustomAlertContentView ()


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;



@end

@implementation ZNCustomAlertContentView


- (void)awakeFromNib{
    
    [super awakeFromNib];
    
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    if (self.SureCompletion) {
        
        self.SureCompletion(false);
    }
}

- (IBAction)sureBtnClick:(UIButton *)sender {
    
    if (self.SureCompletion) {
        
        self.SureCompletion(true);
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
