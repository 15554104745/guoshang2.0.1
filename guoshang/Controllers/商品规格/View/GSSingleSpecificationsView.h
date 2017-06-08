//
//  GSSingleSpecificationsView.h
//  guoshang
//
//  Created by Rechied on 2016/11/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GSSpecificationsModel;
@class GSSpecificationsDetailModel;

@protocol GSSingleSpecificationsViewDelegate <NSObject>

- (void)singleSpecificationsViewDidSelectSpecificationsWithFid:(NSString *)fid attrbute_id:(NSString *)attrbute_id;
- (void)singleSpecificationsViewDidDeSelectSpecificationsWithFid:(NSString *)fid;
@end

@interface GSSingleSpecificationsView : UIView

@property (weak, nonatomic) id<GSSingleSpecificationsViewDelegate> delegate;
@property (strong, nonatomic) GSSpecificationsModel *specificationsModel;

@property (assign, nonatomic) CGFloat contentHeight;

- (instancetype)initWithSpecificationsModel:(GSSpecificationsModel *)specificationsModel ;

- (void)setCanUseSpecifications:(NSArray *)canUseSpecifications;
- (void)resetCanUseSpecifications;
@end


@interface GSSingleSpecificationsViewItemButton : UIButton
@property (strong, nonatomic) GSSpecificationsDetailModel *specificationsDetailModel;
@end
