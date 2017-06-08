//
//  GSChangeShopClassViewController.m
//  guoshang
//
//  Created by chenlei on 16/10/10.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSChangeShopClassViewController.h"
#import "SVProgressHUD.h"

@interface GSChangeShopClassViewController ()
{
    BOOL _isOnStatus;
    UITextField *_textField;
    UISwitch *_sw;
}
@end

@implementation GSChangeShopClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
   
    [self createNav];
    [self makeUI];
}
- (void)createNav{
    UIView *navView = [[UIView alloc] init];
    navView.frame = CGRectMake(0, 0, Width, 64);
    navView.backgroundColor = GS_Business_NavBarColor;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 20, 48, 48);
    [backBtn setImage:[UIImage imageNamed:@"back_jt"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(toBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    
    
    UILabel *titleLabel = [[UILabel alloc] init];
    CGFloat titleX =CGRectGetMaxX(backBtn.frame);
    CGFloat titleY= 20;
    CGFloat titleW= Width-backBtn.frame.size.width*2;
    CGFloat titleH = 44;
    titleLabel.frame = CGRectMake(titleX, titleY,titleW,titleH);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"修改商品分类";
    [navView addSubview:titleLabel];
    [self.view addSubview:navView];
}
//返回按钮被点击
- (void)toBack{
    [self.navigationController popViewControllerAnimated:YES];
}
  //初始状态设置
-(void)getTheSwitchFirstStatus {
    if ([self.status isEqualToString:@"1"]) {
        _sw.on = YES;
        _isOnStatus = YES;
    }else{
        _sw.on = NO;
        _isOnStatus = NO;
    }
}
- (void)makeUI {
    NSArray *arr = @[@"分类名称：",@"状态："];
    for (int i=0 ; i<arr.count; i++) {
        UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 80+i*50, 100, 30)];
        lab.text = arr[i];
        lab.font = [UIFont systemFontOfSize:14];
        lab.textAlignment = NSTextAlignmentRight;
        [self.view addSubview:lab];
    }
    CGRect frame = CGRectMake(120, 80, Width-140, 30);
    _textField = [[UITextField alloc] initWithFrame:frame];
    _textField.text = self.category_title;
    _textField.layer.borderColor = [UIColor blackColor].CGColor;
    _textField.layer.borderWidth= .5f;
    _textField.layer.cornerRadius = 5;
    _textField.font= [UIFont systemFontOfSize:14];
    [self.view addSubview:_textField];
    frame.size.width = 8;//设置左边距的大小
    UIView *leftview = [[UIView alloc] initWithFrame:frame];
    _textField.leftViewMode = UITextFieldViewModeAlways;//设置左边距显示的时机，这个表示一直显示
    _textField.leftView = leftview;
    
    _sw = [[UISwitch alloc] initWithFrame:CGRectMake(120, 130, 30, 30)];
    //初始状态设置
    [self getTheSwitchFirstStatus];
    
    _sw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    _sw.tintColor = GS_Manager_Class_GreenColor;
    _sw.onTintColor = GS_Manager_Class_GreenColor;
    _sw.thumbTintColor = [UIColor whiteColor];
        [_sw addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_sw];
    NSArray *buttonArr = @[@"取消",@"修改"];
    
    for (int i=0; i<buttonArr.count; i++) {
        NSInteger btnWitdh = 20;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(btnWitdh+i*((Width-btnWitdh*4)/2+2*btnWitdh), 200, (Width-btnWitdh*4)/2, 30);
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        button.layer.cornerRadius = 5;
        if (i==0) {
            [button setBackgroundColor:[UIColor lightGrayColor]];
        }else {
            [button setBackgroundColor:kUIColorFromRGB(0xE73736)];
        }
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventAllEvents];
        [self.view addSubview:button];
        
    }
}

-(void)switchValueChange:(UISwitch*)sw
{
    if(sw.on)
    {//开
        _isOnStatus = YES;
    }
    else
    {//关
        _isOnStatus = NO;
    }
    
}
- (void)buttonClick:(UIButton *)btn {
    [_textField resignFirstResponder];
    UIAlertController *Alert = [UIAlertController alertControllerWithTitle:@"温馨提示：" message:@"确认执行此项操作吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    [Alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if ([btn.titleLabel.text isEqualToString:@"取消"]) {
        }else {
            [self getTheSwitchFirstStatus];
        }
    }]];
    [Alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([btn.titleLabel.text isEqualToString:@"取消"]) {
            [self getTheSwitchFirstStatus];
            [self toBack];
        }else {
            [self addShopClassData];
        }
        
    }]];
    
    [self presentViewController:Alert animated:YES completion:nil];
} 
- (void)addShopClassData {

    [_textField resignFirstResponder];

    NSLog(@"%@",_textField.text);
    __weak typeof(self) weakSelf = self;
    NSString * account = [NSString stringWithFormat:@"shop_id=%@,category_title=%@,status=%d,category_id=%@",GS_Business_Shop_id,_textField.text,_isOnStatus,self.category_id];
    NSString * encryptString = [account encryptStringWithKey:KEY];
    [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/editCategory") parameters:@{@"token":encryptString} success:^(id responseObject) {
        
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
            if (weakSelf.GSChangeShopClassViewControllerBlock) {
                weakSelf.GSChangeShopClassViewControllerBlock(@"YES");
            }
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }else {
             [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            //失败后初始状态
            [weakSelf getTheSwitchFirstStatus];
        }
        
    } failure:^(NSError *error) {
         [SVProgressHUD showErrorWithStatus:@"网络故障，请重试"];
        //失败后初始状态
        [weakSelf getTheSwitchFirstStatus];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_textField resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    return YES;
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
