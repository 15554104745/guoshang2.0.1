//
//  GSSellerOrderFooter.h
//  guoshang
//
//  Created by 金联科技 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^reload)();
@interface GSSellerOrderFooter : UIView

@property (nonatomic,strong) NSDictionary *footerInfoDic;
@property (nonatomic, copy) reload loadData;
@end
