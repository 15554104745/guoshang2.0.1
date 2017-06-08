//
//  GetPresentViewController.m
//  guoshang
//
//  Created by 陈赞 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GetPresentViewController.h"
#import "RandomUtil.h"
#import "AuthCodeView.h"
#import "MyAddressViewController.h"
#import "SVProgressHUD.h"
@interface GetPresentViewController ()<AuthCodeViewDataSource>
{
    NSString * code;
    
    NSString * addressid;
}
@property(nonatomic,strong)UITextField * TF1;
@property(nonatomic,strong)UITextField * TF2;
@property(nonatomic,strong)UIView * MyView1;
@property(nonatomic,strong)UIView * MyView2;
@property(nonatomic,strong)UIView * MyView3;
@property(nonatomic,strong)UILabel * jiaobiaoLB;
@property(nonatomic,strong)UIButton * lingqu;

@end
#define CountForText 4
@implementation GetPresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"领取赠品";
    if (self.type) {
        [self config2:self.type];
    }
    else
    {
        [self config3];
    }
    //    int temp = 2;
    //    if (temp ==1) {
    //        [self config1];
    //    }
    //    else if (temp ==2)
    //    {
    
    //    }
    //    else
    //    {
    //        self.title = @"领取赠品";
    //        [self config3];
    //    }
    // Do any additional setup after loading the view.
}
//-(void)config1
//{
//    [self.MyView3 removeFromSuperview];
//    self.MyView1 = [[UIView alloc]initWithFrame:self.view.frame];
//    [self.view addSubview:self.MyView1];
//    UIImageView * backIm  = [[UIImageView alloc]initWithFrame:CGRectMake((Width-200)/2, 80, 200, 120)];
//    backIm.contentMode = UIViewContentModeScaleAspectFit;
//    self.view.backgroundColor  =[UIColor whiteColor];
//    backIm.image = [UIImage imageNamed:@"DFFBBD4E-3DD9-46E7-A76A-69C39A5BC81A"];
//    [self.MyView1 addSubview:backIm];
//
//    UIButton * chongzhiBT = [[UIButton alloc]initWithFrame:CGRectMake(30, 280, Width-60, 44)];
//    [chongzhiBT setTitle:@"立即充值" forState:1];
//    [chongzhiBT setTitle:@"立即充值" forState:0];
//    [chongzhiBT addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
//    [chongzhiBT setTitleColor:[UIColor whiteColor] forState:0];
//    [chongzhiBT setTitleColor:[UIColor whiteColor] forState:1];
//    chongzhiBT.backgroundColor = COLOR(228, 58, 61, 1);
//    chongzhiBT.layer.masksToBounds = YES;
//    chongzhiBT.layer.cornerRadius = 20;
//    [self.MyView1 addSubview:chongzhiBT];
//}
-(void)lingquguobi
{
    [_lingqu setBackgroundColor: [UIColor lightGrayColor] ];
    _lingqu.enabled = NO;
    [SVProgressHUD showWithStatus:@"请稍后"];
    
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,cart_id=%@,pay_points=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],_chongzhikaID,_guobiCount];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/GiveGift") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        
//        NSLog(@"%@",responseObject);
        if([responseObject[@"status"] integerValue]==1)
        {
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [SVProgressHUD dismiss];
            _lingqu.backgroundColor = COLOR(228, 58, 61, 1);
            _lingqu.enabled = YES;
            
        }
        else
        {
            _guobiCount =@"0";
            weakSelf.jiaobiaoLB.text = _guobiCount;
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [SVProgressHUD dismiss];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
-(void)config2:(NSString*)str
{
    
    [self.MyView3 removeFromSuperview];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    if([str isEqualToString:@"1"])//只有国币
    {
        
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 250)];
        view1.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view1];
        UILabel * titleLB1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        titleLB1.text = @"专享国币";
        titleLB1.font = [UIFont systemFontOfSize:20];
        [view1 addSubview:titleLB1];
        
        UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-40, 50, 80, 80)];
        image1.image= [UIImage imageNamed:@"4567F57F-1894-4169-9045-B9C040D86750"];
        [view1 addSubview:image1];
        
        self.jiaobiaoLB = [[UILabel alloc]initWithFrame:CGRectMake(image1.frame.origin.x+80 , 30, 38, 38)];
        self.jiaobiaoLB.layer.masksToBounds = YES;
        self.jiaobiaoLB.layer.cornerRadius = self.jiaobiaoLB.bounds.size.width*0.5;
        self.jiaobiaoLB.backgroundColor = [UIColor blackColor];
        self.jiaobiaoLB.layer.borderColor = [UIColor blackColor].CGColor;
        self.jiaobiaoLB.layer.borderWidth = 1;
        self.jiaobiaoLB.text = _guobiCount;
        
        self.jiaobiaoLB.textAlignment  =1;
        self.jiaobiaoLB.textColor = [UIColor whiteColor];
        self.jiaobiaoLB.font = [UIFont systemFontOfSize:9];
        [view1 addSubview:self.jiaobiaoLB];
        
        UILabel * LB1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 150, Width-30, 40)];
        LB1.text = @"领取国币后，可能存在延迟现象,一般三天内到账,如有问题，请咨询客服;";
        LB1.numberOfLines = 2;
        LB1.font = [UIFont systemFontOfSize:13];
        [view1 addSubview:LB1];
        
        _lingqu = [[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, 210, 100, 30)];
        [_lingqu addTarget:self action:@selector(lingquguobi) forControlEvents:UIControlEventTouchUpInside];
        [_lingqu setTitleColor:[UIColor whiteColor] forState:0];
        [_lingqu setTitleColor:[UIColor whiteColor] forState:1];
        _lingqu.backgroundColor = COLOR(228, 58, 61, 1);
        _lingqu.layer.masksToBounds = YES;
        _lingqu.layer.cornerRadius = 10;
        [_lingqu setTitle:@"领取国币" forState:0];
        [view1 addSubview:_lingqu];
        
    }
    else if([str isEqualToString:@"2"])
    {
        UIScrollView * Myscr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
        [self.view addSubview:Myscr];
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 200)];
        
        view1.backgroundColor = [UIColor whiteColor];
        [Myscr addSubview:view1];
        UILabel * titleLB1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        titleLB1.text = @"专享国币";
        titleLB1.font = [UIFont systemFontOfSize:20];
        [view1 addSubview:titleLB1];
        
        UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-40, 50, 80, 80)];
        image1.image= [UIImage imageNamed:@"4567F57F-1894-4169-9045-B9C040D86750"];
        [view1 addSubview:image1];
        
        self.jiaobiaoLB = [[UILabel alloc]initWithFrame:CGRectMake(image1.frame.origin.x+80 , 30, 38, 38)];
        self.jiaobiaoLB.layer.masksToBounds = YES;
        self.jiaobiaoLB.layer.cornerRadius = self.jiaobiaoLB.bounds.size.width*0.5;
        self.jiaobiaoLB.backgroundColor = [UIColor blackColor];
        self.jiaobiaoLB.layer.borderColor = [UIColor blackColor].CGColor;
        self.jiaobiaoLB.layer.borderWidth = 1;
        self.jiaobiaoLB.text = _guobiCount;
        
        self.jiaobiaoLB.textAlignment  =1;
        self.jiaobiaoLB.textColor = [UIColor whiteColor];
        self.jiaobiaoLB.font = [UIFont systemFontOfSize:9];
        [view1 addSubview:self.jiaobiaoLB];
        
        UILabel * LB1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 150, Width-30, 40)];
        LB1.text = @"领取国币后，可能存在延迟现象,一般三天内到账,如有问题，请咨询客服;";
        LB1.numberOfLines = 2;
        LB1.font = [UIFont systemFontOfSize:13];
        [view1 addSubview:LB1];
        
        //        UIButton * lingqu = [[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, 210, 100, 30)];
        //             [lingqu addTarget:self action:@selector(lingquguobi) forControlEvents:UIControlEventTouchUpInside];
        //        [lingqu setTitleColor:[UIColor whiteColor] forState:0];
        //        [lingqu setTitleColor:[UIColor whiteColor] forState:1];
        //        lingqu.backgroundColor = COLOR(228, 58, 61, 1);
        //        lingqu.layer.masksToBounds = YES;
        //        lingqu.layer.cornerRadius = 10;
        //        [lingqu setTitle:@"领取国币" forState:0];
        //        [view1 addSubview:lingqu];
        
        UIView * view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 210, Width, 260)];
        view2.backgroundColor = [UIColor whiteColor];
        [Myscr addSubview:view2];
        UILabel * titleLB2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 200, 20)];
        titleLB2.text = @"国商定制PAD";
        titleLB2.font = [UIFont systemFontOfSize:20];
        [view2 addSubview:titleLB2];
        
        
        UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-57, 50, 150, 114)];
        image2.image= [UIImage imageNamed:@"3573D5EE-4CC2-40C3-BDB1-AFD94D130687"];
        
        [view2 addSubview:image2];
        
        _lingqu = [[UIButton alloc]initWithFrame:CGRectMake(Width/2-75, 180, 150, 30)];
        [_lingqu setTitleColor:[UIColor whiteColor] forState:0];
        [_lingqu setTitleColor:[UIColor whiteColor] forState:1];
        _lingqu.backgroundColor = COLOR(228, 58, 61, 1);
        _lingqu.layer.masksToBounds = YES;
        _lingqu.layer.cornerRadius = 10;
        [_lingqu addTarget:self action:@selector(lingqupad) forControlEvents:UIControlEventTouchUpInside];
        [_lingqu setTitle:@"领取PAD、国币" forState:0];
        [view2 addSubview:_lingqu];
        
        
        UIButton * addressBT = [[UIButton alloc]initWithFrame:CGRectMake(Width-100, 230, 100, 15)];
        [addressBT addTarget:self action:@selector(getaddress) forControlEvents:UIControlEventTouchUpInside];
        [addressBT setTitleColor:COLOR(94, 144, 227, 1) forState:0];
        addressBT.titleLabel.font = [UIFont systemFontOfSize:15];
        [addressBT setTitle:@"选择邮寄地址" forState:0];
        [view2 addSubview:addressBT];
        NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
        //添加当前类对象为一个观察者，name和object设置为nil，表示接收一切通知
        [center addObserver:self selector:@selector(notice:) name:@"123" object:nil];
        Myscr.contentSize = CGSizeMake(Width, 470);
        
    }
    else
    {
        UIView * view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 250)];
        view1.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view1];
        UILabel * titleLB1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 20)];
        titleLB1.text = @"体验卡";
        titleLB1.font = [UIFont systemFontOfSize:20];
        [view1 addSubview:titleLB1];
        
        UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2-40, 50, 80, 80)];
        image1.image= [UIImage imageNamed:@"u=1504087690,3335579951&fm=21&gp=0.jpg"];
        [view1 addSubview:image1];
        
        UILabel * LB1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 150, Width-30, 40)];
        LB1.text = @"领取体验卡后，可能存在延迟现象,一般三天内到账,如有问题，请咨询客服;";
        LB1.numberOfLines = 2;
        LB1.font = [UIFont systemFontOfSize:13];
        [view1 addSubview:LB1];
        
        _lingqu = [[UIButton alloc]initWithFrame:CGRectMake(Width/2-50, 210, 100, 30)];
        [_lingqu setTitleColor:[UIColor whiteColor] forState:0];
        [_lingqu setTitleColor:[UIColor whiteColor] forState:1];
        _lingqu.backgroundColor = COLOR(228, 58, 61, 1);
        _lingqu.layer.masksToBounds = YES;
        _lingqu.layer.cornerRadius = 10;
        [_lingqu addTarget:self action:@selector(lingqutiyanka) forControlEvents:UIControlEventTouchUpInside];
        [_lingqu setTitle:@"领取体验卡" forState:0];
        [view1 addSubview:_lingqu];
    }
    [SVProgressHUD dismiss];
}
-(void)lingqutiyanka
{
    [_lingqu setBackgroundColor: [UIColor lightGrayColor] ];
    _lingqu.enabled = NO;
    [SVProgressHUD showWithStatus:@"请稍后"];
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,cart_id=%@,rechargeable_card=100",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],_chongzhikaID];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/GiveGift") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        
//        NSLog(@"%@",responseObject);
        if([responseObject[@"status"] integerValue]==1)
        {
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            _lingqu.backgroundColor = COLOR(228, 58, 61, 1);
            _lingqu.enabled = YES;
            [SVProgressHUD dismiss];
            
        }
        else
        {
            
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
-(void)lingqupad
{
    if (addressid.length ==0) {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请先选择收货地址" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [_lingqu setBackgroundColor: [UIColor lightGrayColor] ];
    _lingqu.enabled = NO;
    [SVProgressHUD showWithStatus:@"请稍后"];
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,cart_id=%@,ipad=1,user_addrass=%@,pay_points=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],_chongzhikaID,addressid,_guobiCount];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/GiveGift") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        
//        NSLog(@"%@",responseObject);
        if([responseObject[@"status"] integerValue]==1)
        {
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"领取失败！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            _lingqu.enabled = YES;
            [SVProgressHUD dismiss];
            [SVProgressHUD dismiss];
        }
        else
        {
            
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"领取成功！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            [SVProgressHUD dismiss];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}
-(void)getaddress
{
    MyAddressViewController * cz = [[MyAddressViewController alloc]init];
    cz.Type = @"sel";
    [self.navigationController pushViewController:cz animated:YES];
}
-(void)notice:(NSNotification*)dic
{
    NSDictionary *sDict = [[NSDictionary alloc] init];
    sDict = dic.userInfo;
    addressid = [sDict objectForKey:@"id"];
}
-(void)config3
{
    
    self.MyView3 = [[UIView alloc]initWithFrame:self.view.frame];
    self.MyView3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.MyView3];
    
    UILabel * lb1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 50, 90, 15)];
    lb1.text = @"赠品卡密码：";
    lb1.font = [UIFont systemFontOfSize:15];
    lb1.textColor  =COLOR(102, 102, 102, 102);
    [self.MyView3 addSubview:lb1];
    
    _TF1 =[[UITextField alloc]initWithFrame:CGRectMake(110, 45, Width-110-20, 30)];
    _TF1.borderStyle =  UITextBorderStyleRoundedRect;
    _TF1.placeholder = @"密码区分大小写";
    [_TF1 setValue:[UIFont boldSystemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    [self.MyView3 addSubview:_TF1];
    
    UILabel * lb2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 100, 110, 15)];
    lb2.text = @"请输入验证码：";
    lb2.font = [UIFont systemFontOfSize:15];
    lb2.textColor  =COLOR(102, 102, 102, 102);
    [self.MyView3 addSubview:lb2];
    
    _TF2 =[[UITextField alloc]initWithFrame:CGRectMake(125, 95, Width-125-90, 30)];
    _TF2.borderStyle =  UITextBorderStyleRoundedRect;
    
    [self.MyView3 addSubview:_TF2];
    
    AuthCodeView *codeViewText = [[AuthCodeView alloc] initWithType:AuthCodeViewTypeText];
    [codeViewText setFrame:CGRectMake(Width-75, 95, 64.0, 30)];
    
    codeViewText.dataSource = self;
    [self.MyView3 addSubview:codeViewText];
    
    UIButton * chongzhiBT = [[UIButton alloc]initWithFrame:CGRectMake(30, 280, Width-60, 44)];
    [chongzhiBT setTitle:@"提交" forState:1];
    [chongzhiBT setTitle:@"提交" forState:0];
    [chongzhiBT addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
    [chongzhiBT setTitleColor:[UIColor whiteColor] forState:0];
    [chongzhiBT setTitleColor:[UIColor whiteColor] forState:1];
    chongzhiBT.backgroundColor = COLOR(228, 58, 61, 1);
    chongzhiBT.layer.masksToBounds = YES;
    chongzhiBT.layer.cornerRadius = 20;
    [self.MyView3 addSubview:chongzhiBT];
    
}
-(void)next
{
    
    
    if (![_TF2.text isEqualToString:code]) {
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"您的验证码输入有误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    if (_TF1.text.length ==0) {
        
        UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:@"请输入您的兑换码" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [SVProgressHUD showWithStatus:@"数据加载中"];
    NSString *  encryptString;
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,gift_password=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"enter"],_TF1.text];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/CheckGift") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        
        if([responseObject[@"status"] integerValue]==1)
        {
            UIAlertView * alert =[[UIAlertView alloc]initWithTitle:@"提示" message:responseObject[@"message"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [SVProgressHUD dismiss];
            
        }
        else
        {
            if([responseObject[@"result"][@"rechargeable_card"] integerValue]>0)//实体卡
            {
                _chongzhikaID =responseObject[@"result"][@"card_id"] ;
                [weakSelf config2:@"3"];
            }
            else if ([responseObject[@"result"][@"ipad"] integerValue]==0)//直送国币
            {
                _guobiCount = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"pay_points"]];
                _chongzhikaID =responseObject[@"result"][@"card_id"] ;
                [weakSelf config2:@"1"];
            }
            else//国币+pad
            {
                _guobiCount = [NSString stringWithFormat:@"%@",responseObject[@"result"][@"pay_points"]];
                _chongzhikaID =responseObject[@"result"][@"card_id"] ;
                [weakSelf config2:@"2"];
            }
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    //
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)authCodeView:(AuthCodeView *)p_view withType:(AuthCodeViewType)p_type;
{
    
    char data[CountForText];
    for (int x = 0; x < CountForText; x++)
    {
        
        int j = '0' + (arc4random_uniform(75));
        
        if((j>=58 && j<= 64) || (j>=91 && j<=96)){
            --x;
            continue;
        }else{
            data[x] = (char)j;
        }
        
        
    }
    
    code =[[NSString alloc] initWithBytes:data length:CountForText encoding:NSUTF8StringEncoding];
    return [[NSString alloc] initWithBytes:data length:CountForText encoding:NSUTF8StringEncoding];
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
