//
//  AddGoodsView.h
//  guoshang
//
//  Created by 孙涛 on 16/9/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^passAllValueBlock)(NSDictionary *dataList);
@interface AddGoodsView : UIView

@property (nonatomic, copy)passAllValueBlock block;
@property (nonatomic, retain)NSMutableDictionary *addGoodsDic;
- (void)returnValue:(passAllValueBlock)block;
@end

