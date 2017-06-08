//
//  chooesViewController.h
//  guoshang
//
//  Created by 宗丽娜 on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface chooesViewController : UIViewController
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,strong)NSString * getUrl;
@property(nonatomic,strong)NSString * shopid;
@property(nonatomic,strong)NSString * classid;
@property(nonatomic,strong)NSString * keyWord;
-(void)search:(NSString*)keyword;
@end
