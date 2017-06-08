//
//  GSGoodsDetailInfoViewController.h
//  guoshang
//
//  Created by Rechied on 2016/11/10.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSHomeRecommendModel.h"
#import "GSGoodsDetailModel.h"

@interface GSGoodsDetailInfoViewController : UIViewController

@property (copy, nonatomic) NSString *goods_id;

@property (strong, nonatomic) id recommendModel;
@property (strong, nonatomic) GSGoodsDetailModel *goodsDetailModel;
@end
