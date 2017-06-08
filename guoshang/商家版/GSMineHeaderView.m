//
//  GSMineHeaderView.m
//  guoshang
//
//  Created by Rechied on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSMineHeaderView.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+UIViewController.h"
#import "GSStoreInfoController.h"
#import "UIImageView+WebCache.h"
#import "GoodsManageViewController.h"
#import "IncomeViewController.h"
#import "LNLabel.h"
#import "GSTabbarController.h"

#import "GSMessageCenterController.h"
#import "GSCustomOrderViewController.h"
#import "GSBusinessHomeViewController.h"
#import "GSReimburseListViewController.h"

#import "GoodsInfoViewController.h"
#import "GSGoodsClassViewController.h"

#define ButtonTag(index) index * 88
#define ButtonIndex(tag) tag / 88

typedef NS_ENUM(NSInteger, ButtonType) {
    ButtonTypeCustomerOrder = 1,
    ButtonTypeGoodsManage,
    ButtonTypeIncomeNotes,
    ButtonTypeJinHuoBao,
    
    ButtonTypeClassify = 100,
    ButtonTypeReturnedMoney,
    
};

@implementation GSMineHeaderView


#pragma mark - 初始化
- (instancetype)initWithHeight:(CGFloat)height {
    self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height)];
    if (self) {
        
        
        [self addSubview:self.userInfoView];
        [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.offset(190);
        }];
        
        [self addSubview:self.toolView];
        [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_userInfoView.mas_bottom).offset(0);
            make.left.right.bottom.mas_offset(0);
        }];
        
    }
    return self;
}


#pragma mark - 懒加载

#pragma mark - 顶部用户信息
- (UIView *)userInfoView {
    if (!_userInfoView) {
        _userInfoView = [[UIView alloc] init];
        //_userInfoView.backgroundColor = [UIColor orangeColor];
        self.bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"re_bg_business_center"]];
        [_userInfoView addSubview:_bgView];
        [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_offset(0);
        }];
        UIView *topView = [[UIView alloc] init];
        [_userInfoView addSubview:topView];
        
        [topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_offset(0);
            make.top.offset(30);
            make.height.offset(40);
        }];
        
        
        
        UIView *messageView = [self buttonViewWithTitle:@"消息" iconName:@"re_icon_message" buttonSEL:@selector(messageBtnClick)];
        [topView addSubview:messageView];
        [messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-10);
            make.bottom.offset(0);
            make.top.offset(0);
        }];
        
        UIView *personalView = [self buttonViewWithTitle:@"用户版" iconName:@"re_icon_personl" buttonSEL:@selector(changeToPersonalBuild)];
        [topView addSubview:personalView];
        [personalView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(0);
            make.bottom.offset(0);
            make.right.equalTo(messageView.mas_left).offset(-20);
        }];
        
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"re_back_rect"] forState:UIControlStateNormal];
        [backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:backButton];
        [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            make.left.offset(10);
        }];
        
        
        [_userInfoView addSubview:self.propertyView];
        [_propertyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_offset(0);
            make.height.offset(40);
        }];
        
        
        
        
        self.userView = [[UserView alloc] init];
        __weak typeof(self) weakSelf = self;
        [_userView setClickBlock:^(UIButton *button) {
            //GSMineHeaderView *superView = (GSMineHeaderView *)self.superview;
            if ([weakSelf.delegate respondsToSelector:@selector(GSMineHeaderView:didClickDetailButton:)]) {
                [weakSelf.delegate GSMineHeaderView:weakSelf didClickDetailButton:button];
            }
        }];
        //_userView.backgroundColor = [UIColor grayColor];
        [_userInfoView addSubview:_userView];
        [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(_propertyView.mas_top).offset(-10);
            make.left.right.offset(0);
            make.height.offset(50);
        }];
    }
    
    return _userInfoView;
}


#pragma mark - 资产
- (GSPropertyView *)propertyView {
    if (!_propertyView) {
        _propertyView = [[GSPropertyView alloc] init];
        _propertyView.bgImageView.image = [UIImage imageNamed:@"re_icon_bg_property_new"];
    }
    return _propertyView;
}


#pragma mark - 菜单栏
- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc] init];
        
        [self setupToolViewButtons];
        
    }
    return _toolView;
}

- (void)setupToolViewButtons {
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [_toolView addSubview:topView];
    
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.height.offset(45);
    }];
    [self createToolTopViewWithSuperView:topView];
    
    
    UIView *bottomView = [[UIView alloc] init];
    //bottomView.backgroundColor = [UIColor blueColor];
    [_toolView addSubview:bottomView];
    
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom).offset(0);
        make.left.right.mas_offset(0);
        make.height.offset(75.0f);
    }];
    [self createToolBotViewWithSuperView:bottomView];
    UIView *nextBottomView = [[UIView alloc] init];
    [_toolView addSubview:nextBottomView];
    [nextBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_bottom).offset(0);
        make.left.right.mas_offset(0);
        make.height.offset(75.0f);
    }];

    [self createNextToolBotViewWithSuperView:nextBottomView];
}

- (void)createNextToolBotViewWithSuperView:(UIView *)superView {
    UIView *lastView = nil;
    
    NSArray *buttonTitleArray = @[@"分类管理"];
    NSArray *buttonImageNameArray = @[@"re_icon_toobar_1"];
    
    for (NSInteger i = 0; i < 4; i ++) {
        UIView *tempView = [[UIView alloc] init];
        //tempView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        [superView addSubview:tempView];
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            if (!lastView) {
                make.left.offset(0);
            } else {
                make.left.equalTo(lastView.mas_right).offset(0);
                make.width.equalTo(lastView.mas_width);
            }
            
            if (i == 3) {
                make.right.offset(0);
            }
        }];
        if (i < buttonTitleArray.count) {
            UILabel *tempLab = [[UILabel alloc] init];
            tempLab.textColor = [UIColor lightGrayColor];
            tempLab.font = [UIFont systemFontOfSize:14.0f];
            tempLab.text = buttonTitleArray[i];
            [tempView addSubview:tempLab];
            
            [tempLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(tempView.mas_centerX);
                make.bottom.offset(-10);
            }];
            
            UIImageView *tempImageView = [[UIImageView alloc] init];
            tempImageView.image = [UIImage imageNamed:buttonImageNameArray[i]];
            [tempView addSubview:tempImageView];
            
            [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(tempView.mas_centerX);
                make.bottom.equalTo(tempLab.mas_top).offset(-10);
            }];
            
            UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeSystem];
            [tempButton addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            tempButton.tag = ButtonTag((i+100));
            [tempView addSubview:tempButton];
            
            [tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.bottom.mas_offset(0);
            }];
            
        }
        
        
        
        lastView = tempView;
    }
    

}

- (void)createToolTopViewWithSuperView:(UIView *)superView {
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    [superView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(0);
        make.height.offset(1);
    }];
    
    UIView *lastView = nil;
    NSArray *titleArray = @[@"全部宝贝",@"上新宝贝",@"关注人数"];
    for (NSInteger i = 0; i < 3; i ++) {
        UIView *tempView = [[UIView alloc] init];
        [superView addSubview:tempView];
        
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            if (!lastView) {
                make.left.offset(0);
            } else {
                make.left.equalTo(lastView.mas_right).offset(0);
                make.width.equalTo(lastView.mas_width);
            }
            
            if (i == 2) {
                make.right.offset(0);
            }
            
        }];
        
        lastView = tempView;
        
        //[self createBridgeViewWithSuperView:tempView withTag:29999+i];
        
        LNLabel *label = [LNLabel addLabelWithTitle:titleArray[i] TitleColor:[UIColor lightGrayColor] Font:13 BackGroundColor:[UIColor clearColor]];
        label.tag = 29999+i;
        label.textAlignment = NSTextAlignmentCenter;
        [tempView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tempView.mas_centerX);
            make.centerY.equalTo(tempView.mas_centerY);
        }];
        
//        LNLabel *numLabel = [LNLabel addLabelWithTitle:@"" TitleColor:[UIColor lightGrayColor] Font:11 BackGroundColor:[UIColor clearColor]];
//        numLabel.tag = 29999+i;
//        [tempView addSubview:numLabel];
//        
//        [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(label.mas_right).offset(3);
//            make.bottom.equalTo(label.mas_bottom).offset(5);
//        }];
        
        if (i != 2) {
        
            UILabel *line = [[UILabel alloc] init];
            line.backgroundColor = [UIColor grayColor];
            [tempView addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.equalTo(tempView.mas_right).offset(-1);
                make.top.offset(10);
                make.bottom.offset(-5);
                make.width.offset(1);
            }];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 19999+i;
        [button addTarget:self action:@selector(babyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
}

- (void)setBabyNumberWithAll:(NSString *)all new:(NSString *)new guanZhuNum:(NSString *)guanZhuNum {
    for (NSInteger i = 0; i < 3; i ++) {
        UILabel *tempLabel = [self viewWithTag:29999+i];
        switch (i) {
            case 0: {
                NSString *num = all ? all : @"0";
                tempLabel.text = [NSString stringWithFormat:@"%@:%@",tempLabel.text,num];
            }
                break;
                
            case 1: {
                NSString *num = new ? new : @"0";
                tempLabel.text = [NSString stringWithFormat:@"%@:%@",tempLabel.text,num];
            }
                break;
                
            case 2: {
                NSString *num = guanZhuNum ? guanZhuNum : @"0";
                tempLabel.text = [NSString stringWithFormat:@"%@:%@",tempLabel.text,num];            }
                break;
                
            default:
                break;
        }
    }
}

- (void)babyBtnClick:(UIButton *)button {
    //NSInteger index = button.tag - 19999;
//    NSLog(@"宝贝tag:%zi",index);
}

- (void)createBridgeViewWithSuperView:(UIView *)superView withTag:(NSInteger)tag{
    UIView *view = [[UIView alloc] init];
    
    [superView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-5);
        make.top.offset(5);
        make.width.offset(35);
        make.height.offset(18);
    }];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"re_icon_business_numbg.jpg"]];
//    [view addSubview:imageView];
//    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.left.right.mas_offset(0);
//    }];
    
    LNLabel *label = [LNLabel addLabelWithTitle:@"0" TitleColor:[UIColor whiteColor] Font:13 BackGroundColor:[UIColor clearColor]];
    [view addSubview:label];
    label.tag = tag;
    label.textAlignment = NSTextAlignmentCenter;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
}

- (void)createToolBotViewWithSuperView:(UIView *)superView {
    UIView *lastView = nil;
    
    NSArray *buttonTitleArray = @[@"客户订单",@"商品管理",@"收入记录",@"进货宝"];
    NSArray *buttonImageNameArray = @[@"re_icon_toobar_1",@"re_icon_toobar_2",@"re_icon_toobar_3",@"re_icon_toobar_4"];
    
    for (NSInteger i = 0; i < 4; i ++) {
        UIView *tempView = [[UIView alloc] init];
        //tempView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
        [superView addSubview:tempView];
        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            if (!lastView) {
                make.left.offset(0);
            } else {
                make.left.equalTo(lastView.mas_right).offset(0);
                make.width.equalTo(lastView.mas_width);
            }
            
            if (i == 3) {
                make.right.offset(0);
            }
        }];
        
        UILabel *tempLab = [[UILabel alloc] init];
        tempLab.textColor = [UIColor lightGrayColor];
        tempLab.font = [UIFont systemFontOfSize:14.0f];
        tempLab.text = buttonTitleArray[i];
        [tempView addSubview:tempLab];
        
        [tempLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tempView.mas_centerX);
            make.bottom.offset(-10);
        }];
        
        UIImageView *tempImageView = [[UIImageView alloc] init];
        tempImageView.image = [UIImage imageNamed:buttonImageNameArray[i]];
        [tempView addSubview:tempImageView];
        
        [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(tempView.mas_centerX);
            make.bottom.equalTo(tempLab.mas_top).offset(-10);
        }];
        
        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [tempButton addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        tempButton.tag = ButtonTag((i+1));
        [tempView addSubview:tempButton];
        
        [tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_offset(0);
        }];
        
        lastView = tempView;
    }

}



- (void)backButtonClick {
    if ([_delegate respondsToSelector:@selector(backClick)]) {
        [_delegate backClick];
    }
}

- (void)toolButtonClick:(UIButton *)button {
    NSLog(@"buttonIndex:%zi",ButtonIndex(button.tag));
    ButtonType buttonIndex = ButtonIndex(button.tag);
    
    switch (buttonIndex) {
            //客户订单
        case ButtonTypeCustomerOrder:{
            
            GSCustomOrderViewController *orderVC = [[GSCustomOrderViewController alloc] init];
            orderVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:orderVC animated:YES];
        }
            break;
            //商品管理
        case ButtonTypeGoodsManage:{
            
            GoodsManageViewController *goodsManageVC = [[GoodsManageViewController alloc]init];
            goodsManageVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:goodsManageVC animated:YES];
        
        }
            
            break;
            //收入记录
        case ButtonTypeIncomeNotes:{
            IncomeViewController *incomVC = [[IncomeViewController alloc]init];
            [self.viewController.navigationController pushViewController:incomVC animated:YES];
        }
            
            break;
            //进货宝
        case ButtonTypeJinHuoBao:{
            
            
//            GSBusinessHomeViewController *goods = [[GSBusinessHomeViewController alloc]init];
//            goods.isHiden = @"NO";
//            [self.viewController.navigationController pushViewController:goods animated:YES];
            self.viewController.tabBarController.selectedIndex = 0;
        }
            
            break;
            
        case ButtonTypeReturnedMoney:{
            
            GSReimburseListViewController *reimburseVC = [[GSReimburseListViewController alloc] init];
            reimburseVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:reimburseVC animated:YES];


        }
            
            break;
            
        case ButtonTypeClassify:{//分类管理
            
            GSGoodsClassViewController *classVC = [[GSGoodsClassViewController alloc] init];
            classVC.hidesBottomBarWhenPushed = YES;
            [self.viewController.navigationController pushViewController:classVC animated:YES];
        }
            
            break;
            
            
            
        default:
            break;
    }
}

#pragma mark 左边为图片 右边为文字的按钮
- (UIView *)buttonViewWithTitle:(NSString *)title iconName:(NSString *)iconName buttonSEL:(SEL)buttonSEL {
    UIView *bgView = [[UIView alloc] init];

    
    UILabel *lab = [[UILabel alloc] init];
    lab.text = title;
    lab.font = [UIFont systemFontOfSize:13];
    lab.textColor = WhiteColor;
    [bgView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.mas_equalTo(bgView.mas_centerY);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    if (iconName && ![iconName isEqualToString:@""]) {
        imageView.image = [UIImage imageNamed:iconName];
    } else {
        imageView.backgroundColor = [UIColor lightGrayColor];
    }
    
    [bgView addSubview:imageView];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(lab.mas_left).offset(-2);
        make.centerY.equalTo(bgView.mas_centerY);
        make.size.sizeOffset(CGSizeMake(25, 25));
    }];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView.mas_left).offset(0);
    }];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [messageBtn addTarget:self action:buttonSEL forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:messageBtn];
    [messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    
    return bgView;
}

- (void)messageBtnClick {
//    NSLog(@"message");
    GSReimburseListViewController *listVC = [[GSReimburseListViewController alloc] init];
     [self.viewController.navigationController pushViewController:listVC animated:YES];
//    GSMessageCenterController *messageVC = [[GSMessageCenterController alloc] init];
//    [self.viewController.navigationController pushViewController:messageVC animated:YES];
}

- (void)changeToPersonalBuild {
//    NSLog(@"changeToPersonalBuild");
    
    if ([_delegate respondsToSelector:@selector(backClick)]) {
        [_delegate backClick];
    }
}

@end



#pragma mark - 包含商家头像、店铺名称、联系电话的view
@implementation UserView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.headerImageView = [[UIImageView alloc] init];
        _headerImageView.image = [UIImage imageNamed:@"icon_header_0"];
        _headerImageView.layer.masksToBounds = YES;
        _headerImageView.layer.cornerRadius = 25.0f;
        [self addSubview:_headerImageView];
        
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(20);
            make.size.sizeOffset(CGSizeMake(50, 50));
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        [self addSubview:_nameLabel];
        _nameLabel.textColor = [UIColor colorWithRed:225/255.0f green:225/255.0f blue:225/255.0f alpha:1.0f];
        _nameLabel.text = @"店铺名称";
        _nameLabel.font = [UIFont systemFontOfSize:13.0f];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerImageView.mas_right).offset(20);
            make.top.offset(0);
        }];
        
        self.numLabel = [[UILabel alloc] init];
        [self addSubview:_numLabel];
        _numLabel.textColor = WhiteColor;
        _numLabel.text = @"联系电话";
        _numLabel.font = [UIFont systemFontOfSize:14.0f];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headerImageView.mas_right).offset(20);
            make.bottom.offset(-5);
        }];
        
        UIButton *detailButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [detailButton addTarget:self action:@selector(goToStoreDetail:) forControlEvents:UIControlEventTouchUpInside];
        [detailButton setImage:[UIImage imageNamed:@"re_icon_jt"] forState:UIControlStateNormal];
        [self addSubview:detailButton];
        
        [detailButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.size.sizeOffset(CGSizeMake(30, 30));
            make.right.offset(-20);
        }];
        
    }
    return self;
}

- (void)goToStoreDetail:(UIButton *)button {
//    NSLog(@"push to store detail view controller");
    if (_clickBlock) {
        _clickBlock(button);
    }
}



#pragma mark - 设置要显示的内容
- (void)setHeader:(NSString *)headerImageURLStr name:(NSString *)name num:(NSString *)num {
    if (headerImageURLStr && ![headerImageURLStr isEqualToString:@""]) {
        [_headerImageView sd_setImageWithURL:[NSURL URLWithString:headerImageURLStr]];
    }
    
    if (name && ![name isEqualToString:@""]) {
        _nameLabel.text = name;
    }
    
    if (num && ![num isEqualToString:@""]) {
        _numLabel.text = num;
    }
}

@end
