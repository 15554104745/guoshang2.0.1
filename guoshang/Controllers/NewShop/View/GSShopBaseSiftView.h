//
//  GSShopBaseSiftView.h
//  guoshang
//
//  Created by Rechied on 2016/11/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSShopBaseSiftView;
@protocol GSShopBaseSiftViewDelegate <NSObject>

- (void)siftViewDidUpdateHeight:(CGFloat)height;
- (void)siftView:(GSShopBaseSiftView *)siftView didFinishedSelctSiftWithCat_id:(NSString *)cat_id is_exchange:(BOOL)is_exchange brand_id:(NSString *)brand_id;

@end

@interface GSShopBaseSiftView : UIView<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) id<GSShopBaseSiftViewDelegate> delegate;

@property (strong, nonatomic) NSMutableArray *categoryArray;
@property (strong, nonatomic) NSMutableArray *brandArray;

@end
