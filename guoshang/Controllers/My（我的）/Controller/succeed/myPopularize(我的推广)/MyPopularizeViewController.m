//
//  MyPopularizeViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/6/12.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyPopularizeViewController.h"
#import "CurrentIphone.h"
#import "PopularizeViewController.h"
#import "PopularizePlanViewController.h"
@interface MyPopularizeViewController ()
{
    UITableView * _sv;
    NSMutableDictionary * _dataDic;
}
@end

@implementation MyPopularizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createData];
    [self addUI];
}

-(void)createData{
    
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
        //http://192.168.1.168/Apis/index.php?m=Api&c=User&a=user_share&user_id=112159
        NSString *url = [NSString stringWithFormat:@"?m=Api&c=User&a=user_share&user_id=%@",UserId];
        NSString *dependURL = URLDependByBaseURL(url);
        
       [HttpTool POST:dependURL parameters:nil success:^(id responseObject) {
           
           if ([responseObject[@"status"] isEqualToNumber:@1]) {
               
               _dataDic = responseObject[@"result"];
               
               
               [self addUI];
           }
           
           
       } failure:^(NSError *error) {
         
           
       }];
    }
   
}


-(void)addUI{
  
        NSString *  version = [CurrentIphone deviceVersion];
//    NSLog(@"WWWW%@",version);
    _sv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
    _sv.separatorStyle = UITableViewCellSeparatorStyleNone;
        _sv.backgroundColor = MyColor;
    _sv.pagingEnabled = YES;
        if ([version isEqualToString:@"iPhone 6 Plus"] || [version isEqualToString:@"iPhone 6 sPlus"]) {
            
            _sv.contentSize = CGSizeMake(Width, Height);
            
            
        }else{
            
            
            _sv.contentSize = CGSizeMake(Width * 2, Height * 2);
            
            
        }
    

        _sv.showsHorizontalScrollIndicator = NO;
    
        _sv.showsVerticalScrollIndicator = NO;
    
        [self.view addSubview:_sv];
  
   
    
    //线
    UIImageView * wire1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
    [_sv addSubview:wire1];
    
    [wire1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_sv.mas_left);
        make.right.equalTo(_sv.mas_right);
        make.top.equalTo(_sv.mas_top).equalTo(@75);
        make.height.equalTo(@1);
    }];
        //我的推广码：877541268CS
    if ( _dataDic.count > 0) {
        LNLabel * myNumber = [LNLabel addLabelWithTitle:[NSString stringWithFormat:@"我的推荐码:%@",_dataDic[@"recommend_code"]] TitleColor:[UIColor blackColor] Font:20.0f BackGroundColor:MyColor];
        [_sv addSubview:myNumber];
        CGSize  myNumberSize = [LNLabel calculateLableSizeWithString:[NSString stringWithFormat:@"我的推荐码:%@",_dataDic[@"recommend_code"]]  AndFont:21.f];
//        NSLog(@"计算宽和高%f %f",myNumberSize.height,myNumberSize.width);
        myNumber.frame = CGRectMake((Width - myNumberSize.width) /2, (75 - myNumberSize.height) / 2, myNumberSize.width, myNumberSize.height);
        
        //线
        UIImageView * wire2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [_sv addSubview:wire2];
        [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(wire1.mas_bottom).equalTo(@10);
            make.height.equalTo(@1);
        }];
        //预计收益（元)
        LNLabel * profitLabel = [LNLabel addLabelWithTitle:@"预计收益（元)" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        [_sv  addSubview:profitLabel];
        
        [profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left).equalTo(@15);
            make.right.equalTo(_sv.mas_right);
            make.top.equalTo(wire2.mas_bottom).equalTo(@20);
            make.height.equalTo(@20);
        }];
        
        //收益的金额
        LNLabel * moneyLabel = [LNLabel addLabelWithTitle:[NSString stringWithFormat:@"%@",_dataDic[@"total_settled"]] TitleColor:[UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0] Font:20.0f BackGroundColor:MyColor];
        CGSize  moneySize = [LNLabel calculateLableSizeWithString:[NSString stringWithFormat:@"%@",_dataDic[@"total_settled"]] AndFont:21.f];
        [_sv addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left).equalTo(@((Width - moneySize.width) / 2));
            make.top.equalTo(profitLabel.mas_bottom).equalTo(@15);
            make.height.equalTo(@(moneySize.height));
        }];
        
        //含待结算收益
        NSString * waitStr = [NSString stringWithFormat:@"含待结算收益，共计%@元",_dataDic[@"wait_settled"]];
        NSInteger count=0;
        NSMutableAttributedString * waitMoneyText = [[NSMutableAttributedString alloc] initWithString:waitStr];
        for (NSInteger i = 0;i < waitStr.length; i++ ) {
            char chr = [waitStr characterAtIndex:i];
            if (chr>= '0' && chr <= '9') {
                
                count++;
            }
        }
        [waitMoneyText beginEditing];
        [waitMoneyText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, waitMoneyText.length)];
        [waitMoneyText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] range:NSMakeRange(0, waitMoneyText.length)];
        [waitMoneyText addAttribute:NSForegroundColorAttributeName value:NewRedColor range:NSMakeRange(waitMoneyText.length - count, count-1)];
        [waitMoneyText endEditing];
        UILabel * waitMoneyLabel =[[UILabel alloc] init];
        [_sv addSubview:waitMoneyLabel];
        waitMoneyLabel.attributedText = waitMoneyText;
        [waitMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left).equalTo(@((Width - [LNLabel calculateLableSizeWithString:waitStr AndFont:16.0f].width) / 2));
            make.top.equalTo(moneyLabel.mas_bottom).equalTo(@5);
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:waitStr AndFont:16.0f].height));
        }];
        
        
        //线
        UIImageView * wire3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [_sv addSubview:wire3];
        [wire3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(waitMoneyLabel.mas_bottom).equalTo(@16);
            make.height.equalTo(@1);
        }];
        
        
        //方块的布局
        //线
        UIImageView * wire4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [_sv addSubview:wire4];
        [wire4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(wire3.mas_bottom).equalTo(@10);
            make.height.equalTo(@1);
        }];
        
        //线
        UIImageView * wire5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [_sv addSubview:wire5];
        [wire5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(wire4.mas_bottom).equalTo(@75);
            make.height.equalTo(@1);
        }];
        
        //线
        UIImageView * wire6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [_sv addSubview:wire6];
        [wire6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(wire5.mas_bottom).equalTo(@75);
            make.height.equalTo(@1);
            
        }];
        
        //竖线
        UIImageView * wire7 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [_sv addSubview:wire7];
        [wire7 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left).equalTo(@((Width - 1) / 2));
            make.width.equalTo(@1);
            make.top.equalTo(wire4.mas_bottom);
            make.height.equalTo(@150);
            
        }];
        
        
        //累计推广
        UIImageView * proIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pro"]];
        [_sv addSubview:proIcon];
        [proIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wire7.mas_left).equalTo(@(-22.5));
            make.width.equalTo(@22);
            make.bottom.equalTo(wire5.mas_bottom).equalTo(@(-17.5));
            make.height.equalTo(@28);
        }];
        LNLabel * prolabel = [LNLabel addLabelWithTitle:@"累计推广订单" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        [_sv addSubview:prolabel];
        [prolabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(proIcon.mas_left).equalTo(@(-10));
            make.bottom.equalTo(wire5.mas_bottom).equalTo(@(-15));
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:@"累计推广订单" AndFont:16.0f].height));
            make.width.equalTo(@([LNLabel calculateLableSizeWithString:@"累计推广订单" AndFont:16.0f].width));
        }];
        NSString * proMaoneyStr = [NSString stringWithFormat:@"%@笔",_dataDic[@"order_num"]];
        NSMutableAttributedString * proMoneyText = [[NSMutableAttributedString alloc] initWithString:proMaoneyStr];
        [proMoneyText beginEditing];
        [proMoneyText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, proMoneyText.length -1)];
        [proMoneyText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(proMoneyText.length -1, 1)];
        [proMoneyText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:207/255.0 blue:124/255.0 alpha:1.0] range:NSMakeRange(0, proMoneyText.length -1)];
        [proMoneyText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] range:NSMakeRange(proMoneyText.length -1, 1)];
        [proMoneyText endEditing];
        UILabel * proMoneyLabel =[[UILabel alloc] init];
        [_sv addSubview:proMoneyLabel];
        proMoneyLabel.attributedText = proMoneyText;
        [proMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(prolabel.mas_right).equalTo(@((prolabel.frame.size.width - [LNLabel calculateLableSizeWithString:proMaoneyStr AndFont:20.0f].width) / 2));
            make.bottom.equalTo(prolabel.mas_top).equalTo(@(-3));
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:proMaoneyStr AndFont:20.0f].height));
        }];
        
        //累计付款
        
        UIImageView * payIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay"]];
        [_sv addSubview:payIcon];
        [payIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wire7.mas_left).equalTo(@(22.5));
            make.width.equalTo(@28);
            make.bottom.equalTo(wire5.mas_bottom).equalTo(@(-17.5));
            make.height.equalTo(@28);
        }];
        LNLabel * paylabel = [LNLabel addLabelWithTitle:@"累计付款金额" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        [_sv addSubview:paylabel];
        [paylabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(payIcon.mas_right).equalTo(@(10));
            make.bottom.equalTo(wire5.mas_bottom).equalTo(@(-15));
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:@"累计付款金额" AndFont:16.0f].height));
            make.width.equalTo(@([LNLabel calculateLableSizeWithString:@"累计推广金额" AndFont:16.0f].width));
        }];
        NSString * payMoneyStr = [NSString stringWithFormat:@"%@元",_dataDic[@"price"]];
        NSMutableAttributedString * payMoneyText = [[NSMutableAttributedString alloc] initWithString:payMoneyStr];
        [payMoneyText beginEditing];
        [payMoneyText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, payMoneyText.length -1)];
        [payMoneyText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(payMoneyText.length -1, 1)];
        [payMoneyText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255/255.0 green:124/255.0 blue:124/255.0 alpha:1.0] range:NSMakeRange(0, payMoneyText.length -1)];
        [payMoneyText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] range:NSMakeRange(payMoneyText.length -1, 1)];
        [payMoneyText endEditing];
        UILabel * payMoneyLabel =[[UILabel alloc] init];
        [_sv addSubview:payMoneyLabel];
        payMoneyLabel.attributedText = payMoneyText;
        prolabel.textAlignment = NSTextAlignmentCenter;
        [payMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(paylabel.mas_left);
            make.width.equalTo(paylabel.mas_width);
            make.bottom.equalTo(paylabel.mas_top).equalTo(@(-3));
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:payMoneyStr AndFont:20.0f].height));
        }];
        
        //本月新增用户
        
        UIImageView * addIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"meber"]];
        [_sv addSubview:addIcon];
        [addIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(wire7.mas_left).equalTo(@(-22.5));
            make.width.equalTo(@28);
            make.bottom.equalTo(wire6.mas_bottom).equalTo(@(-17.5));
            make.height.equalTo(@28);
        }];
        LNLabel * addlabel = [LNLabel addLabelWithTitle:@"本月新增客户" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        [_sv addSubview:addlabel];
        [addlabel  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(addIcon.mas_left).equalTo(@(-10));
            make.bottom.equalTo(wire6.mas_bottom).equalTo(@(-15));
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:@"本月新增客户" AndFont:16.0f].height));
            make.width.equalTo(@([LNLabel calculateLableSizeWithString:@"本月新增客户" AndFont:16.0f].width));
        }];
        
        NSString * addStr = [NSString stringWithFormat:@"%@位",_dataDic[@"m_spread_total"]];
        NSMutableAttributedString * addText = [[NSMutableAttributedString alloc] initWithString:addStr];
        [addText  beginEditing];
        [addText  addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, addText .length -1)];
        [addText  addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(addText.length -1, 1)];
        [addText  addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:124/255.0 green:186/255.0 blue:255/255.0 alpha:1.0] range:NSMakeRange(0, addText.length -1)];
        [addText  addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] range:NSMakeRange(addText.length -1, 1)];
        [addText  endEditing];
        UILabel * addLabel =[[UILabel alloc] init];
        [_sv addSubview:addLabel];
        addLabel.attributedText = addText;
        [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(addlabel.mas_right).equalTo(@((addlabel.frame.size.width - [LNLabel calculateLableSizeWithString:addStr AndFont:20.0f].width) / 2));
            make.bottom.equalTo(addlabel.mas_top).equalTo(@(-3));
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:addStr AndFont:20.0f].height));
        }];
        
        //累计推广客户
        UIImageView * toProIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"T4"]];
        [_sv addSubview:toProIcon ];
        [toProIcon  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(wire7.mas_left).equalTo(@(22.5));
            make.width.equalTo(@28);
            make.bottom.equalTo(wire6.mas_bottom).equalTo(@(-17.5));
            make.height.equalTo(@28);
        }];
        
      
        LNLabel * toProlabel = [LNLabel addLabelWithTitle:@"累计推广用户" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        [_sv addSubview:toProlabel];
        [toProlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(toProIcon.mas_right).equalTo(@(10));
            make.bottom.equalTo(wire6.mas_bottom).equalTo(@(-15));
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:@"累计推广用户" AndFont:16.0f].height));
            make.width.equalTo(@([LNLabel calculateLableSizeWithString:@"累计推广用户" AndFont:16.0f].width));
        }];
        
           NSString * toAddStr = [NSString stringWithFormat:@"%@位",_dataDic[@"spread_total"]];
        NSMutableAttributedString * toProText = [[NSMutableAttributedString alloc] initWithString:toAddStr];
        [toProText beginEditing];
        [toProText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20.0f] range:NSMakeRange(0, toProText.length -1)];
        [toProText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(toProText.length -1, 1)];
        [toProText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:243/255.0 green:158/255.0 blue:58/255.0 alpha:1.0] range:NSMakeRange(0,  toProText.length -1)];
        [toProText addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] range:NSMakeRange(toProText.length -1, 1)];
        [toProText endEditing];
        UILabel * toProLabel =[[UILabel alloc] init];
        [_sv addSubview:toProLabel];
        toProLabel.attributedText = toProText;
        toProlabel.textAlignment = NSTextAlignmentCenter;
        [toProLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(toProlabel.mas_left);
            make.width.equalTo(toProlabel.mas_width);
            make.bottom.equalTo(toProlabel.mas_top).equalTo(@(-3));
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:@"369.23元" AndFont:20.0f].height));
        }];
        
        //线
        UIImageView * wire8 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [_sv addSubview:wire8];
        [wire8 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(wire6.mas_bottom).equalTo(@10);
            make.height.equalTo(@1);
        }];
        
        //查看全部推广计划
        UIButton * seePlan = [UIButton buttonWithType:UIButtonTypeSystem];
        seePlan.backgroundColor =MyColor;
        [seePlan addTarget:self action:@selector(toSeePlan:) forControlEvents:UIControlEventTouchUpInside];
        [_sv addSubview:seePlan];
        seePlan.tag = 101011;
        [seePlan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(wire8.mas_bottom);
            make.height.equalTo(@50);
        }];
        
        
        
        UIImageView * seePlanIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"T5"]];
        [seePlan addSubview:seePlanIcon];
        [seePlanIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(seePlan.mas_left).equalTo(@(15));
            make.width.equalTo(@28.5);
            make.top.equalTo(seePlan.mas_top).equalTo(@(15));
            make.height.equalTo(@20);
        }];
        
        
        
        LNLabel * seePlanLabel = [LNLabel addLabelWithTitle:@"查看推广计划" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        [seePlan addSubview:seePlanLabel];
        [seePlanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(seePlanIcon.mas_right).equalTo(@(10));
            make.top.equalTo(seePlanIcon.mas_top);
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:@"查看推广计划" AndFont:16.0f].height));
            make.width.equalTo(@([LNLabel calculateLableSizeWithString:@"查看推广计划" AndFont:16.0f].width));
        }];
        
        
        UIImageView * moreIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gengduo2"]];
        [seePlan addSubview:moreIcon ];
        [moreIcon  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(seePlan.mas_right).equalTo(@(-17.5));
            make.width.equalTo(@10);
            make.top.equalTo(seePlan.mas_top).equalTo(@(20));
            make.height.equalTo(@10);
        }];
        
        
        //线
        UIImageView * wire9 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [_sv addSubview:wire9];
        [wire9 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(wire8.mas_bottom).equalTo(@50);
            make.height.equalTo(@1);
        }];
        
        
        UIButton * toPopuBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        toPopuBtn.backgroundColor =[UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1.0];
        toPopuBtn.layer.cornerRadius = 15;
        toPopuBtn.clipsToBounds = YES;
        toPopuBtn.layer.borderColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0].CGColor;
        toPopuBtn.tag = 101010;
        [toPopuBtn setTintColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0]];
        [toPopuBtn setTitle:@"我要推广" forState:UIControlStateNormal];
        toPopuBtn.layer.borderWidth = 0.8;
        [toPopuBtn  addTarget:self action:@selector(toSeePlan:) forControlEvents:UIControlEventTouchUpInside];
        [_sv addSubview:toPopuBtn ];
        [toPopuBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_sv.mas_left).offset(70);
            make.right.equalTo(self.view.mas_right).offset(-70);
            make.top.equalTo(wire9.mas_bottom).offset(30);
            make.height.equalTo(@50);
        }];
        

    }
    
    
}
    
-(void)toSeePlan:(UIButton *)button{
    if (button.tag == 101011) {
        //查看推广计划
        [self.navigationController pushViewController:[[PopularizePlanViewController alloc] init] animated:YES];
    }else{
        //调到推广页面
        PopularizeViewController * pop = [[PopularizeViewController alloc] init];
        if (_dataDic.count> 0) {
            
            pop.dataDic = _dataDic;
        }
        [self.navigationController pushViewController:pop  animated:YES];

    }
    
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
