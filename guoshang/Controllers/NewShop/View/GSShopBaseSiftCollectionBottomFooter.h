//
//  GSShopBaseSiftCollectionBottomFooter.h
//  guoshang
//
//  Created by Rechied on 2016/11/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GSShopBaseSiftCollectionBottomFooterDelegate <NSObject>

- (void)resertButtonClick;

- (void)commitButtonClick;

@end

@interface GSShopBaseSiftCollectionBottomFooter : UICollectionReusableView
@property (weak, nonatomic) id<GSShopBaseSiftCollectionBottomFooterDelegate> delegate;
@end
