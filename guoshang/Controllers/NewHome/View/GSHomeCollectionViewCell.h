//
//  GSHomeCollectionViewCell.h
//  guoshang
//
//  Created by Rechied on 16/8/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSHomeGoodsView.h"
#import "GSHomeCollectionCellModel.h"

@protocol GSHomeCollectionViewCellDelegate <NSObject>

@optional
- (void)homeCellWillPushViewController:(UIViewController *)viewController;
- (void)homeCellDidFinishLoadImageWithIndexPath:(NSIndexPath *)indexPath imageSize:(CGSize)imageSize;

@end

@interface GSHomeCollectionViewCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet GSHomeGoodsView *homeGoodsView;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (weak, nonatomic) IBOutlet UIView *cellTitleView;
@property (weak, nonatomic) IBOutlet UIImageView *topADView;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) id<GSHomeCollectionViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *homeGoodsViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topADViewHeight;

@property (strong, nonatomic) GSHomeCollectionCellModel *cellModel;

//@property (copy, nonatomic) void(^finishSetImageBlock)(CGSize imageSize);
//
//@property (copy, nonatomic) void(^pushBlock)(UIViewController *viewController);
@end
