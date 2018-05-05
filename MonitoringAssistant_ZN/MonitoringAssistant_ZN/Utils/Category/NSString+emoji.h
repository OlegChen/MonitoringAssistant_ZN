//
//  NSString+emoji.h
//  MonitoringAssistant_ZN
//
//  Created by Apple on 2018/4/25.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (emoji)

+ (BOOL)stringContainsEmoji:(NSString *)string;

+ (BOOL)hasEmoji:(NSString*)string;

+ (BOOL)isNineKeyBoard:(NSString *)string;

@end
