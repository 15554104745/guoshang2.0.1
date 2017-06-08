//
//  MyGSViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/2/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyGSViewController.h"
#import "UserModel.h"
#import "MyOrderViewController.h"
#import "MyHistoryViewController.h"
#import "MyPropertyViewController.h"
#import "SetUpViewController.h"
//#import "LoginViewController.h"
#import "CurrentIphone.h"
#import "MyCollectViewController.h"
#import "MyPopularizeViewController.h"
#import "GSPropertyView.h"
#import "GSBusinessTabBarController.h"
#import "GSGroupOrderViewController.h"
#import "MyGuoBiViewController.h"
#import "GSNslogDictionaryManager.h"
#import "SLFRechargeViewController.h"

#import "GSBusinessMineViewController.h"
#import "RequestManager.h"
#import "SVProgressHUD.h"
#import "GSMyGSCustomButtonView.h"
#import "WKProgressHUD.h"

#import "GSNewLoginViewController.h"

#import "changePasswordViewController.h"
#import "MyGroupViewController.h"
#import "GSCreateGroupViewController.h"
#import "GSUploadAvatarManager.h"
#import "UIColor+Hex.h"

#define TopButtonTagWithIndex(index) index * 54
#define BottomButtonTagWithIndex(index) index *55
#define GroupButtonTagWithIndex(index) index *56

#define TopButtonIndexWithTag(tag) tag/54
#define BottomButtonIndexWithTag(tag) tag/55
#define GroupButtonIndexWithTag(tag) tag/56
#import "GSReimburseListViewController.h"
@interface MyGSViewController ()
{
    NSMutableArray * _dataArray;
    UIImageView * _userIcon;
    UIScrollView * _sv;
    UIView * _userView;
    GSPropertyView *_propertyView;
    LNLabel *lineLab;
    LNLabel  *userLabel;
    LNLabel  *memberLabel;
    UILabel *line;
    BOOL _isGuide;
    UIButton *_businessButton;
    GSMyGSCustomButtonView *_createGroup;
    NSInteger isGroupOrder;
    
}
@end

@implementation MyGSViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.navigationController.navigationBar.barTintColor = NewRedColor;
    //    if (isGroupOrder) {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"isGuide"] && [[[NSUserDefaults standardUserDefaults] objectForKey:@"isGuide"] isEqualToString:@"YES"]) {
        _isGuide = YES;
        isGroupOrder = 2;
        _createGroup.imageName = @"re_group2";
        _createGroup.titleName = @"去开团";
    } else {
        _isGuide = NO;
        isGroupOrder = 1;
        _createGroup.imageName = @"re_group1";
        _createGroup.titleName = @"团购订单";
    }
    //        _isGuide = YES;2
    
    //    }
    
    
    [self createUserData];
    
    [self isLogin];
    
    
}

- (void)getPropertyData {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    [[RequestManager manager] requestWithMode:RequestModePost URL:URLDependByBaseURL(@"/Api/User/myprofile") parameters:@{@"token":[@{@"user_id":UserId} paramsDictionaryAddSaltString]} completed:^(id responseObject, NSError *error) {
        if ([responseObject[@"status"] isEqualToNumber:@(0)]) {
            //            NSLog(@"%@",responseObject[@"result"]);
            [SVProgressHUD dismiss];
            [_propertyView setGoldNum:responseObject[@"result"][@"user_money"] guobiNum:responseObject[@"result"][@"pay_points"] topupCardNum:responseObject[@"result"][@"rechargeable_card_money"]];
        } else {
            [SVProgressHUD showErrorWithStatus:@"获取数据失败,请稍后再试!"];
        }
    }];
}

-(void)isLogin{
    if (UserId !=nil) {
        UIButton * btn = [self.view viewWithTag:120];
        btn.hidden = YES;
        _propertyView.hidden = NO;
        lineLab.hidden = NO;
        memberLabel.hidden = NO;
        userLabel.hidden = NO;
        line.hidden = NO;
        _businessButton.hidden = !(IsBusinessUser && [IsBusinessUser isEqualToString:@"YES"]);
        
    }else{
        _propertyView.hidden = YES;
        line.hidden = YES;
        lineLab.hidden = YES;
        memberLabel.hidden = YES;
        userLabel.hidden = YES;
        UIButton * btn = [self.view viewWithTag:120];
        btn.hidden = NO;
        _businessButton.hidden = !(IsBusinessUser && [IsBusinessUser isEqualToString:@"YES"]);
        _userIcon.image = [UIImage imageNamed:@"touxiang"];
        
        
    }
    UIView *view = [self.view viewWithTag:202020];
    
    [view mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(142.5);
        
    }];
    
    NSString *  version = [CurrentIphone deviceVersion];
    if ([version isEqualToString:@"iPhone 6 Plus"] || [version isEqualToString:@"iPhone 6 sPlus"]) {
        
        _sv.contentSize = CGSizeMake(Width, Height + 50+20);
        
    } else if ([version containsString:@"5"]) {
        _sv.contentSize = CGSizeMake(Width, Height + 200+20);
    } else if ([version containsString:@"5"]) {
        _sv.contentSize = CGSizeMake(Width, Height + 250+20);
    } else{
        _sv.contentSize = CGSizeMake(Width, Height + 150+20);
        
        
    }
    
}

-(void)createUserData{
    
    if (_dataArray.count> 0) {
        [_dataArray removeAllObjects];
    }
    NSString * encryptString;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
        NSString * userId = [NSString stringWithFormat:@"user_id=%@",UserId];
        encryptString = [userId encryptStringWithKey:KEY];
        //        NSLog(@"%@",encryptString);
        
        NSString *url = URLDependByBaseURL(@"/Api/User/my");
        //@"http://www.ibg100.com/Apiss/index.php?m=Api&c=User&a=my
        [HttpTool POST:url parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            if (!([responseObject[@"result"] count]==0)) {
                
                //[GSNslogDictionaryManager logDictionary:responseObject[@"result"]];
                UserModel * model = [UserModel mj_objectWithKeyValues:responseObject[@"result"]];
                
                [_dataArray addObject:model];
            }
            
            [self settingData];
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }
    
}


-(void)settingData{
    BOOL hasAvatar = NO;
    if (_dataArray.count > 0) {
        UserModel * model = _dataArray[0];
        UILabel * Userlable = [self.view viewWithTag:31];
        Userlable.hidden = NO;
        Userlable.text = model.user_name;
        
        UILabel * memberlable = [self.view viewWithTag:30];
        memberlable.text = model.rank_name;
        memberlable.hidden = NO;
        
        [_propertyView setGoldNum:model.user_money guobiNum:model.pay_points topupCardNum:model.rechargeable_card_money];
        
        if (model.avatar && ![model.avatar isEqualToString:@""]) {
            hasAvatar = YES;
            [_userIcon setImageWithURL:[NSURL URLWithString:model.avatar]];
        }
        
    }
    NSData * imageData = [[NSUserDefaults standardUserDefaults] dataForKey:@"image"];
    if (!hasAvatar && imageData) {
        _userIcon.image = [UIImage imageWithData:imageData];
    }
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *  version = [CurrentIphone deviceVersion];
    self.title = @"我的易购";
    
    
    _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    _sv.backgroundColor = [UIColor colorWithHexString:@"f0f2f5"];
    if ([version isEqualToString:@"iPhone 6 Plus"] || [version isEqualToString:@"iPhone 6 sPlus"]) {
        
        _sv.contentSize = CGSizeMake(Width, Height + 50 + (_isGuide ? 50:0));
        
    } else if ([version containsString:@"5"]) {
        _sv.contentSize = CGSizeMake(Width, Height + 20 + (_isGuide ? 50:0));
    } else if ([version containsString:@"5"]) {
        _sv.contentSize = CGSizeMake(Width, Height + 250 + (_isGuide ? 50:0));
    } else{
        _sv.contentSize = CGSizeMake(Width, Height + 150 + (_isGuide ? 50:0));
        
        
    }
    
    
    
    _sv.showsHorizontalScrollIndicator = YES;
    _sv.showsVerticalScrollIndicator = YES;
    
    [self.view addSubview:_sv];
    _dataArray = [NSMutableArray array];
    [self createItems];
    [self createUI];
    [self setPropertyBtnClick];
    [self createUserData];
    
}
-(void)createItems{
    
    UIBarButtonItem * back = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"icon_nav_back"] highlightedImage:nil target:self action:@selector(toHome:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * idit = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(tolgon)];
    
    
    //    UIBarButtonItem * popItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"分类"] highlightedImage:nil target:self action:@selector(toPop:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSpacer.width = -10;
    self.navigationItem.leftBarButtonItem = back;
    self.navigationItem.rightBarButtonItem = idit;
    
}


-(void)toHome:(UIButton *)button{
    
    self.tabBarController.selectedIndex = 0;
    
}



-(void)tolgon{
    //    NSLog(@"设置");
    SetUpViewController * setUp = [[SetUpViewController alloc] init];
    setUp.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:setUp animated:YES];
    
}

//-(void)toPop:(UIButton *)button{
//
//    PopViewController * vc = [[PopViewController alloc] init];
//    vc.preferredContentSize = CGSizeMake(100, 100);
//    vc.modalPresentationStyle = UIModalPresentationPopover;
//    UIPopoverPresentationController * pop = vc.popoverPresentationController;
//    ;
//    pop.delegate = self;
//
//    pop.barButtonItem = self.navigationItem.rightBarButtonItem;
//
//    [self presentViewController:vc animated:YES completion:nil];
//
//}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}
-(void)createUI{
    //用户布局
    _userView = [[UIView alloc] init];
    _userView.backgroundColor = [UIColor whiteColor];
    [_sv addSubview:_userView];
    [_userView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@180);
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage imageNamed:@"re_bg_custom"];
    [_userView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_offset(0);
    }];
    
    _userIcon = [[UIImageView alloc] init];
    _userIcon.layer.cornerRadius = 40;
    _userIcon.layer.borderColor = [[UIColor whiteColor] CGColor];
    _userIcon.layer.borderWidth = 2.0f;
    _userIcon.clipsToBounds = YES;
    //从本地取用户设置的头像
    _userIcon.image = [UIImage imageNamed:@"touxiang"];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goIntoPhotoLibrary:)];
    _userIcon.userInteractionEnabled = YES;
    [_userIcon addGestureRecognizer:tap];
    [_userView addSubview:_userIcon];
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_userView.mas_centerX);
        make.centerY.equalTo(_userView.mas_centerY).offset(-30);
        make.height.equalTo(@80);
        make.width.equalTo(@80);
    }];
    
    UIView *labContentView = [[UIView alloc] init];
    [_userView addSubview:labContentView];
    [labContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userIcon.mas_bottom).offset(20);
        make.centerX.equalTo(_userIcon.mas_centerX);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"18888888888 | 普通会员" AndFont:15]);
    }];
    userLabel = [LNLabel addLabelWithTitle:@""TitleColor:WhiteColor Font:14  BackGroundColor:[UIColor clearColor]];
    userLabel.tag = 31;
    [labContentView addSubview:userLabel];
    [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"18888888888" AndFont:15]);
    }];
    
    
    
    
    memberLabel = [LNLabel addLabelWithTitle:@"" TitleColor:WhiteColor Font:14 BackGroundColor:[UIColor clearColor]];
    memberLabel.tag = 30;
    [labContentView addSubview:memberLabel];
    [memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(0);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"普通会员" AndFont:15]);
    }];
    lineLab = [LNLabel addLabelWithTitle:@"|" TitleColor:[UIColor whiteColor] Font:18 BackGroundColor:[UIColor clearColor]];
    lineLab.tag = 101010;
    [labContentView addSubview:lineLab];
    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_offset(0);
        make.left.mas_equalTo(userLabel.mas_right).offset(0);
        make.right.equalTo(memberLabel.mas_left).offset(0);
    }];
    
    
    LNButton *enterBtn =[LNButton buttonWithType:UIButtonTypeSystem Title:@"登录" TitleColor:[UIColor whiteColor] Font:20 Target:self AndAction:@selector(toEnter)];
    enterBtn.backgroundColor = NewRedColor;
    enterBtn.layer.cornerRadius = 10;
    enterBtn.tag = 120;
    enterBtn.clipsToBounds = YES;
    [_userView addSubview:enterBtn];
    [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_userIcon.mas_centerX);
        make.top.equalTo(_userIcon.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        
    }];
    
    line = [[UILabel alloc] init];
    [_userView addSubview:line];
    line.backgroundColor = [UIColor whiteColor];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.height.offset(1);
        make.top.equalTo(labContentView.mas_bottom).offset(15);
    }];
    
    _propertyView = [[GSPropertyView alloc] init];
    //_propertyView.backgroundColor = [UIColor redColor];
    [_userView addSubview:_propertyView];
    
    [_propertyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.right.offset(-10);
        make.top.equalTo(line.mas_bottom).offset(1);
        make.bottom.offset(0);
    }];
    
    NSMutableAttributedString *businissBtnTitleStr = [[NSMutableAttributedString alloc] initWithString:@"商家版"];
    NSRange strRange = {0,[businissBtnTitleStr length]};
    [businissBtnTitleStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [businissBtnTitleStr addAttribute:NSForegroundColorAttributeName value:WhiteColor range:strRange];
    _businessButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _businessButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_businessButton setAttributedTitle:businissBtnTitleStr forState:UIControlStateNormal];
    _businessButton.hidden = !(IsBusinessUser && [IsBusinessUser isEqualToString:@"YES"]);
    [_businessButton addTarget:self action:@selector(businissBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [_userView addSubview:_businessButton];
    [_businessButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-20);
        make.top.offset(10);
    }];
    
    if (UserId!=nil) {
        enterBtn.hidden = YES;
        _businessButton.hidden = !(IsBusinessUser && [IsBusinessUser isEqualToString:@"YES"]);
    }else{
        line.hidden = YES;
        _businessButton.hidden = !(IsBusinessUser && [IsBusinessUser isEqualToString:@"YES"]);
        userLabel.hidden = YES;
        memberLabel.hidden = YES;
        _propertyView.hidden = YES;
    }
    
    
    UIView * orderView = [[UIView alloc] init];
    
    orderView.backgroundColor = [UIColor whiteColor];
    orderView.tag = 202020;
    [_sv addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(@196);
        make.right.equalTo(self.view.mas_right);
        make.height.offset(142.5);
        //        if (_isGuide) {
        //            make.height.offset(242.5);
        //        } else {
        //            make.height.offset(192.5);
        //        }
        //
    }];
    
    GSCustomCellView *orderList = [[GSCustomCellView alloc] initWithIcon:@"newdingdan" title:@"我的订单" target:self action:@selector(myOrderClick)];
    [orderView addSubview:orderList];
    [orderList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.offset(50);
        make.top.offset(0);
    }];
    
    //    GSCustomCellView *groupOrder = [[GSCustomCellView alloc] initWithIcon:@"dingdan" title:@"团购订单" target:self action:@selector(groupButtonClick)];
    //    [orderView addSubview:groupOrder];
    //    [groupOrder mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.view.mas_right);
    //        make.left.equalTo(self.view.mas_left);
    //        make.height.offset(50);
    //        make.top.equalTo(orderList.mas_bottom).offset(0);
    //    }];
    //
    //    createGroup = [[GSCustomCellView alloc] initWithIcon:@"dingdan" title:@"去开团" target:self action:@selector(createGroupButtnClick)];
    //    [orderView addSubview:createGroup];
    //    [createGroup mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.right.equalTo(self.view.mas_right);
    //        make.left.equalTo(self.view.mas_left);
    //        //make.height.offset(50);
    //        if (_isGuide) {
    //            make.height.offset(50);
    //        } else {
    //            make.height.offset(0);
    //        }
    //        make.top.equalTo(groupOrder.mas_bottom).offset(0);
    //    }];
    
    
    
    
    int podding = (Width - 40 * 2)/3;
    int buttonWith = (Width - 80)/3;
    LNButton * payMoneyBtn = [LNButton buttonWithType:UIButtonTypeCustom Title:nil TitleColor:nil Font:1 Target:self AndAction:@selector(toclick:)];
    [payMoneyBtn setImage:[UIImage imageNamed:@"newdaifukuan"] forState:UIControlStateNormal];
    payMoneyBtn.tag = 501;
    [orderView addSubview:payMoneyBtn];
    [payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.top.equalTo(orderList.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    LNLabel * payMoneylable = [LNLabel addLabelWithTitle:@"待付款" TitleColor:[UIColor colorWithHexString:@"242424"] Font:15 BackGroundColor: [UIColor whiteColor]];
    payMoneylable.textAlignment = NSTextAlignmentCenter;
    [orderView addSubview:payMoneylable];
    [payMoneylable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(payMoneyBtn);
        make.top.equalTo(payMoneyBtn.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * disGoodsBtn = [[UIButton alloc] init];
    disGoodsBtn.tag = 502;
    [disGoodsBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [disGoodsBtn setImage:[UIImage imageNamed:@"newdaifahuo"] forState:UIControlStateNormal];
    [orderView addSubview:disGoodsBtn];
    [disGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payMoneyBtn.mas_left).offset(buttonWith);
        make.top.equalTo(orderList.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * disGoogslable = [LNLabel addLabelWithTitle:@"待发货" TitleColor:[UIColor colorWithHexString:@"242424"] Font:14 BackGroundColor:[UIColor whiteColor]];
    disGoogslable.textAlignment = NSTextAlignmentCenter;
    [orderView addSubview:disGoogslable];
    [disGoogslable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(disGoodsBtn);
        make.top.equalTo(disGoodsBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * confirmBtn = [[UIButton alloc] init];
    [confirmBtn setImage:[UIImage imageNamed:@"newdaiqueren"] forState:UIControlStateNormal];
    confirmBtn.tag = 503;
    [confirmBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disGoodsBtn.mas_left).offset(buttonWith);
        make.top.equalTo(orderList.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * confirmlLable = [LNLabel addLabelWithTitle:@"待确认" TitleColor:[UIColor colorWithHexString:@"242424"] Font:14 BackGroundColor:[UIColor whiteColor]];
    
    confirmlLable.textAlignment = NSTextAlignmentCenter;
    [orderView addSubview:confirmlLable];
    [confirmlLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(confirmBtn);
        make.top.equalTo(disGoodsBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    UIButton * completeBtn = [[UIButton alloc] init];
    completeBtn.tag = 504;
    [completeBtn setImage:[UIImage imageNamed:@"newyiwancheng"] forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_left).offset(buttonWith);
        make.top.equalTo(orderList.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * completeLable = [LNLabel addLabelWithTitle:@"已完成" TitleColor:[UIColor colorWithHexString:@"242424"] Font:14 BackGroundColor:[UIColor whiteColor]];
    completeLable.textAlignment = NSTextAlignmentCenter;
    [orderView addSubview:completeLable];
    [completeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(completeBtn);
        make.top.equalTo(completeBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    UIImageView * wire3 = [[UIImageView alloc] init];
    wire3.image = [UIImage imageNamed:@"wire"];
    [orderView addSubview:wire3];
    [wire3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(orderView.mas_bottom);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.view.mas_right);
    }];
    
    
    //我的收藏和资产
    UIImageView * wire4 = [[UIImageView alloc] init];
    wire4.image = [UIImage imageNamed:@"wire"];
    [_sv addSubview:wire4];
    [wire4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(orderView.mas_bottom).offset(15);
        make.height.equalTo(@0.5);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView * myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor whiteColor];
    [_sv addSubview:myView];
    [myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire4.mas_bottom);
        make.height.equalTo(@210);
        //          make.height.equalTo(@140);
        
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView *topView = [[UIView alloc] init];
    //    topView.backgroundColor = [UIColor orangeColor];
    UIView *bottomView = [[UIView alloc] init];
    //    bottomView.backgroundColor = [UIColor grayColor];
    UIView *groupView = [[UIView alloc] init];
    //    groupView.backgroundColor = [UIColor redColor];
    [myView addSubview:topView];
    [myView addSubview:bottomView];
    [myView addSubview:groupView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_offset(0);
        make.top.height.mas_equalTo(@70);
    }];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.equalTo(topView.mas_bottom).offset(0);
        make.height.equalTo(topView.mas_height);
    }];
    
    [groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.left.right.offset(0);
        make.top.equalTo(bottomView.mas_bottom).offset(0);
        make.height.equalTo(topView.mas_height);
        
    }];
    //    re_myCenter_bottom1
    //    re_myCenter_top1
    
    
    
    NSArray *topArray = @[@"我的收藏",@"我的金币",@"我的推广"];
    NSArray *bottomArray = @[@"我的充值卡",@"修改密码",@"浏览记录"];
    NSArray *groupArray;
    if (IsGuide&&[IsGuide isEqualToString:@"YES"]) {
        
        groupArray =  @[@"去开团",@"",@""];
        isGroupOrder = 2;
        
    }else{
        groupArray =@[@"团购订单",@"",@""];
        isGroupOrder = 1;
    }
    
    __block GSMyGSCustomButtonView *topLastView = nil;
    __block UIView *bottomLastView = nil;
    __block UIView *groupLastView = nil;
    
    for (int i = 0; i < 3; i ++) {
        GSMyGSCustomButtonView *topButton = [[GSMyGSCustomButtonView alloc] initWithTarget:self action:@selector(topClick:) imageName:[NSString stringWithFormat:@"re_myCenter_top%zi",i+1] title:topArray[i] tag:TopButtonTagWithIndex((i+1))];
        
        [topView addSubview:topButton];
        [topButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            if (i == 0) {
                make.left.offset(0);
            } else {
                make.left.equalTo(topLastView.mas_right).offset(0);
                make.width.equalTo(topLastView.mas_width);
            }
            
            if (i == 2) {
                make.right.offset(0);
            }
            topLastView = topButton;
        }];
        
        
        GSMyGSCustomButtonView *bottomButton = [[GSMyGSCustomButtonView alloc] initWithTarget:self action:@selector(bottomClick:) imageName:[NSString stringWithFormat:@"re_myCenter_bottom%zi",i+1] title:bottomArray[i] tag:BottomButtonTagWithIndex((i+1))];
        
        [bottomView addSubview:bottomButton];
        [bottomButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            if (i == 0) {
                make.left.offset(0);
            } else {
                make.left.equalTo(bottomLastView.mas_right).offset(0);
                make.width.equalTo(bottomLastView.mas_width);
            }
            
            if (i == 2) {
                make.right.offset(0);
            }
            bottomLastView = bottomButton;
        }];
        
        //        开团
        NSString *imageName = nil;
        if (i == 0) {
            if (IsGuide && [IsGuide isEqualToString:@"YES"]) {
                imageName = @"re_group2";
            } else {
                imageName = @"re_group1";
            }
        }
        //        if (i == 1) {
        //            imageName = @"re_group3";
        //        }
        
        GSMyGSCustomButtonView *groupButton = [[GSMyGSCustomButtonView alloc] initWithTarget:self action:i < 2 ? @selector(groupClick:) : nil imageName:imageName title:groupArray[i] tag:GroupButtonTagWithIndex((i+1))];
        [groupView addSubview:groupButton];
        
        [groupButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.offset(0);
            if (i == 0) {
                make.left.offset(0);
                _createGroup = groupButton;
            } else {
                make.left.equalTo(groupLastView.mas_right).offset(0);
                make.width.equalTo(groupLastView.mas_width);
            }
            
            if (i == 2) {
                make.right.offset(0);
            }
            groupLastView = groupButton;
        }];
        
        if (i > 1) {
            
            groupButton.hidden = YES;
        }
        
    }
    
    LNButton * serverLabel = [LNButton buttonWithFrame:CGRectMake(0, 0, 100, 100) Type:UIButtonTypeSystem Title:@"客服电话：400 - 893 - 1880" TitleColor:[UIColor whiteColor] Font:18 BackgroundImage:@"hongkuang1" andBlock:^(LNButton *button) {
        //打电话
#warning  需要修改
        //        [[RequestManager manager] requestWithMode:RequestModePost URL:@"http://192.168.1.169/Apis/index.php/Api/App/device" parameters:nil completed:^(id responseObject, NSError *error) {
        //
        //        }];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008931880"]];
        
        
    }];
    serverLabel.backgroundColor = NewRedColor;
    serverLabel.layer.cornerRadius = 10;
    
    serverLabel.clipsToBounds = YES;
    [_sv addSubview:serverLabel];
    
    [serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(myView.mas_bottom).offset(15);
        make.height.equalTo(@50);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    
}

- (void)setPropertyBtnClick {
    __weak typeof(self) weakSelf = self;
    _propertyView.propertyButtonClickBlock = ^(NSInteger index) {
        
        switch (index) {
            case 0://金币
            {
                
                
            }
                
                break;
                
            case 1://国币
            {
                MyGuoBiViewController * cz = [[MyGuoBiViewController alloc]init];
                [weakSelf.navigationController pushViewController:cz animated:YES];
            }
                break;
                
            case 2://充值卡
                
                break;
                
            default:
                break;
        }
    };
}


- (void)topClick:(UIButton *)button {
    
    if ([self isLoginSuccess]) {
        NSInteger index = TopButtonIndexWithTag(button.tag);
        switch (index) {
            case 1:{//我的收藏
                MyCollectViewController * collect = [[MyCollectViewController alloc] init];
                collect.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collect animated:YES];
            }
                
                break;
                
            case 2:{//我的资产
                MyPropertyViewController * property = [[MyPropertyViewController alloc] init];
                property.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:property animated:YES];
            }
                
                break;
                
            case 3:{//我的推广
                MyPopularizeViewController *popularizerViewController = [[MyPopularizeViewController alloc] init];
                popularizerViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:popularizerViewController animated:YES];
            }
                
                break;
                
            default:
                break;
        }
    }
}

- (void)bottomClick:(UIButton *)button {
    
    
    if ([self isLoginSuccess]) {
        NSInteger index = BottomButtonIndexWithTag(button.tag);
        //        NSLog(@"%zi",index);
        switch (index) {
            case 1:{//我的充值卡
                SLFRechargeViewController *RVC = [[SLFRechargeViewController alloc] init];
                RVC.tap = 1;
                RVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:RVC animated:YES];
            }
                
                break;
                
                
            case 2:{//修改密码
                changePasswordViewController *changeViewController = [[changePasswordViewController alloc] init];
                changeViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:changeViewController animated:YES];
            }
                
                break;
                
                
            case 3:{//浏览记录
                MyHistoryViewController * mhvc = [[MyHistoryViewController alloc] init];
                mhvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mhvc animated:YES];
            }
                
                break;
                
            default:
                break;
                
                
        }
        
        
    }
    
    
}
- (void)groupClick:(UIButton*)button{
    
    NSInteger index = BottomButtonIndexWithTag(button.tag);
    if (index == 1) {
        switch (isGroupOrder) {
            case 1:
            {
                [self groupButtonClick];
            }
                break;
            case 2:
            {
                [self createGroupButtnClick];
            }
                break;
                
            default:
                break;
        }
        
    }
    
    //退款管理点击事件
    if (index == 2) {
        NSLog(@"退款管理");
        //        GSReimburseListViewController *reimburseVC = [[GSReimburseListViewController alloc] init];
        //        reimburseVC.hidesBottomBarWhenPushed = YES;
        //        [self.navigationController pushViewController:reimburseVC animated:YES];
        
    }
    
}

#pragma mark - 我的订单按钮点击后
- (void)myOrderClick {
    if ([self isLoginSuccess]) {
        //        GoodsListViewController * orderView = [[GoodsListViewController alloc] init];
        MyOrderViewController * orderView = [[MyOrderViewController alloc]init];
        orderView.hidesBottomBarWhenPushed = YES;
        orderView.informNum = 0;
        [self.navigationController pushViewController:orderView animated:YES];
        
    }
}

#pragma mark - 团购订单按钮点击后
- (void)groupButtonClick {
    
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!= nil) {
        
        GSGroupOrderViewController *orderVC = [[GSGroupOrderViewController alloc] init];
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }else{
        
        CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"您还没有登录,请先登录!"];
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我再想想" handler:nil];
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"立即登录" backgroundColor:[UIColor colorWithHexString:@"f23030"] titleColor:[UIColor whiteColor] handler:^(CKAlertAction *action) {
            GSNewLoginViewController *loginViewController = [[GSNewLoginViewController alloc] init];
            loginViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginViewController animated:YES];
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [self presentViewController:alert animated:NO completion:nil];
    }
    
    //    NSLog(@"click group button");
}



- (BOOL)isLoginSuccess {
    if (!UserId) {
        CKAlertViewController *alert = [CKAlertViewController alertControllerWithTitle:@"温馨提示" message:@"您还没有登录,请先登录!"];
        CKAlertAction *cancel = [CKAlertAction actionWithTitle:@"我再想想" handler:nil];
        CKAlertAction *sure = [CKAlertAction actionWithTitle:@"立即登录" backgroundColor:[UIColor colorWithHexString:@"f23030"] titleColor:[UIColor whiteColor] handler:^(CKAlertAction *action) {
            GSNewLoginViewController *loginViewController = [[GSNewLoginViewController alloc] init];
            loginViewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:loginViewController animated:YES];
        }];
        [alert addAction:cancel];
        [alert addAction:sure];
        [self presentViewController:alert animated:NO completion:nil];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - 去团购点击后
- (void)createGroupButtnClick {
    
    if ([self isLoginSuccess]) {
        
        GSCreateGroupViewController *createVC = ViewController_in_Storyboard(@"Main", @"GSCreateGroupViewController");
        [self.navigationController pushViewController:createVC animated:YES];
        
    }
    
}
#pragma mark ----删除
-(void)testData{
    NSString * encryptString;
    
    NSString * userId = [NSString stringWithFormat:@"user_id=%@",UserId];
    encryptString = [userId encryptStringWithKey:KEY];
    //        NSLog(@"%@",encryptString);
    
    [HttpTool POST: URLDependByBaseURL(@"/Api/Groupon/startGroup") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        
        //            NSLog(@"%@",responseObject);
        
    } failure:^(NSError *error) {
    }];
    
    
}
#pragma mark - 一键充值点击后
- (void)oneKeyTopUpClick {
    if ([self isLoginSuccess]) {
        SLFRechargeViewController *RechargeM = [[SLFRechargeViewController alloc] init];
        [self.navigationController pushViewController:RechargeM animated:YES];
    }
}

#pragma mark - 登录页面的跳转实现
-(void)toEnter{
    
    GSNewLoginViewController * myView = [[GSNewLoginViewController alloc] init];
    myView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myView animated:YES];
    
}


#pragma mark - 按钮的点击事件实现
-(void)toclick:(UIButton *)button{
    
    NSInteger count = button.tag - 500;
    NSString * order = [NSString stringWithFormat:@"%ld",(long)count];
    
    //按钮的赋值 让bar的位置改变传值
    if (count<= 4) {
        [[NSUserDefaults standardUserDefaults] setObject:order forKey:@"order"];
    }
    
    if (UserId!=nil) {
        switch (button.tag - 500) {
                
            case 0:{
                
                
                
            }
                break;
                
            case 1:{
                
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 1;
                [self.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
            case 2:{
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 2;
                [self.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
            case 3:{
                
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 3;
                [self.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
            case 4:{
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 4;
                [self.navigationController pushViewController:orderView animated:YES];
                
            }
                break;
                
            case 5:{
                MyCollectViewController * collect = [[MyCollectViewController alloc] init];
                collect.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:collect animated:YES];
                
            }
                break;
                
            case 6:{
                MyPropertyViewController * property = [[MyPropertyViewController alloc] init];
                property.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:property animated:YES];
                
            }
                break;
                
            case 7:{
                MyHistoryViewController * mhvc = [[MyHistoryViewController alloc] init];
                mhvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mhvc animated:YES];
                //                NSLog(@"浏览历史");
            }
                break;
                
            case 8:{
                MyPopularizeViewController * mhvc = [[MyPopularizeViewController alloc] init];
                mhvc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:mhvc animated:YES];
                //                NSLog(@"我的推广");
            }
            default:
                break;
        }
        
        
    }else{
        
        [AlertTool alertMesasge:@"请先登录" confirmHandler:nil viewController:self];
    }
    
}

#pragma mark - 上传头像
-(void)goIntoPhotoLibrary:(UITapGestureRecognizer *)tap {
    if (UserId != nil) {
        [GSUploadAvatarManager uploadAvatar:^(UIImage *image) {
            if (image) {
                _userIcon.image = image;
            }
        }];
    }
    
}


-(void)toSetUp:(UIButton *)button{
    SetUpViewController * setUp = [[SetUpViewController alloc] init];
    [self.navigationController pushViewController:setUp animated:YES];
    
}


#pragma mark - 跳转到商家界面
- (void)businissBtnClick {
    
    WKProgressHUD *hud = [WKProgressHUD showInView:self.view withText:@"加载中···" animated:YES];
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

#pragma mark ========= 如果店铺审核通过进行跳转==================
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

@interface GSCustomCellView()
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) UIImageView *topLine;
@property (strong, nonatomic) UIImageView *bottomLine;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) LNLabel *titleLab;
@end

@implementation GSCustomCellView

- (instancetype)initWithIcon:(NSString *)iconName title:(NSString *)title target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.topLine = [[UIImageView alloc] init];
        _topLine.image = [UIImage imageNamed:@"wire"];
        [self addSubview:_topLine];
        [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_offset(0);
            make.height.offset(1);
        }];
        
        self.bottomLine = [[UIImageView alloc] init];
        _bottomLine.image = [UIImage imageNamed:@"wire"];
        [self addSubview:_bottomLine];
        [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_offset(0);
            
        }];
        self.leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
        [self addSubview:_leftImageView];
        
        [_leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.titleLab = [LNLabel addLabelWithTitle:title TitleColor:WordColor Font:18 BackGroundColor:[UIColor whiteColor]];
        [self addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_leftImageView.mas_right).offset(5);
            //make.top.offset(15);
            make.centerY.equalTo(self.mas_centerY);
            //make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"团购订单" AndFont:18]);
        }];
        
        self.rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"gengduo2"];
        [self addSubview:_rightImageView];
        [_rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-15);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@10);
            make.width.equalTo(@10);
        }];
        
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.button];
        [_button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_offset(0);
        }];
        
    }
    return self;
}

@end
