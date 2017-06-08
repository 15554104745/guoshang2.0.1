//
//  GSShopBaseSiftSectionCollectionReusableView.h
//  guoshang
//
//  Created by Rechied on 2016/11/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GSShopBaseSiftSectionCollectionReusableViewDelegate <NSObject>

- (void)showAllButtonDidClickWithSection:(NSInteger)section selected:(BOOL)selected;

@end

@interface GSShopBaseSiftSectionCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *showAllButton;

@property (weak, nonatomic) id<GSShopBaseSiftSectionCollectionReusableViewDelegate> delegate;
@property (assign, nonatomic) NSInteger section;

@end
