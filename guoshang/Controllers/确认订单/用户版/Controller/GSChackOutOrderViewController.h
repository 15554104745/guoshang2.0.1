//
//  GSChackOutOrderViewController.h
//  guoshang
//
//  Created by Rechied on 16/9/18.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSChackOutOrderUserInfoView.h"
#import "GSGroupChackOutOrderDetailModel.h"
#import "GSChackOutDetailModel.h"

@interface GSChackOutOrderViewController : UIViewController

@property (copy, nonatomic) NSString *order_id;
@property (copy, nonatomic) NSString * tokenStr;

@property (assign, nonatomic) GSChackOutOrderType chackOutOrderType;
@property (strong, nonatomic) GSChackOutDetailModel *chackOutDetailModel;
@property (strong, nonatomic) GSGroupChackOutOrderDetailModel *groupDetailModel;
@property (weak, nonatomic) IBOutlet GSChackOutOrderUserInfoView *userInfoView;



@end
