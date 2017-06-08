//
//  GSMineTopUserInfoView.h
//  guoshang
//
//  Created by Rechied on 2016/10/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GSPropertyView;
@class GSMemberInfoView;

@protocol GSMineTopUserInfoViewDelegate <NSObject>

- (void)topUserInfoViewWillPushViewController:(UIViewController *)viewController;

@end

@interface GSMineTopUserInfoView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *highlightImageView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIButton *businessButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) GSPropertyView *propertyView;

@property (weak, nonatomic) IBOutlet GSMemberInfoView *memberInfoView;

@property (weak, nonatomic) IBOutlet id delegate;

- (void)reloadData;

@end

@interface GSMemberInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberTypeLabel;
@end
