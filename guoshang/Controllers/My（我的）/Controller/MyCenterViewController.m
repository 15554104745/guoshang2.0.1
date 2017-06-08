//
//  MyCenterViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/6/7.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyCenterViewController.h"
#import "UserModel.h"
#import "MyCenterCell.h"
#import "myCenterOrderCell.h"
//#import "LoginViewController.h"
#import "GSNewLoginViewController.h"
@interface MyCenterViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    
    NSMutableArray * _dataArray;
    UITableView * _myTableView;
    NSMutableDictionary * _dataDic;
    UIImageView * _userIcon;//用户头像
    UIView *  _tableHeaderView;//头视图
    
    
}
@end

@implementation MyCenterViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_myTableView reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    _dataArray = [NSMutableArray array];
    //状态栏消失
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createData];
    [self createUserData];
    [self createUI];

}
-(void)createData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _dataDic = [NSMutableDictionary dictionary];
        NSArray * oderView = @[@"order"];
        [_dataDic setObject:oderView forKey:@"0"];
        NSArray * collectionArray = @[@"shoucan",@"我的收藏",@"MyCollectViewController"];
        [_dataDic setObject:collectionArray forKey:@"1"];
        NSArray * moneyArray = @[@"zichan",@"我的金币",@"MyPropertyViewController"];
        [_dataDic setObject:moneyArray forKey:@"2"];
        NSArray * extensionArray = @[@"liulan",@"我的推广",@"MyPopularizeViewController"];
        [_dataDic setObject:extensionArray forKey:@"3"];
        NSArray * setArray = @[@"liulan",@"我的设置",@"SetUpViewController"];
        [_dataDic setObject:setArray forKey:@"4"];

        if (_dataDic.count ==5) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
               [_myTableView reloadData];
            });
        }
 
    });
    
    
}

#pragma mark - TableView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y >= 0) {//上滑
        _myTableView.tableHeaderView.clipsToBounds = YES;
    }else{//下滑
        _myTableView.tableHeaderView.clipsToBounds = NO;
        
        //背景图放大
        CGAffineTransform stratAngle =  CGAffineTransformMakeScale(1-scrollView.contentOffset.y/140, 1-scrollView.contentOffset.y/140);
        [_tableHeaderView viewWithTag:1010323].transform = stratAngle;
        CGRect foreRect = _tableHeaderView.frame;
        foreRect.origin.y = scrollView.contentOffset.y ;
        _tableHeaderView.frame = foreRect;
        
        
        //子视图 居中
        CGRect rect = [_tableHeaderView viewWithTag:1010324].frame;
        rect.origin.y = -scrollView.contentOffset.y/2.0;
        [_tableHeaderView viewWithTag:1010324].frame = rect;
        
    }
}

-(void) createUserData{
    
    
    if (_dataArray.count> 0) {
        
        [_dataArray removeAllObjects];
   }
    NSString * encryptString;
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
        
        NSString * userId = [NSString stringWithFormat:@"user_id=%@",UserId];
        
        encryptString = [userId encryptStringWithKey:KEY];
        
        
//        NSLog(@"%@",encryptString);
        
//        
        [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=my") parameters:@{@"token":encryptString} success:^(id responseObject) {
            if (responseObject[@"result"]!=nil) {
                
                
//                NSDictionary * dic = [NSDictionary dictionaryWithDictionary:responseObject[@"result"]];
                //UserModel * model = [UserModel ModelWithDict:dic];
                
                
                //[_dataArray addObject:model];
                
                
                
                
            }
            
            [_myTableView reloadData];
            
            
        } failure:^(NSError *error) {
            
        }];
        
    }

    
}



-(void)createUI{
    
    _myTableView.backgroundColor = MyColor;
     _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - 49) style:UITableViewStylePlain];
    [_myTableView registerClass:[MyCenterCell class] forCellReuseIdentifier:@"oneCell"];
    [_myTableView registerClass:[MyCenterOrderCell class] forCellReuseIdentifier:@"order"];
     _myTableView.delegate = self;
    _myTableView.showsHorizontalScrollIndicator = NO;
    _myTableView.dataSource = self;
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: _myTableView];
    
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  
    return _dataDic.count;
    
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    NSArray * array = [_dataDic objectForKey:str];
    if (indexPath.row == 0) {
        MyCenterOrderCell * cell = [tableView dequeueReusableCellWithIdentifier:@"order" forIndexPath:indexPath];
        cell.popView = self;
        
        return cell;
        
    }else{
        MyCenterCell  * cell =[tableView dequeueReusableCellWithIdentifier:@"oneCell" forIndexPath:indexPath];
        cell.myArray = array;
        return cell;
   
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row  == 0) {
        return 150.0;
    }else{
          return 50.0;
    }
 
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
     _tableHeaderView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 160.0f)];
    
    //背景图片
    UIImageView * backImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, 160)];
    backImage.tag = 1010323;
    backImage.image =[UIImage imageNamed:@"beijing"];
    backImage.layer.anchorPoint = CGPointMake(0.5, 0);
    backImage.layer.position = CGPointMake(Width / 2.0f, 0);
    [ _tableHeaderView addSubview:backImage];
    
    
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, _tableHeaderView.frame.size.height)];
   backgroundView.tag = 1010324;
    backgroundView.userInteractionEnabled = YES;
    [_tableHeaderView addSubview:backgroundView];
    //头像
    UIImageView * headerImage = [[UIImageView alloc] initWithFrame:CGRectMake((backImage.frame.size.width - 78)/2, (backImage.frame.size.height - 78)/2, 78.0, 78.0)];
    headerImage.layer.cornerRadius = 39;
    headerImage.clipsToBounds = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeaderView:)];
     NSData * imageData = [[NSUserDefaults standardUserDefaults] dataForKey:@"image"];
    if (imageData!= nil) {
        headerImage.image = [UIImage imageWithData:imageData];
        
    }else{
        
     headerImage.image = [UIImage imageNamed:@"touxiang"];
        
    }
    headerImage.userInteractionEnabled = YES;
    backgroundView.userInteractionEnabled = YES;
    [headerImage addGestureRecognizer:tap];
    [backgroundView addSubview:headerImage];

    
    if (UserId == nil) {
       
        UIButton * loginView =[UIButton buttonWithType:UIButtonTypeSystem];
        loginView.alpha = 0.8;
        loginView.backgroundColor = [UIColor grayColor];
        [loginView setTitle:@"登录/注册" forState:UIControlStateNormal];
        loginView.layer.cornerRadius = 5;
        loginView.clipsToBounds = YES;
        [loginView addTarget:self action:@selector(toLogin:) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:loginView];
        [loginView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(backgroundView.mas_left).offset(20);
            make.bottom.equalTo(backgroundView.mas_bottom).offset(-5);
            make.right.equalTo(backgroundView.mas_right).offset(-20);
            make.height.equalTo(@30);
        }];
        
    }else{
        
        
        //用户名
        LNLabel * userPhone = [LNLabel addLabelWithTitle:@"" TitleColor:[UIColor blackColor] Font:15.0f BackGroundColor:[UIColor redColor]];
        [backgroundView addSubview:userPhone];
        [userPhone mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView.mas_left).offset(20);
            make.top.equalTo(headerImage.mas_bottom).offset(5);
            make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"18832831238" AndFont:16.0]);
            
        }];
        
        
        
        LNLabel * userMember = [LNLabel addLabelWithTitle:@"" TitleColor:[UIColor blackColor] Font:15.0f BackGroundColor:[UIColor redColor]];
        [backgroundView addSubview:userMember];
        
        [userMember mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(userPhone.mas_right).offset(20);
            make.top.equalTo(headerImage.mas_bottom).offset(5);
            make.height.equalTo(@20);
            make.right.equalTo(backgroundView.mas_right);
            
        }];
        
        
        if (_dataArray.count > 0) {
            
            //UserModel * model = _dataArray[0];
            
            //userPhone.text = model.user;
            
            //userMember.text = model.number;
            
        }
 
    }
    
    UIView *headBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160.0f)];
    [headBackView addSubview:_tableHeaderView];
    
    
    return headBackView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 160.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath == 0) {
        return;
    }else{
        
        NSString * str = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        NSArray * array = [_dataDic objectForKey:str];
        UIViewController * poshView = [[NSClassFromString(array[2]) alloc] init];
        poshView.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:poshView animated:YES];
        
        
    }
}
-(void)clickHeaderView:(UITapGestureRecognizer *)tap{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    
    //判断一下 当前设备支持哪种功能(相机和相册)
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
//        NSLog(@"支持相机");
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
//        NSLog(@"支持相册");
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
//        _userIcon.image = image;
        
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        //如果刚才的图片是刚刚照出来的
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData * imageData = UIImageJPEGRepresentation(image, 1);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
//        _userIcon.image = image;
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

#pragma mark - 登录注册
-(void)toLogin:(UIButton *)button{
    
    GSNewLoginViewController * myView = [[GSNewLoginViewController alloc] init];
    myView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myView animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
