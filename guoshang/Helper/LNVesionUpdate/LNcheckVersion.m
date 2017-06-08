//
//  LNcheckVersion.m
//  guoshang
//
//  Created by 宗丽娜 on 16/4/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "LNcheckVersion.h"
#import "LNVersionShowView.h"
#define GetUserDefaut [[NSUserDefaults standardUserDefaults] objectForKey:@"VersionUpdateNotice"]//获得用户记录的上一次的版本
#define ISCHECK  [[NSUserDefaults standardUserDefaults]boolForKey:@"ISCHECK"]//是否为检测更新页面的更新
#define APPID  @"1098039649"


@implementation LNcheckVersion{
    
    
    LNVersionShowView * versionShowView;
    NSString * newVesionStr;
    NSArray * _inforcotent;
}


-(void)CheckVerion:(UpdateBlock)updateblock{
    //获取当前版本
    NSString * version = [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"];
    //1098039649
//    NSString * build = [[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"];
//    
//    NSString * newVersion = [NSString stringWithFormat:@"%@.%@",version,build];

    //获取APPStore版本号
    //测试 604685049
    //本来 1098039649
    [HttpTool GET:[NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@",APPID] parameters:nil success:^(id responseObject) {
        NSMutableDictionary * reDic = [NSMutableDictionary dictionaryWithDictionary:responseObject];
        if (reDic.count > 0) {
            NSArray * inforConent =[reDic objectForKey:@"results"];
            _inforcotent = inforConent;
            
            if (inforConent.count > 0) {
                NSString * currentAppStoreVersion = [[inforConent objectAtIndex:0]objectForKey:@"version"];
//                NSLog(@"APPStore%@",currentAppStoreVersion);
                if ([LNcheckVersion versionlessthan:version Newer:currentAppStoreVersion]) {
//                    NSLog(@"暂不更新");
                    
                    if (!self.isStart) {
    
                        self.toshowAlertNewVersion();
                    }
                    
                }else{
                    self->newVesionStr = currentAppStoreVersion;
                    
//                    NSLog(@"请到AppStore更新%@版本",currentAppStoreVersion);
                    /**
                     *修复问题描述
                     **/
                    
                    NSString * describeStr =[[inforConent valueForKey:@"releaseNotes"]objectAtIndex:0];
                    NSArray * dataArr = [LNcheckVersion separateToRow:describeStr];
                    
                    if (updateblock) {
                        
                        updateblock(currentAppStoreVersion,dataArr);
                    }
                    
                }

            }else{
                
                
                
//                  NSLog(@"no information  with this APP  in the APPStore");
                
            }
            //APPstore上的版本
            
            
        }else{
            
            
            
//            NSLog(@"no information  with this APP  in the APPStore");
            
            
            
        }
    } failure:^(NSError *error) {
        
    }];
    
}
+ (BOOL)versionlessthan:(NSString *)oldOne Newer:(NSString *)newver
{
    if ([oldOne isEqualToString:newver]) {
        
        return YES;
        
    }else{
        if ([oldOne compare:newver options:NSNumericSearch] == NSOrderedDescending)
        {
            return YES;
        }else{
            return NO;
        }
    }
    return NO;
}


+ (NSArray *)separateToRow:(NSString *)describe
{
    NSArray *array= [describe componentsSeparatedByString:@"\n"];
    return array;
}

- (void)showAlertView
{
 
    [self CheckVerion:^(NSString *str, NSArray *DataArr) {
        if (!versionShowView) {
            
            versionShowView = [[LNVersionShowView alloc] initWith:[NSString stringWithFormat:@"版本号:%@",str] Describe:DataArr];
            versionShowView.vesionStr = self->newVesionStr;
            versionShowView.infocontent = _inforcotent;
        }
    }];
}



@end
