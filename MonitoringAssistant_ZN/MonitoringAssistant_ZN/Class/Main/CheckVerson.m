//
//  CheckVerson.m
//  MonitoringAssistant_ZN
//
//  Created by Chen on 2018/3/18.
//  Copyright © 2018年 chenxianghong. All rights reserved.
//

#import "CheckVerson.h"
#import "CustomerAlertViewManger.h"

@implementation CheckVerson



+(void)checkVersionWithVC:(UIViewController*)vc
{
    NSString *newVersion;
    NSString *newContent;

    NSURL *url = [NSURL URLWithString: @"http://itunes.apple.com/cn/lookup?id=1360816207"];//@"http://itunes.apple.com/cn/lookup?id=1360816207"];//这个URL地址是该app在iTunes connect里面的相关配置信息。其中id是该app在app store唯一的ID编号。 王者荣耀：//989673964
    NSString *jsonResponseString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"通过appStore获取的数据信息：%@",jsonResponseString);
    
    
    if (jsonResponseString == nil) {

        return;
    }
    
    
    NSData *data = [jsonResponseString dataUsingEncoding:NSUTF8StringEncoding];
    
    //    解析json数据
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array = json[@"results"];
    
    for (NSDictionary *dic in array) {
        
        newVersion = [dic valueForKey:@"version"];
        
        newContent = [dic valueForKey:@"releaseNotes"];
    }
    
//    releaseNotes = "版本更新信息";  
    
    NSLog(@"通过appStore获取的版本号是：%@",newVersion);
    
//    newVersion = @"2.0";
    
    //获取本地软件的版本号
    NSString *localVersion = [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"];
    

    
    //对比发现的新版本和本地的版本
    if ([newVersion compare:localVersion options:NSNumericSearch] ==NSOrderedDescending)
    {
        
        [CustomerAlertViewManger handleVerson:[NSString stringWithFormat:@"中能云管家V%@",newVersion]  Tip:newContent completion:^(NSString *curTweet, BOOL sendSucess) {
        
            
            if (sendSucess) {
                
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/中能云管家/id1360816207?l=zh&ls=1&mt=8"]];//这里写的URL地址是该app在app store里面的下载链接地址，其中ID是该app在app store对应的唯一的ID编号。
                //            https://itunes.apple.com/us/app/中能云管家/id1360816207?l=zh&ls=1&mt=8
                //            https://itunes.apple.com/us/app/yun-di-gang-qin/id1167920903?l=zh&ls=1&mt=8
                NSLog(@"点击现在升级按钮");
                
            }
            
        }];

        
        
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"升级提示"message:msg preferredStyle:UIAlertControllerStyleAlert];
//
//        [vc presentViewController:alert animated:YES completion:nil];
//
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"现在升级" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/中能云管家/id1360816207?l=zh&ls=1&mt=8"]];//这里写的URL地址是该app在app store里面的下载链接地址，其中ID是该app在app store对应的唯一的ID编号。
////            https://itunes.apple.com/us/app/中能云管家/id1360816207?l=zh&ls=1&mt=8
////            https://itunes.apple.com/us/app/yun-di-gang-qin/id1167920903?l=zh&ls=1&mt=8
//            NSLog(@"点击现在升级按钮");
//        }]];
//
//        [alert addAction:[UIAlertAction actionWithTitle:@"下次再说" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSLog(@"点击下次再说按钮");
//        }]];
//
        
        
        
        
    }
}


@end
