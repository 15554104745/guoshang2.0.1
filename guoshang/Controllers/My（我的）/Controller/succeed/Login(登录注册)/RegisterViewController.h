//
//  RegisterViewController.h
//  guoshang
//
//  Created by 张涛 on 16/2/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController

@property(nonatomic,strong)UITextField * numTF;
@property(nonatomic,strong)UITextField * checkTF;
@property(nonatomic,copy)NSString * checkStr;
@property(nonatomic)NSDictionary * dic;

-(void)click:(UIButton *)button;
-(void)toPost;

@end
