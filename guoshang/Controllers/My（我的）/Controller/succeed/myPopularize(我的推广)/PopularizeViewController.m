//
//  PopularizeViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/6/14.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "PopularizeViewController.h"
#import "UMSocial.h"
@interface PopularizeViewController ()<UMSocialUIDelegate>

@end

@implementation PopularizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    self.title = @"我的推广";
    [self createUI];
}
-(void)createUI{
    if (_dataDic.count > 0) {
        //预计收益（元)
        LNLabel * profitLabel = [LNLabel addLabelWithTitle:@"我的预计收益（元)" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        [self.view  addSubview:profitLabel];
        __weak typeof(self) weakSelf = self;
        [profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).equalTo(@15);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(weakSelf.view.mas_top).equalTo(@20);
            make.height.equalTo(@20);
        }];
        
        //收益的金额
        NSString * moneyStr = [NSString stringWithFormat:@"%@",_dataDic[@"total_settled"]];
        LNLabel * moneyLabel = [LNLabel addLabelWithTitle:moneyStr TitleColor:[UIColor colorWithRed:231/255.0 green:55/255.0 blue:54/255.0 alpha:1.0] Font:20.0f BackGroundColor:MyColor];
        CGSize  moneySize = [LNLabel calculateLableSizeWithString:moneyStr AndFont:21.f];
        [self.view addSubview:moneyLabel];
        [moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).equalTo(@((Width - moneySize.width) / 2));
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
        [waitMoneyText addAttribute:NSForegroundColorAttributeName value:NewRedColor range:NSMakeRange(waitMoneyText.length - count, count-1)];    [waitMoneyText endEditing];
        UILabel * waitMoneyLabel =[[UILabel alloc] init];
        [self.view addSubview:waitMoneyLabel];
        waitMoneyLabel.attributedText = waitMoneyText;
        [waitMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).equalTo(@((Width - [LNLabel calculateLableSizeWithString:waitStr AndFont:16.0f].width) / 2));
            make.top.equalTo(moneyLabel.mas_bottom).equalTo(@5);
            make.height.equalTo(@([LNLabel calculateLableSizeWithString:waitStr AndFont:16.0f].height));
        }];

        //线
        UIImageView * wire1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [self.view addSubview:wire1];
        [wire1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(waitMoneyLabel.mas_bottom).equalTo(@16);
            make.height.equalTo(@1);
        }];
        
        
        UIImageView * wire2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [self.view addSubview:wire2];
        [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(wire1.mas_bottom).equalTo(@10);
            make.height.equalTo(@1);
        }];
        
        
        UIImageView * wire3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [self.view addSubview:wire3];
        [wire3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(wire2.mas_bottom).equalTo(@40);
            make.height.equalTo(@1);
        }];
        
        
        //查看全部推广计划
        UIButton * shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        shareBtn.backgroundColor =MyColor;
        [shareBtn addTarget:self action:@selector(toPopularize:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareBtn];
        [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(wire2.mas_bottom);
            make.height.equalTo(@40);
        }];
        
        
        LNLabel * shareLabel = [LNLabel addLabelWithTitle:@"去分享" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        CGSize shareLabelSize = [LNLabel calculateLableSizeWithString:@"去分享" AndFont:16.f];
        [shareBtn addSubview:shareLabel];
        [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(shareBtn.mas_left).equalTo(@(15));
            make.top.equalTo(shareBtn.mas_top).equalTo(@10);
            make.height.equalTo(@(shareLabelSize.height));
        }];
        
        
        
        UIImageView * shareIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gengduo2"]];
        [shareBtn addSubview:shareIcon ];
        [shareIcon  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(shareBtn.mas_right).equalTo(@(-17.5));
            make.width.equalTo(@10);
            make.top.equalTo(shareBtn.mas_top).equalTo(@(15));
            make.height.equalTo(@10);
        }];
        
        
//        LNLabel * urlLabel = [LNLabel addLabelWithTitle:_dataDic[@"shopurl"] TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:14.0f BackGroundColor:MyColor];
//        [self.view addSubview:urlLabel];
//        urlLabel.numberOfLines = 0;
//        [urlLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(weakSelf.view.mas_left).offset(15);
//            make.right.equalTo(weakSelf.view.mas_right);
//            make.top.equalTo(wire3.mas_bottom).equalTo(@5);
//            make.height.equalTo(@([LNLabel calculateMoreLabelSizeWithString:_dataDic[@"shopurl"] AndWith:  (Width - 15 )AndFont:14.0] + 10));
//        }];
        UITextView * aurlText = [[UITextView alloc] init];
        aurlText.bounces = NO;
        aurlText.userInteractionEnabled = YES;
        aurlText.editable = NO;
        aurlText.tintColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0];
        aurlText.font = [UIFont systemFontOfSize:14.0f];
        aurlText.backgroundColor = MyColor;
        aurlText.text = _dataDic[@"shopurl"];
        [self.view addSubview:aurlText];
        [aurlText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).offset(15);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(wire3.mas_bottom).equalTo(@5);
            make.height.equalTo(@([LNLabel calculateMoreLabelSizeWithString:_dataDic[@"shopurl"] AndWith:  (Width - 15 )AndFont:14.0] + 10));
        }];
        
        LNLabel * directionLabel = [LNLabel addLabelWithTitle:@"复制上方连接地址推荐给好友" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:13.0f BackGroundColor:MyColor];
        [self.view addSubview:directionLabel];
        
        
        [directionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).offset(15);
            make.top.equalTo(aurlText.mas_bottom).equalTo(@5);
            make.height.equalTo(@([LNLabel calculateMoreLabelSizeWithString:@"复制上方连接地址推荐给好友" AndWith:  (Width - 15 )AndFont:14.0]));
        }];
        
        UIImageView * wire4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [self.view addSubview:wire4];
        [wire4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(directionLabel.mas_bottom).equalTo(@5);
            make.height.equalTo(@1);
        }];
        
        
        UIImageView * codeIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wire"]];
        [codeIcon setImageWithURL:[NSURL URLWithString:_dataDic[@"img_shopurl"]] placeholderImage:nil];
        [self.view addSubview:codeIcon];
        [codeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left).offset(80);
            make.right.equalTo(weakSelf.view.mas_right).offset(-80);
            make.top.equalTo(wire4.mas_bottom).equalTo(@20);
            make.height.equalTo(@(Width - 160));
        }];
        
        LNLabel * dirLabel = [LNLabel addLabelWithTitle:@"【扫一扫 成为我的客户!】" TitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] Font:15.0f BackGroundColor:MyColor];
        [self.view addSubview:dirLabel];
        dirLabel.textAlignment = NSTextAlignmentCenter;
        [dirLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.view.mas_left);
            make.right.equalTo(weakSelf.view.mas_right);
            make.top.equalTo(codeIcon.mas_bottom).equalTo(@10);
            make.height.equalTo(@([LNLabel calculateMoreLabelSizeWithString:@"复制上方连接地址推荐给好友" AndWith:  (Width - 15 )AndFont:16.0]));
        }];
        

        
}
    
}


-(void)toPopularize:(UIButton *)btn{
[UMSocialData defaultData].extConfig.title = @"花1块赚1块";
    [UMSocialData defaultData].shareText = [NSString stringWithFormat:@"边购物边赚钱，边打折边玩国币，陪我一起玩转能赚钱的购物平台%@",_dataDic[@"shopurl"]];
[UMSocialData defaultData].extConfig.qqData.url = _dataDic[@"shopurl"];
[UMSocialData defaultData].extConfig.qzoneData.url = _dataDic[@"shopurl"];
[UMSocialData defaultData].extConfig.wechatSessionData.url =[NSString stringWithFormat:@"%@",_dataDic[@"shopurl"]];
[UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@",_dataDic[@"shopurl"]];
[UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"cf6c2f593567658016dea766"
                                      shareText:[NSString stringWithFormat:@"边购物边赚钱，边打折边玩国币，陪我一起玩转能赚钱的购物平台%@",_dataDic[@"shopurl"]]
                                     shareImage:[UIImage imageNamed:@"shareIcon"]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone]
                                       delegate:self];
 
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
