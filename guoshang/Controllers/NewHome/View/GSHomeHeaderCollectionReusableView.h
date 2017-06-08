//
//  GSHomeHeaderCollectionReusableView.h
//  guoshang
//
//  Created by Rechied on 16/8/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImagesScrollView.h"
#import "GSBannerModel.h"
#import "XRCarouselView.h"
@interface GSHomeHeaderCollectionReusableView : UICollectionReusableView<XRCarouselViewDelegate>

@property (weak, nonatomic) UIView *weakView;

@property (strong, nonatomic) UIView *toolView;
//@property (strong, nonatomic) ImagesScrollView *banner;
@property (strong, nonatomic) XRCarouselView *banner;

@property (strong, nonatomic) UIView *limitContentView;
@property (copy, nonatomic) NSArray *bannerArray;

@property (copy, nonatomic) NSArray *limitArray;


@property (copy, nonatomic) void(^pushBlock)(UIViewController *viewController);
@property (copy, nonatomic) void (^bannerBlock)(NSString *bannerURL);

@end
