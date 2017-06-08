//
//  SLFRechargeViewController.m
//  guoshang
//
//  Created by 时礼法 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SLFRechargeViewController.h"
#import "SLFRechargeHeaderView.h"
#import "SLFRechargeMView.h"
#import "SLFBuyRecord.h"
#import "SLFRechageDetailView.h"
#import "SLFAccountSafe.h"
#import "SLFBindingCard.h"
#import "AlertTool.h"
#import "SLFRechargeModle.h"
#import "SLFAcountSafeReset.h"
#import "SLFBuyRecordModel.h"
#import "SLFRechargeDetail.h"
#import "SVProgressHUD.h"
#import "SLFChargeMViewController.h"
#import "SLFGiftView.h"


@interface SLFRechargeViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) UITableView *tabelView;
@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,assign) int page;


@end

@implementation SLFRechargeViewController
{
    SLFRechargeHeaderView *_HView;
    UIImageView *_imageV;
    UIButton *_recharge;
    UIButton *_Rdetail;
    UIButton *_BuyRecord;
    UIButton *_accountSafe;
    UIButton *_bindeCard;
    UILabel *_markLable;
    UIView *_backView;
    UIScrollView *_scrollView;
    UILabel *lableEnd;
    NSMutableArray *_headerArr;
    NSString *payStr;
    UIScrollView *_ButtonscrollView;
    UILabel *_tipL;
    UIButton *_giftButton;
    UILabel *lable;
    
    //支付宝参数相关
    NSString *ali_pay_order_sn;
    NSString *notify_url;
    NSString *pay_order_sn;
    
   
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self creatHeaderData];
    
    NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
    
    //添加观察者 Observer表示观察者  reciveNotice:表示接收到的消息  name表示再通知中心注册的通知名  object表示可以相应的对象 为nil的话表示所有对象都可以相应
    [center addObserver:self selector:@selector(reciveBuyRecord:) name:@"buyRecord" object:nil];
    if (self.type == 3) {
        [self BuyRecordClicked:_BuyRecord];
    }
    
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _scrollView  = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(Width, Height + 200);
    [self.view addSubview:_scrollView];
    
    self.page = 1;
    
    self.title = @"我的充值卡";
    [self addHeaderUI];
//    [self addLongImageView];
    [self addFounctionButton];
    [self creatHeaderData];
    [self creatRefresh];
}

-(void)addHeaderUI
{
    self.view.backgroundColor = MyColor;
    _HView = [[SLFRechargeHeaderView alloc] initWithFrame:CGRectMake(0, 0,Width, 150)];
    if (self.tap == 1) {
        _HView.tap = 1;
    }else
    {
        _HView.tap = 2;
    }
    
    [_scrollView addSubview:_HView];
}

-(void)addLongImageView
{
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _HView.endPointY + 7, Width, 50)];
    _imageV.image = [UIImage imageNamed:@"图层5"];
    [_scrollView addSubview:_imageV];
}

-(void)addFounctionButton
{
    
    lable = [[UILabel alloc] initWithFrame:CGRectMake(0, _HView.endPointY + 7, Width, 0.5)];
    lable.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:lable];
    
    _ButtonscrollView  = [[UIScrollView alloc] initWithFrame:CGRectMake(0, lable.endPointY + 5, Width, 32)];
    _ButtonscrollView.delegate = self;
    _ButtonscrollView.showsVerticalScrollIndicator = NO;
    _ButtonscrollView.showsHorizontalScrollIndicator = NO;
    _ButtonscrollView.contentSize = CGSizeMake((Width/5)*6,30);
    
    
    _recharge = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, Width/5, 30)];
    [_recharge setTitle:@"一键充值" forState:UIControlStateNormal];
    _recharge.tag = 11;
    _recharge.selected = YES;
    [_recharge setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recharge setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _recharge.titleLabel.font = [UIFont systemFontOfSize:12];
    [_recharge addTarget:self action:@selector(rechargeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonscrollView addSubview:_recharge];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(_recharge.endPointX,0, 0.5, 20)];
    lable1.backgroundColor = [UIColor blackColor];
    [_ButtonscrollView addSubview:lable1];
    
    _Rdetail = [[UIButton alloc] initWithFrame:CGRectMake(lable1.endPointX, 0, Width/5 - 0.5, 30)];
    _Rdetail.tag = 12;
    [_Rdetail setTitle:@"消费明细" forState:UIControlStateNormal];
    [_Rdetail setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_Rdetail setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _Rdetail.titleLabel.font = [UIFont systemFontOfSize:12];
    [_Rdetail addTarget:self action:@selector(RdetailClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonscrollView addSubview:_Rdetail];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(_Rdetail.endPointX, 5, 0.5, 20)];
    lable2.backgroundColor = [UIColor blackColor];
    [_ButtonscrollView addSubview:lable2];
    
    _BuyRecord = [[UIButton alloc] initWithFrame:CGRectMake(lable2.endPointX, 0, Width/5 - 0.5, 30)];
    _BuyRecord.tag = 13;
    [_BuyRecord setTitle:@"充值记录" forState:UIControlStateNormal];
    [_BuyRecord setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_BuyRecord setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _BuyRecord.titleLabel.font = [UIFont systemFontOfSize:12];
    [_BuyRecord addTarget:self action:@selector(BuyRecordClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonscrollView addSubview:_BuyRecord];
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(_BuyRecord.endPointX, 5, 0.5, 20)];
    lable3.backgroundColor = [UIColor blackColor];
    [_ButtonscrollView addSubview:lable3];
    
    _accountSafe = [[UIButton alloc] initWithFrame:CGRectMake(lable3.endPointX, 0, Width/5 - 0.5, 30)];
    _accountSafe.tag = 14;
    [_accountSafe setTitle:@"账户安全" forState:UIControlStateNormal];
    [_accountSafe setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_accountSafe setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _accountSafe.titleLabel.font = [UIFont systemFontOfSize:12];
    [_accountSafe addTarget:self action:@selector(accountSafeClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonscrollView addSubview:_accountSafe];
    
    UILabel *lable4 = [[UILabel alloc] initWithFrame:CGRectMake(_accountSafe.endPointX, 5, 0.5, 20)];
    lable4.backgroundColor = [UIColor blackColor];
    [_ButtonscrollView addSubview:lable4];
    
    _bindeCard = [[UIButton alloc] initWithFrame:CGRectMake(lable4.endPointX, 0, Width/5 - 0.5, 30)];
    _bindeCard.tag = 15;
    [_bindeCard setTitle:@"实体卡兑换" forState:UIControlStateNormal];
    [_bindeCard setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_bindeCard setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _bindeCard.titleLabel.font = [UIFont systemFontOfSize:12];
    [_bindeCard addTarget:self action:@selector(bindeCardClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonscrollView addSubview:_bindeCard];
    
    UILabel *lable5 = [[UILabel alloc] initWithFrame:CGRectMake(_bindeCard.endPointX, 5, 0.5, 20)];
    lable5.backgroundColor = [UIColor blackColor];
    [_ButtonscrollView addSubview:lable5];
    
    _giftButton = [[UIButton alloc] initWithFrame:CGRectMake(lable5.endPointX, 0, Width/5 - 0.5, 30)];
    _giftButton.tag = 16;
    [_giftButton setTitle:@"礼品兑换" forState:UIControlStateNormal];
    [_giftButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_giftButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    _giftButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [_giftButton addTarget:self action:@selector(giftCardClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_ButtonscrollView addSubview:_giftButton];
    
    lableEnd = [[UILabel alloc] initWithFrame:CGRectMake(0, _ButtonscrollView.endPointY, Width, 0.5)];
    lableEnd.backgroundColor = [UIColor blackColor];
    [_scrollView addSubview:lableEnd];
    
    _markLable = [[UILabel alloc] initWithFrame:CGRectMake(0, _bindeCard.endPointY + 1, Width/5, 1)];
    _markLable.backgroundColor = [UIColor redColor];
    [_ButtonscrollView addSubview:_markLable];
    
    [_scrollView addSubview:_ButtonscrollView];
    _backView = [[UIView alloc] initWithFrame:CGRectMake(0, lableEnd.endPointY + 3, Width, Height)];
    [_scrollView addSubview:_backView];
    
   
    SLFRechargeMView *RMView = [[SLFRechargeMView alloc] initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height)];
    RMView.popView = self;
    [_backView addSubview:RMView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark ======================== 当button被点击的时候 ================
-(void)rechargeClicked:(UIButton *)button
{
    button.selected = YES;
    _BuyRecord.selected = NO;
    _Rdetail.selected = NO;
    _bindeCard.selected = NO;
    _accountSafe.selected = NO;
    _giftButton.selected = NO;
    _scrollView.contentSize = CGSizeMake(Width, Height + 200);
    
    [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    SLFRechargeMView *RMView = [[SLFRechargeMView alloc] initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height)];
    RMView.popView = self;
    [_backView addSubview:RMView];

    [UIView animateWithDuration:0.5 animations:^{
         _markLable.frame = CGRectMake(0,_bindeCard.endPointY + 1, Width/5, 1);
    }];
    
}

-(void)RdetailClicked:(UIButton *)button
{
    self.page = 1;
    button.selected = YES;
    _recharge.selected = NO;
    _bindeCard.selected = NO;
    _BuyRecord.selected = NO;
    _accountSafe.selected = NO;
    _giftButton.selected = NO;
    _scrollView.contentSize = CGSizeMake(Width, Height);
    
    [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self reloadRechargeDetail];
    
    [UIView animateWithDuration:0.5 animations:^{
        _markLable.frame = CGRectMake((Width/5), _bindeCard.endPointY + 1, Width/5, 1);
    }];
}

-(void)BuyRecordClicked:(UIButton *)button
{
    self.page = 1;
    _recharge.selected = NO;
    _Rdetail.selected = NO;
    _bindeCard.selected = NO;
    _accountSafe.selected = NO;
    _giftButton.selected = NO;
     button.selected = YES;
     _scrollView.contentSize = CGSizeMake(Width, Height);
//    [_ButtonscrollView setContentOffset:CGPointMake(Width/5, lable.endPointY + 5)];
    [self loadRecordData];
    
   [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [UIView animateWithDuration:0.5 animations:^{
         _markLable.frame = CGRectMake((Width/5) *2, _bindeCard.endPointY + 1, Width/5, 1);
    }];
}


-(void)accountSafeClicked:(UIButton *)button
{
     button.selected = YES;
    _BuyRecord.selected = NO;
    _Rdetail.selected = NO;
    _bindeCard.selected = NO;
    _recharge.selected = NO;
    _giftButton.selected = NO;
    _scrollView.contentSize = CGSizeMake(Width, Height + 200);
    
    [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
   
    
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]];
    encryptString = [userId encryptStringWithKey:KEY];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在请求数据"];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/GetPasswordTag") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"result"] isEqualToString:@"1"]) {
            [UIView animateWithDuration:0.3 animations:^{
                
            } completion:^(BOOL finished) {
                _markLable.frame = CGRectMake((Width/5) *3,_bindeCard.endPointY + 1 , Width/5, 1);
            }];
            //去修改支付密码
            SLFAcountSafeReset *ASViewR = [[SLFAcountSafeReset alloc] initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height)];
            ASViewR.VC = self;
            [_backView addSubview:ASViewR];
        }else
        {
            SLFAccountSafe *ASView = [[SLFAccountSafe alloc] initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height)];
            __weak SLFRechargeViewController *weakSelf = self;
            ASView.ReUIblock = ^(void)
            {
                [weakSelf accountSafeClicked:_accountSafe];
            
            };
            ASView.VC = self;
            [_backView addSubview:ASView];
            
            [UIView animateWithDuration:0.5 animations:^{
                _markLable.frame = CGRectMake((Width/5) *3, _bindeCard.endPointY + 1, Width/5, 1);
            }];
        }
       
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}



-(void)bindeCardClicked:(UIButton *)button
{
     button.selected = YES;
    _BuyRecord.selected = NO;
    _Rdetail.selected = NO;
    _recharge.selected = NO;
    _accountSafe.selected = NO;
    _giftButton.selected = NO;
    _scrollView.contentSize = CGSizeMake(Width, Height + 200);
    
    [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    SLFBindingCard *BCView = [[SLFBindingCard alloc] initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height)];
    BCView.VC = self;
    __weak SLFRechargeViewController *weakSelf = self;
    BCView.ReloadBlock =
    ^(void)
    {
        [_HView removeFromSuperview];
        [weakSelf creatHeaderData];
    };
    [_backView addSubview:BCView];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        _markLable.frame = CGRectMake((Width/5) *4, _bindeCard.endPointY + 1, Width/5, 1);
    }];
    
}

-(void)giftCardClicked:(UIButton *)button
{
    button.selected = YES;
    _BuyRecord.selected = NO;
    _Rdetail.selected = NO;
    _recharge.selected = NO;
    _accountSafe.selected = NO;
    _bindeCard.selected = NO;
    _scrollView.contentSize = CGSizeMake(Width, Height + 200);
    
    [_backView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    SLFGiftView *GFView = [[SLFGiftView alloc] initWithFrame:CGRectMake(0, 0, Width, self.view.frame.size.height)];
    GFView.popView = self;
    [_backView addSubview:GFView];
    
    [UIView animateWithDuration:0.5 animations:^{
        _markLable.frame = CGRectMake(Width, _bindeCard.endPointY + 1, Width/5, 1);
    }];

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_Rdetail.selected == YES) {
      
        
        SLFRechargeDetail *model = self.dataSource[indexPath.section];
        SLFRechageDetailView *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFRechageDetailView"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.name.text = model.change_time;
        cell.nameLable.text = @"操作时间";
        
        cell.Money.text = model.amount;
        cell.MoneyL.text = @"金额";
        
        if ([model.change_type isEqualToString:@"0"]) {
            cell.Type.text = @"充值";
        }else if ([model.change_type isEqualToString:@"1"])
        {
            cell.Type.text = @"体现";
        }else if ([model.change_type isEqualToString:@"2"])
        {
            cell.Type.text = @"管理员调节";
            
        }else
        {
            cell.Type.text = @"其他类型";
        }
        
        
        cell.TypeL.text = @"类型";
        
        cell.Remark.text = model.short_change_desc;
        cell.RemarkL.text = @"备注";
        
        return cell;
    }else if (_BuyRecord.selected == YES)
    {
        
        
        SLFBuyRecordModel *model = self.dataSource[indexPath.section];
        SLFBuyRecord *cell = [tableView dequeueReusableCellWithIdentifier:@"SLFBuyRecord"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.cancell.layer.cornerRadius = 12;
        cell.cancell.layer.masksToBounds = YES;
        [cell.cancell addTarget:self action:@selector(cancell:) forControlEvents:UIControlEventTouchUpInside];
        [cell.cancell setBackgroundColor:[UIColor grayColor]];
        
        cell.Sure.layer.cornerRadius = 12;
        cell.Sure.layer.masksToBounds = YES;
        [cell.Sure addTarget:self action:@selector(Sure:) forControlEvents:UIControlEventTouchUpInside];
        [cell.Sure setBackgroundColor:[UIColor redColor]];
        cell.Sure.tag = indexPath.section;
        cell.cancell.tag = indexPath.section;
        cell.popView = self;
        
        cell.OpTime.text = model.add_time;
        cell.OpTimeL.text = @"操作时间";
        
        cell.Money.text = model.amount;
        cell.MoneyL.text = @"金额";
        
        if (model.user_note.length == 0) {
            cell.Remark.text = @"无";
        }else
        {
          cell.Remark.text = model.user_note;
        }
        cell.RemarkL.text = @"会员备注";
        
        cell.Mmark.text = model.admin_note;
        cell.MRemarkL.text = @"管理员备注";
        
        if ([model.is_paid isEqualToString:@"0"]) {
            cell.Status.text = @"未付款";
            cell.Sure.hidden = NO;
            cell.cancell.hidden = NO;
        }else if ([model.is_paid isEqualToString:@"1"])
        {
            cell.Status.text = @"付款";
            cell.Sure.hidden = YES;
            cell.cancell.hidden = YES;
        }
        
        cell.StatusL.text = @"状态";
        
        return cell;
    }
    return 0;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_Rdetail.selected == YES) {
    return 110;
    }else
    {
        return 170;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

//当cell上的button被点击的时候
-(void)Sure:(UIButton *)button
{
        SLFBuyRecordModel *model = self.dataSource[button.tag];
    
        SLFChargeMViewController *Money = [[SLFChargeMViewController alloc] init];
        Money.writeView = [NSString stringWithFormat:@"%@",model.user_note];
        Money.Money = [NSString stringWithFormat:@"%@",model.amount_org];
        Money.ali_pay_order_sn = model.ali_pay_order_sn;
        Money.notify_url = model.notify_url;
        Money.pay_order_sn = model.pay_order_sn;
        
        [self.navigationController pushViewController:Money animated:YES];
        
   
}

-(void)cancell:(UIButton *)button
{
    [AlertTool alertTitle:@"提示" mesasge:@"确定取消充值吗？" preferredStyle:UIAlertControllerStyleActionSheet confirmHandler:^(UIAlertAction *action) {
        
        SLFBuyRecordModel *model = self.dataSource[button.tag];
        NSString *  encryptString;
        NSString * userId = [NSString stringWithFormat:@"user_id=%@,recharge_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],[NSString stringWithFormat:@"%@",model.ID]];
        encryptString = [userId encryptStringWithKey:KEY];
        
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        [SVProgressHUD showWithStatus:@"正在请求数据"];
        [HttpTool POST:URLDependByBaseURL(@"/Api/User/CancelRechargeCardBuy") parameters:@{@"token":encryptString} success:^(id responseObject) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:responseObject[@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            
            [SVProgressHUD dismiss];
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
        }];
        
        [self.dataSource removeObject:model];
        
        [self.tabelView reloadData];
        
    } cancleHandler:^(UIAlertAction *action) {
        
        
        
    } viewController:self];
    
    
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ======================= 数据请求部分 =============================
-(void)creatHeaderData
{
    
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]];
    encryptString = [userId encryptStringWithKey:KEY];
    _HView = [[SLFRechargeHeaderView alloc] initWithFrame:CGRectMake(0, 0,Width, 150)];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/GetAllMoney") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        _HView.CRBalance = responseObject[@"result"][@"pay_points"];
        
        SLFRechargeModle *model = [[SLFRechargeModle alloc] initWithDictionary:responseObject[@"result"] error:nil];
        _headerArr = [[NSMutableArray alloc] init];
        [_headerArr addObject:model];
        _HView.headerArr = _headerArr;
        [_scrollView addSubview:_HView];
    } failure:^(NSError *error) {
        
    }];
}

-(void)loadRecordData
{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在请求数据"];
    int i = self.page * 5;
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,page=1,page_size=%d",UserId,i];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/ChargeCardDetails") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        [weakSelf.dataSource removeAllObjects];
        [_tipL removeFromSuperview];
        for (NSDictionary *dict in responseObject[@"result"]) {
            
            SLFBuyRecordModel *model = [[SLFBuyRecordModel alloc] initWithDictionary:dict error:nil];
            
            [weakSelf.dataSource addObject:model];
        }
        
        if (weakSelf.dataSource.count == 0) {
            _tipL = [[UILabel alloc] initWithFrame:CGRectMake(0,100, Width, 30)];
            _tipL.text = @"暂时没有数据";
            _tipL.textAlignment = NSTextAlignmentCenter;
            _tipL.font = [UIFont systemFontOfSize:13];
            [_tabelView addSubview:_tipL];
        }

        [_backView addSubview:weakSelf.tabelView];
        [weakSelf.tabelView reloadData];
        
        [weakSelf.tabelView.mj_header endRefreshing];
        [weakSelf.tabelView.mj_footer endRefreshing];
        
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

-(void)reloadRechargeDetail
{
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:@"正在请求数据"];
    int i = self.page * 5;
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,page=1,page_size=%d",UserId,i];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/ChargeCardBuyLog") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        [weakSelf.dataSource removeAllObjects];
        [_tipL removeFromSuperview];
        for (NSDictionary *dict in responseObject[@"result"]) {
            SLFRechargeDetail *model = [[SLFRechargeDetail alloc] initWithDictionary:dict error:nil];
            
            [weakSelf.dataSource addObject:model];
        }
        
        if (weakSelf.dataSource.count == 0) {
            _tipL = [[UILabel alloc] initWithFrame:CGRectMake(0,100, Width, 30)];
            _tipL.text = @"暂时没有数据";
            _tipL.textAlignment = NSTextAlignmentCenter;
            _tipL.font = [UIFont systemFontOfSize:13];
            [_tabelView addSubview:_tipL];
        }
        
        [_backView addSubview:weakSelf.tabelView];
        [weakSelf.tabelView reloadData];
        
        [weakSelf.tabelView.mj_header endRefreshing];
        [weakSelf.tabelView.mj_footer endRefreshing];
        [SVProgressHUD dismiss];
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
}

#pragma mark ===================== 懒加载 ======================
-(UITableView *)tabelView
{
    if (_tabelView == nil) {
        _tabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - lableEnd.endPointY - 44) style:UITableViewStyleGrouped];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        [_tabelView registerNib:[UINib nibWithNibName:@"SLFRechageDetailView" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFRechageDetailView"];
        
        [_tabelView registerNib:[UINib nibWithNibName:@"SLFBuyRecord" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SLFBuyRecord"];
    }
    return _tabelView;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

#pragma mark =============== 下拉刷新上拉加载 =============
-(void)creatRefresh{
    // 下拉刷新
    self.tabelView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self pullRefresh];
    }];
    
    // 上拉加载
    self.tabelView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self pushRefresh];
    }];
    

}

-(void)pullRefresh{
    
    self.page = 1;
        
    if (_Rdetail.selected == YES) {
        [self reloadRechargeDetail];
    }else if (_BuyRecord.selected == YES)
    {
     [self loadRecordData];
    }
    
    
    
    
}
-(void)pushRefresh{
    self.page++;
    if (_Rdetail.selected == YES) {
        [self reloadRechargeDetail];
    }else if (_BuyRecord.selected == YES)
    {
        [self loadRecordData];
    }
    
}

- (void)reciveBuyRecord:(NSNotification *)notification{
    
    self.type = [[notification.userInfo objectForKey:@"text"] integerValue];
}


@end
