//
//  MyGSViewController.m
//  guoshang
//
//  Created by hi on 16/2/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyGSViewController.h"
#import "Masonry.h"
#import "UserModel.h"
#import "MyOrderViewController.h"
#import "MyCollectViewController.h"
//#import "MyCollenctionViewController.h"
@interface MyGSViewController ()
{
    NSMutableArray * _dataArray;
    UIImageView * _userIcon;
}
@end

@implementation MyGSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.navigationItem.title = @"我的国商登录成功页面";
    _dataArray = [NSMutableArray array];
    [self createItems];
     [self createData];
    [self createUI];
   
}

-(void)createItems{
    UIBarButtonItem * setWordItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone  target:self action:@selector(toSetUp:)];
    
    
    UIImage * selectImage = [UIImage imageNamed:@"设置"];
    
    UIBarButtonItem * selectItem = [[UIBarButtonItem alloc] initWithImage:selectImage style:UIBarButtonItemStyleDone target:self action: @selector(toSelect:)];
    
    self.navigationItem.rightBarButtonItems = @[setWordItem,selectItem];
    
    
    
    
}
-(void)createUI{
//    __weak typeof(self)weakSelf = self;
    
    //用户信息的UI布局
    UserModel * model = _dataArray[0];
    _userIcon = [[UIImageView alloc] init];
    _userIcon.layer.cornerRadius = 25;
    _userIcon.clipsToBounds = YES;
    _userIcon.image = [UIImage imageNamed:@"设置"];
    UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goIntoPhotoLibrary:)];
    _userIcon.userInteractionEnabled = YES;
    [_userIcon addGestureRecognizer:tap];
    [self.view addSubview:_userIcon];
   [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.view.mas_left).offset(10);
       make.top.equalTo(self.view.mas_top).offset(10);
       make.height.equalTo(@50);
       make.width.equalTo(@50);
   }];
    UILabel  *userLabel = [[UILabel alloc] init];
    userLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:userLabel];
    userLabel.text = model.user;
     [userLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.equalTo(_userIcon.mas_right).offset(30);
         make.top.equalTo(_userIcon.mas_top).offset(15);
         make.height.equalTo(@30);
         make.width.equalTo(@200);
         
     }];
    
    UILabel  *memberLabel = [[UILabel alloc] init];
    memberLabel.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0  blue:arc4random()%256/255.0  alpha:1.0];
    [self.view addSubview:memberLabel];
   memberLabel.text = model.number;
    [memberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(userLabel.mas_top);
        make.height.equalTo(@30);
        make.width.equalTo(@100);
        
    }];
    
    
    //我的订单
    UILabel * wire = [[UILabel alloc] init];
    wire.backgroundColor = [UIColor blackColor];
    [self.view addSubview:wire];
    [wire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(_userIcon.mas_bottom).offset(10);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView * orderView = [[UIView alloc] init];
    orderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:orderView];
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire.mas_bottom);
        make.height.equalTo(@130);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UILabel * wire2 = [[UILabel alloc] init];
    wire2.backgroundColor = [UIColor blackColor];
    [orderView addSubview:wire2];
    [wire2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire.mas_bottom).offset(40);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];
    UILabel * myOrderLable = [[UILabel alloc] init];
    myOrderLable.text = @"我的订单";
    [orderView addSubview:myOrderLable];
    [myOrderLable mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.view.mas_left).offset(10);
        make.top.equalTo(wire.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@100);
    }];
    
    UIButton * seeAllBtn = [[UIButton alloc] init];
    seeAllBtn.backgroundColor = [UIColor whiteColor];
    [seeAllBtn setTitle:@"查看全部订单" forState:UIControlStateNormal];
    [seeAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [seeAllBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    seeAllBtn.tag = 500;
    [orderView addSubview:seeAllBtn];
    [seeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(wire.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    
    int podding = (self.view.frame.size.width - 40 * 2)/3;
    UIButton * payMoney = [[UIButton alloc] init];
    payMoney.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0  blue:arc4random()%256/255.0  alpha:1.0];
    payMoney.tag = 501;
    [payMoney addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:payMoney];
    [payMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(wire2.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    UIButton * payMoneyBtn = [[UIButton alloc] init];
    payMoneyBtn.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0  blue:arc4random()%256/255.0  alpha:1.0];
    payMoneyBtn.tag = 501;
    [payMoneyBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:payMoneyBtn];
    [payMoneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(wire2.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    UILabel * payMoneylable = [[UILabel alloc] init];
    payMoneylable.text = @"待付款";
    payMoneylable.font = [UIFont systemFontOfSize:12];
    [orderView addSubview:payMoneylable];
    [payMoneylable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(20);
        make.top.equalTo(payMoneyBtn.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * disGoodsBtn = [[UIButton alloc] init];
    disGoodsBtn.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0  blue:arc4random()%256/255.0  alpha:1.0];
    disGoodsBtn.tag = 502;
    [disGoodsBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:disGoodsBtn];
    [disGoodsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payMoneyBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    UILabel * disGoogslable = [[UILabel alloc] init];
    disGoogslable.text = @"待发货";
    disGoogslable.font = [UIFont systemFontOfSize:12];
    [orderView addSubview:disGoogslable];
    [disGoogslable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(payMoneylable.mas_left).offset(podding);
        make.top.equalTo(disGoodsBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * confirmBtn = [[UIButton alloc] init];
    confirmBtn.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0  blue:arc4random()%256/255.0  alpha:1.0];
    confirmBtn.tag = 503;
    [confirmBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disGoodsBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    UILabel * confirmlLable = [[UILabel alloc] init];
    confirmlLable.text = @"待确认";
    confirmlLable.font = [UIFont systemFontOfSize:12];
    [orderView addSubview:confirmlLable];
    [confirmlLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(disGoodsBtn.mas_left).offset(podding);
        make.top.equalTo(disGoodsBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    
    UIButton * completeBtn = [[UIButton alloc] init];
    completeBtn.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0  blue:arc4random()%256/255.0  alpha:1.0];
    completeBtn.tag = 504;
    [completeBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [orderView addSubview:completeBtn];
    [completeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmBtn.mas_left).offset(podding);
        make.top.equalTo(wire2.mas_bottom).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    UILabel * completeLable = [[UILabel alloc] init];
    completeLable.text = @"待确认";
    completeLable.font = [UIFont systemFontOfSize:12];
    [orderView addSubview:completeLable];
    [completeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(confirmlLable.mas_left).offset(podding);
        make.top.equalTo(completeBtn .mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@50);
    }];
    
    UILabel * wire3 = [[UILabel alloc] init];
    wire3.backgroundColor = [UIColor blackColor];
    [orderView addSubview:wire3];
    [wire3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(payMoneylable.mas_bottom).offset(10);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];

    
//    //我的收藏和资产
    UILabel * wire4 = [[UILabel alloc] init];
    wire4.backgroundColor = [UIColor blackColor];
    [self.view addSubview:wire4];
    [wire4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(orderView.mas_bottom).offset(10);
        make.height.equalTo(@1);
        make.right.equalTo(self.view.mas_right);
    }];

    UIView * myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:myView];
    [myView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(wire4.mas_bottom);
        make.height.equalTo(@80);
        make.right.equalTo(self.view.mas_right);
    }];
    

    UIButton * collectionBtn =[[UIButton alloc] init];
    collectionBtn.backgroundColor = [UIColor redColor];
    collectionBtn.tag = 505;
    [collectionBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:collectionBtn];
    [collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(myView.mas_left).offset(30);
        make.top.equalTo(myView.mas_top).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        
    }];
    UILabel * collectionLabel =[[UILabel alloc] init];
    collectionLabel.text = @"我的收藏";
    [myView addSubview:collectionLabel];
    [collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(collectionBtn.mas_right).offset(10);
        make.top.equalTo(collectionBtn.mas_top).offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
        
    }];
    
    UILabel * wire5 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2, 0, 1, 80)];
    wire5.backgroundColor = [UIColor blackColor];
    [myView addSubview:wire5];
    
    UIButton * momeyBtn =[[UIButton alloc] init];
    momeyBtn.backgroundColor = [UIColor redColor];
    momeyBtn.tag = 506;
    [momeyBtn addTarget:self action:@selector(toclick:) forControlEvents:UIControlEventTouchUpInside];
    [myView addSubview:momeyBtn];
    [momeyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(wire5.mas_left).offset(30);
        make.top.equalTo(myView.mas_top).offset(20);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
        
    }];
    UILabel * momeyLabel =[[UILabel alloc] init];
    momeyLabel.text = @"我的资产";
    [myView addSubview:momeyLabel];
    [momeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(momeyBtn.mas_right).offset(10);
        make.top.equalTo(momeyBtn.mas_top).offset(5);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
        
    }];
    
    
}
-(void)toclick:(UIButton *)button{
    switch (button.tag - 500) {
        case 0:{
            MyOrderViewController * orderView = [[MyOrderViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:orderView animated:YES];
            
            NSLog(@"查看全部订单");
            
        }
            
            break;
            
        case 1:
            NSLog(@"待付款");
            break;
        case 2:
            NSLog(@"待发货");
            break;
        case 3:
            NSLog(@"待确认");
            break;
        case 4:
            NSLog(@"已完成");
            break;
            
        case 5:{
           MyCollectViewController * collection = [[MyCollectViewController alloc] init];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:collection animated:YES];
            NSLog(@"我的收藏");
            
        }
            
            
            break;
            
        case 6:
            NSLog(@"我的资产");
            break;
        default:
            break;
    }
    
    
}
-(void)createData{

    NSDictionary * dic = [NSDictionary dictionaryWithObjects:@[@"user",@"icon",@"number"] forKeys:@[@"15100313111",@"设置",@"银牌会员"]];
    UserModel * model = [UserModel ModelWithDict:dic];
    [_dataArray addObject:model];
    for (UserModel * user in _dataArray) {
        NSLog(@"%@ %@ %@",user.icon,user.number,user.user);
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
        
        _userIcon.image = image;
        
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        //如果刚才的图片是刚刚照出来的
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
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
