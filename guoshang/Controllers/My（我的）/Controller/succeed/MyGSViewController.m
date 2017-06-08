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
#import "LoginViewController.h"
#import "CurrentIphone.h"
#import "MyCollectViewController.h"

@interface MyGSViewController ()
{
    NSMutableArray * _dataArray;
    UIImageView * _userIcon;
    UIScrollView * _sv;
    UIView * _userView;
   

}
@end

@implementation MyGSViewController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    [self createUserData];
    
    [self isLogin];
    
}
-(void)isLogin{
    if (UserId !=nil) {
        UIButton * btn = [self.view viewWithTag:120];
        btn.hidden = YES;
        
        for (int i = 0; i< 2; i++) {
            UILabel * lable = [self.view viewWithTag:30 + i];
            lable.hidden = NO;
        }
    }else{
        for (int i = 0; i< 2; i++) {
            UILabel * lable = [self.view viewWithTag:30 + i];
            lable.hidden = YES;
        }
        UIButton * btn = [self.view viewWithTag:120];
        btn.hidden = NO;
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
        NSLog(@"%@",encryptString);

        [HttpTool POST:@"http://www.ibg100.com/Apiss/index.php?m=Api&c=User&a=my" parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            if (responseObject[@"result"]!=nil) {
                NSDictionary * dic = [NSDictionary dictionaryWithDictionary:responseObject[@"result"]];
                
                UserModel * model = [UserModel ModelWithDict:dic];
                
                [_dataArray addObject:model];

            }
            
            
           [self settingData];
            
            
        } failure:^(NSError *error) {
            
        }];

    }
 
}


-(void)settingData{
    if (_dataArray.count > 0) {
        UserModel * model = _dataArray[0];
            UILabel * Userlable = [self.view viewWithTag:31];
        Userlable.text = model.user;
      
        UILabel * memberlable = [self.view viewWithTag:30];
        memberlable.text = model.number;
    }
    NSData * imageData = [[NSUserDefaults standardUserDefaults] dataForKey:@"image"];
//    NSLog(@"头像数据%@",imageData);
    if (imageData!= nil) {
        _userIcon.image = [UIImage imageWithData:imageData];
      
    }else{
        
//        _userIcon.image = [UIImage imageNamed:@"touxiang"];
        
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *  version = [CurrentIphone deviceVersion];
    self.title = @"我的国商";
    _sv = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    _sv.backgroundColor = MyColor;
    if ([version isEqualToString:@"iPhone 6 Plus"] || [version isEqualToString:@"iPhone 6 sPlus"]) {
         _sv.contentSize = CGSizeMake(Width, Height+ 200);
    }else{
        _sv.contentSize = CGSizeMake(Width, Height);
        

    }

    _sv.showsHorizontalScrollIndicator = YES;
    _sv.showsVerticalScrollIndicator = YES;
    [self.view addSubview:_sv];
    _dataArray = [NSMutableArray array];
    [self createItems];
    [self createUI];
    [self createUserData];
   
}
-(void)createItems{
    
    UIBarButtonItem * back = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toHome:) forControlEvents:UIControlEventTouchUpInside];
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
    NSLog(@"设置");
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
        make.height.equalTo(@100);
    }];
    
    _userIcon = [[UIImageView alloc] init];
    _userIcon.layer.cornerRadius = 35;
    _userIcon.clipsToBounds = YES;
    //从本地取用户设置的头像
         _userIcon.image = [UIImage imageNamed:@"touxiang"];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goIntoPhotoLibrary:)];
    _userIcon.userInteractionEnabled = YES;
    [_userIcon addGestureRecognizer:tap];
    [_userView addSubview:_userIcon];
    [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.top.equalTo(self.view.mas_top).offset(15);
        make.height.equalTo(@75);
        make.width.equalTo(@75);
    }];

        LNLabel  *userLabel = [LNLabel addLabelWithTitle:@""TitleColor:WordColor Font:17  BackGroundColor:[UIColor whiteColor]];
            userLabel.tag = 31;
            [_userView addSubview:userLabel];
            [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userIcon.mas_right).offset(20);
            make.top.equalTo(_userIcon.mas_top).offset(25);
            make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"18888888888" AndFont:18]);
                
            }];
    
    
            LNLabel  *memberLabel = [LNLabel addLabelWithTitle:@"" TitleColor:WordColor Font:17 BackGroundColor:[UIColor whiteColor]];
            memberLabel.tag = 30;
            [_userView addSubview:memberLabel];
            [memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_userIcon.mas_top).offset(25);
                make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"没有会员等级信息" AndFont:17]);
                make.left.equalTo(userLabel.mas_right).offset(5);
                
            }];
    
    
    LNButton *enterBtn =[LNButton buttonWithType:UIButtonTypeSystem Title:@"请登录" TitleColor:[UIColor whiteColor] Font:20 Target:self AndAction:@selector(toEnter)];
     enterBtn.backgroundColor = NewRedColor;
    enterBtn.layer.cornerRadius = 10;
    enterBtn.tag = 120;
    enterBtn.clipsToBounds = YES;
       [_userView addSubview:enterBtn];
        [enterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_userIcon.mas_right).offset(30);
            make.top.equalTo(_userIcon.mas_top).offset(20);
            make.height.equalTo(@30);
            make.width.equalTo(@100);
    
        }];
    if (UserId!=nil) {
        enterBtn.hidden = YES;
    }else{
        
        userLabel.hidden = YES;
        memberLabel.hidden = YES;
    }
 
    
    UIImageView * userWire = [[UIImageView alloc] init];
    userWire.image = [UIImage imageNamed:@"wire"];
    [_sv addSubview:userWire];
    [userWire mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.view.mas_right);
                make.top.equalTo(_userView.mas_bottom);
                make.height.equalTo(@1);
                make.left.equalTo(self.view.mas_left);
                
            }];

    //我的订单
    UIImageView * wire = [[UIImageView alloc] init];
    wire.image = [UIImage imageNamed:@"wire"];
    [_sv addSubview:wire];
    [wire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(@116);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView * orderView = [[UIView alloc] init];
    orderView.backgroundColor = [UIColor whiteColor];
    [_sv addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire.mas_bottom);
        make.height.equalTo(@142.5);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIImageView * wire2 = [[UIImageView alloc] init];
    wire2.image = [UIImage imageNamed:@"wire"];
    [orderView addSubview:wire2];
    [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire.mas_bottom).offset(50);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];
    

    UIImageView * orderIcon = [[UIImageView alloc] init];
    orderIcon.image = [UIImage imageNamed:@"dingdan"];
    [orderView addSubview:orderIcon];
    [orderIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@15);
        make.top.equalTo(orderView.mas_top).offset(15);
        make.width.equalTo(@21);
        
    }];
    
   LNLabel * myOrderLable = [LNLabel addLabelWithTitle:@"我的订单" TitleColor:WordColor Font:18 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:myOrderLable];
    [myOrderLable mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(orderIcon.mas_right).offset(5);
        make.top.equalTo(wire.mas_bottom).offset(15);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"我的订单" AndFont:18]);
    }];
    
    LNButton * seeAllBtn = [LNButton buttonWithType:UIButtonTypeCustom Title:nil TitleColor:nil Font:1 Target:self AndAction:@selector(toclick:)];
    seeAllBtn.tag = 500;
    [orderView addSubview:seeAllBtn];
    [seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(orderView.mas_left);
        make.right.equalTo(orderView.mas_right);
        make.top.equalTo(orderView.mas_top);
        make.bottom.equalTo(wire2.mas_bottom);
    }];
    
    UIImageView * seeAllIcon = [[UIImageView alloc] init];
    seeAllIcon.image = [UIImage imageNamed:@"gengduo2"];
    [orderView addSubview:seeAllIcon];
    [seeAllIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.top.equalTo(wire.mas_bottom).offset(20);
        make.height.equalTo(@10);
        make.width.equalTo(@10);
    }];
    
    LNLabel * seeAllLable = [LNLabel addLabelWithTitle:@"查看全部订单" TitleColor:[UIColor colorWithRed:137/255.0 green:137/255.0  blue:137/255.0  alpha:1.0] Font:14 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:seeAllLable];
    [seeAllLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(seeAllBtn.mas_left);
        make.top.equalTo(wire.mas_bottom).offset(17);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"查看全部订单" AndFont:14]);
    }];
    

    
    int podding = (self.view.frame.size.width - 40 * 2)/3;
    LNButton * payMoneyBtn = [LNButton buttonWithType:UIButtonTypeCustom Title:nil TitleColor:nil Font:1 Target:self AndAction:@selector(toclick:)];
    [payMoneyBtn setImage:[UIImage imageNamed:@"fukuan"] forState:UIControlStateNormal];
    payMoneyBtn.tag = 501;
    [orderView addSubview:payMoneyBtn];
    [payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(wire2.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
   LNLabel * payMoneylable = [LNLabel addLabelWithTitle:@"待付款" TitleColor:WordColor Font:15 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:payMoneylable];
    [payMoneylable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(payMoneyBtn.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * disGoodsBtn = [[UIButton alloc] init];
    disGoodsBtn.tag = 502;
    [disGoodsBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [disGoodsBtn setImage:[UIImage imageNamed:@"dier"] forState:UIControlStateNormal];
    [orderView addSubview:disGoodsBtn];
    [disGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payMoneyBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * disGoogslable = [LNLabel addLabelWithTitle:@"待发货" TitleColor:WordColor Font:14 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:disGoogslable];
    [disGoogslable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payMoneylable.mas_left).offset(podding);
        make.top.equalTo(disGoodsBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * confirmBtn = [[UIButton alloc] init];
    [confirmBtn setImage:[UIImage imageNamed:@"queren1"] forState:UIControlStateNormal];
    confirmBtn.tag = 503;
    [confirmBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disGoodsBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * confirmlLable = [LNLabel addLabelWithTitle:@"待确认" TitleColor:WordColor Font:14 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:confirmlLable];
    [confirmlLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disGoodsBtn.mas_left).offset(podding);
        make.top.equalTo(disGoodsBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * completeBtn = [[UIButton alloc] init];
    completeBtn.tag = 504;
    [completeBtn setImage:[UIImage imageNamed:@"wancheng"] forState:UIControlStateNormal];
    [completeBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(20);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    LNLabel * completeLable = [LNLabel addLabelWithTitle:@"已完成" TitleColor:WordColor Font:14 BackGroundColor:[UIColor whiteColor]];
    [orderView addSubview:completeLable];
    [completeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmlLable.mas_left).offset(podding);
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
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];

    
    //我的收藏和资产
    UIImageView * wire4 = [[UIImageView alloc] init];
     wire4.image = [UIImage imageNamed:@"wire"];
    [_sv addSubview:wire4];
    [wire4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(orderView.mas_bottom).offset(15);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];

    UIView * myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor whiteColor];
    [_sv addSubview:myView];
    [myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire4.mas_bottom);
        make.height.equalTo(@150);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIImageView * wire5 = [[UIImageView alloc] init];;
    wire5.image = [UIImage imageNamed:@"wire"];
    [myView addSubview:wire5];
    [wire5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire4.mas_bottom).equalTo(@50);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];

    UIButton * collectionBtn =[[UIButton alloc] init];
    collectionBtn.tag = 505;
    [collectionBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(myView.mas_right);
        make.top.equalTo(myView.mas_top);
        make.bottom.equalTo(wire5.mas_bottom);
        make.left.equalTo(myView.mas_left);
        
    }];
    
    UIImageView * collectionbtnIcon =[[UIImageView alloc] init];
    collectionbtnIcon.image = [UIImage imageNamed:@"gengduo2"];
    [myView addSubview:collectionbtnIcon];
    [collectionbtnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(myView.mas_right).offset(-15);
        make.top.equalTo(myView.mas_top).offset(20);
        make.height.equalTo(@10);
        make.width.equalTo(@10);
        
    }];
    
    UIImageView * collectionImage =[[UIImageView alloc] init];
    collectionImage.image = [UIImage imageNamed:@"shoucan"];
    [myView addSubview:collectionImage];
    [collectionImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myView.mas_left).offset(15);
        make.top.equalTo(myView.mas_top).offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    LNLabel * collectionLabel =[LNLabel addLabelWithTitle:@"我的收藏" TitleColor:WordColor Font:14 BackGroundColor:[UIColor whiteColor]];
    [myView addSubview:collectionLabel];
    [collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collectionImage.mas_right).offset(5);
        make.top.equalTo(wire4.mas_top).offset(15);
       make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"我的收藏" AndFont:15]);
        
    }];
    
    UIImageView * wire6 = [[UIImageView alloc] init];
    wire6.image = [UIImage imageNamed:@"wire"];
    [_sv addSubview:wire6];
    [wire6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire5.mas_bottom).offset(50);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];
 
    UIButton * momeyBtn =[[UIButton alloc] init];
    momeyBtn.tag = 506;
    [momeyBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:momeyBtn];
    [momeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(myView.mas_right);
        make.top.equalTo(wire5.mas_bottom);
        make.left.equalTo(myView.mas_left);
        make.bottom.equalTo(wire6.mas_bottom);
        
    }];
    
    UIImageView * momeyBtnIcon = [[UIImageView alloc] init];
    momeyBtnIcon.image = [UIImage imageNamed:@"gengduo2"];
    [myView addSubview:momeyBtnIcon];
    [momeyBtnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(myView.mas_right).offset(-15);
        make.top.equalTo(wire5.mas_bottom).offset(20);
        make.height.equalTo(@10);
        make.width.equalTo(@10);
        
    }];
    
    UIImageView * moneyImage =[[UIImageView alloc] init];
    moneyImage.image = [UIImage imageNamed:@"zichan"];
    [myView addSubview:moneyImage];
    [moneyImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myView.mas_left).offset(15);
        make.top.equalTo(wire5.mas_bottom).offset(15);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
        
    }];
    LNLabel * momeyLabel =[LNLabel addLabelWithTitle:@"我的资产" TitleColor:WordColor Font:15 BackGroundColor:[UIColor whiteColor]];
    [myView addSubview:momeyLabel];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyImage.mas_right).offset(8);
        make.top.equalTo(wire5.mas_top).offset(15);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"我的资产" AndFont:15]);
        
    }];
    
    UIButton * extensionBtn =[[UIButton alloc] init];
    [extensionBtn setImage:[UIImage imageNamed:@"gengduo2"] forState:UIControlStateNormal];
    extensionBtn.tag = 507;
    [extensionBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:extensionBtn];
    [extensionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(myView.mas_right).offset(-15);
            make.top.equalTo(wire6.mas_bottom).offset(20);
            make.height.equalTo(@10);
            make.width.equalTo(@10);
        }];
    
        UIImageView * extensionBtnImage =[[UIImageView alloc] init];
        extensionBtnImage.image = [UIImage imageNamed:@"liulan"];
        [myView addSubview:extensionBtnImage];
        [extensionBtnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(myView.mas_left).offset(15);
            make.top.equalTo(wire6.mas_bottom).offset(15);
            make.height.equalTo(@20);
            make.width.equalTo(@20);
        }];
        LNLabel * extensionBtnLable =[LNLabel addLabelWithTitle:@"我的推广" TitleColor:WordColor Font:15 BackGroundColor:[UIColor whiteColor]];
        [myView addSubview:extensionBtnLable];
        [extensionBtnLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(extensionBtnImage.mas_right).offset(8);
            make.top.equalTo(wire6.mas_bottom).offset(15);
            make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"我的推广" AndFont:15]);
        }];
    
        UIImageView * wire7 = [[UIImageView alloc]init];
        wire7.image = [UIImage imageNamed:@"wire"];
        [_sv addSubview:wire7];
        [wire7 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.top.equalTo(wire6.mas_bottom).offset(50);
            make.height.equalTo(@1);
            make.right.equalTo(self.view.mas_right);
        }];

    
    
    
    //*********************最近浏览 不要删****************************************
//    UIButton * seeBtn =[[UIButton alloc] init];
//     [seeBtn setImage:[UIImage imageNamed:@"gengduo2"] forState:UIControlStateNormal];
//    seeBtn.tag = 507;
//    [seeBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
////    [myView addSubview:seeBtn];
////    [seeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.right.equalTo(myView.mas_right).offset(-15);
////        make.top.equalTo(wire6.mas_bottom).offset(15);
////        make.height.equalTo(@20);
////        make.width.equalTo(@20);
////    }];
//    
//    UIImageView * seeImage =[[UIImageView alloc] init];
//    seeImage.image = [UIImage imageNamed:@"liulan"];
//    [myView addSubview:seeImage];
//    [seeImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(myView.mas_left).offset(15);
//        make.top.equalTo(wire6.mas_bottom).offset(15);
//        make.height.equalTo(@20);
//        make.width.equalTo(@20);
//    }];
//    LNLabel * seeLable =[LNLabel addLabelWithTitle:@"最近浏览" TitleColor:WordColor Font:15 BackGroundColor:[UIColor whiteColor]];
//    [myView addSubview:seeLable];
//    [seeLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(seeImage.mas_right).offset(8);
//        make.top.equalTo(wire6.mas_bottom).offset(15);
//        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"最近浏览" AndFont:15]);
//    }];
//  
//    UIImageView * wire7 = [[UIImageView alloc]init];
//    wire7.image = [UIImage imageNamed:@"wire"];
//    [_sv addSubview:wire7];
//    [wire7 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.view.mas_left);
//        make.top.equalTo(wire6.mas_bottom).offset(50);
//        make.height.equalTo(@1);
//        make.right.equalTo(self.view.mas_right);
//    }];
//@"客服电话：400 - 893 - 1880"
    //客服电话
    
    LNButton * serverLabel = [LNButton buttonWithFrame:CGRectMake(0, 0, 100, 100) Type:UIButtonTypeSystem Title:@"客服电话：400 - 893 - 1880" TitleColor:[UIColor whiteColor] Font:18 BackgroundImage:@"hongkuang1" andBlock:^(LNButton *button) {
        
        //打电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4008931880"]];
        
        
    }];
    
    serverLabel.layer.cornerRadius = 10;

    serverLabel.clipsToBounds = YES;
    [_sv addSubview:serverLabel];
    
    [serverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(wire6.mas_bottom).offset(15);
        make.height.equalTo(@50);
        make.right.equalTo(self.view.mas_right).offset(-10);
    }];
    
    
}
#pragma mark - 登录页面的跳转实现
-(void)toEnter{
    
    LoginViewController * myView = [[LoginViewController alloc] init];
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
                
                MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
                orderView.hidesBottomBarWhenPushed = YES;
                orderView.informNum = 0;
                [self.navigationController pushViewController:orderView animated:YES];
             
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
                NSLog(@"浏览历史");
            }
                break;
            default:
                break;
        }
        

    }else{
        
        [AlertTool alertMesasge:@"请先登录" confirmHandler:nil viewController:self];
    }
    
}

-(void)goIntoPhotoLibrary:(UITapGestureRecognizer *)tap{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    //判断一下 当前设备支持哪种功能(相机和相册)
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        NSLog(@"支持相机");
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        NSLog(@"支持相册");
    }
    //设置代理
    picker.delegate = self;
    
    //从当前页面进入到相册页面
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}
#pragma mark --UIImagePickerDelegate--

//选完照片后调用
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //选择完照片 或者 照完相之后,会调用该方法,并且选择的图片或者刚照出来的图片都存在了info里
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        //如果刚才的图片是从相册里选的
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
          NSData * imageData = UIImageJPEGRepresentation(image, 1);
         [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
        _userIcon.image = image;
        
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        //如果刚才的图片是刚刚照出来的
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
          NSData * imageData = UIImageJPEGRepresentation(image, 1);
         [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
        _userIcon.image = image;
    }
    //选完之后 让相册消失
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}
//取消选择照片调用
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


-(void)toSetUp:(UIButton *)button{
    SetUpViewController * setUp = [[SetUpViewController alloc] init];
    [self.navigationController pushViewController:setUp animated:YES];
    
}
-(void)toSelect:(UIButton *)button{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
