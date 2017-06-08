//
//  GSMineTopUserInfoView.m
//  guoshang
//
//  Created by Rechied on 2016/10/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMineTopUserInfoView.h"
#import "GSPropertyView.h"

//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
#import "GSBusinessTabBarController.h"

#import "RequestManager.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"

#import "WKProgressHUD.h"
#import "SVProgressHUD.h"


@implementation GSMineTopUserInfoView

- (GSPropertyView *)propertyView {
    if (!_propertyView) {
        GSPropertyView *propertyView = [[GSPropertyView alloc] init];
        propertyView.hidden = YES;
        [self addSubview:propertyView];
        [propertyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(0);
            make.right.offset(-10);
            make.bottom.offset(0);
            make.height.offset(25);
        }];
        _propertyView = propertyView;
        
    }
    return _propertyView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.highlightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.sizeOffset(_highlightImageView.image.size);
    }];
    self.avatarImageView.layer.cornerRadius = (self.highlightImageView.image.size.width-8) / 2;
    self.avatarImageView.layer.masksToBounds = YES;
}

- (void)reloadData {
    if (!UserId) {
        [self.propertyView removeFromSuperview];
        self.memberInfoView.hidden = YES;
        self.loginButton.hidden = NO;
    } else {
        [self getUserData];
        self.loginButton.hidden = YES;
    }
    
    if ([IsBusinessUser isEqualToString:@"YES"]) {
        self.businessButton.hidden = NO;
    } else {
        self.businessButton.hidden = YES;
    }
    
}

- (void)getUserData {
    __weak typeof(self) weakSelf = self;
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/my""") parameters:[@{@"user_id":UserId} addSaltParamsDictionary] completed:^(id responseObject, NSError *error) {
        if (!([responseObject[@"result"] count]== 0)) {
            UserModel * model = [UserModel mj_objectWithKeyValues:responseObject[@"result"]];
            [weakSelf updateDataWithUserModel:model];
        }
    }];
}

- (void)updateDataWithUserModel:(UserModel *)userModel {
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userModel.avatar] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    self.memberInfoView.userNameLabel.text = userModel.user_name;
    self.memberInfoView.memberTypeLabel.text = userModel.rank_name;
    [self.propertyView setGoldNum:userModel.user_money guobiNum:userModel.pay_points topupCardNum:userModel.rechargeable_card_money];
    

    self.memberInfoView.hidden = NO;
    self.propertyView.hidden = NO;
    
    
}

- (IBAction)businissBtnClick:(id)sender {
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.superview.superview.superview withText:@"加载中···" animated:YES];
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@",GS_Business_Shop_id];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/Shop/ShopInfo") parameters:@{@"token":encryptString} completed:^(id responseObject, NSError *error) {
        
        if (responseObject[@"status"] && [responseObject[@"status"] isEqualToString:@"0"]) {
            [hud dismiss:YES];
            //如果店铺审核通过进行跳转
            [self getBusinessUserData];
            
        } else {
            [hud dismiss:YES];
            [SVProgressHUD showErrorWithStatus:@"您的店铺还没有审核通过哟!"];
        }
    }];
}

#pragma mark - 跳转到商家界面
- (void)getBusinessUserData {
    
    GSBusinessTabBarController *businessTabbar = [[GSBusinessTabBarController alloc] init];
    businessTabbar.selectedIndex = 3;
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:businessTabbar];
    mainNav.navigationBarHidden = YES;
    
    [UIView beginAnimations:@"trans" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:[[UIApplication sharedApplication].delegate window] cache:NO];
    [[UIApplication sharedApplication].delegate window].rootViewController = mainNav;
    [UIView commitAnimations];
    
    
}

- (IBAction)loginClick:(id)sender {
    GSNewLoginViewController * myView = [[GSNewLoginViewController alloc] init];
    myView.hidesBottomBarWhenPushed = YES;
    
    if ([_delegate respondsToSelector:@selector(topUserInfoViewWillPushViewController:)]) {
        [_delegate topUserInfoViewWillPushViewController:myView];
    }
}

@end

@implementation GSMemberInfoView



@end
