//
//  AccountViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/9.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import "AccountViewController.h"
#import "ChangePhoneViewController.h"
#import "changePasswordViewController.h"
#import "LNLabel.h"
@interface AccountViewController ()
{
    UIView * _changeImage;
}
@property (nonatomic, weak) IBOutlet UILabel *userphone;
@end

@implementation AccountViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户与安全";
    self.view.backgroundColor = MyColor;
    self.userImage.layer.cornerRadius = 20;
    self.userImage.clipsToBounds = YES;
    //用户头像
    NSData * imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"image"];
    self.userImage.image = [UIImage imageWithData:imageData];
    //用户名
    self.userphone.text =  [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]];
    
}

- (IBAction)UIbuttonClick:(UIButton *)sender {
    switch (sender.tag- 50) {
        case 0:{
            ChangePhoneViewController * changePhone = [[ChangePhoneViewController alloc] init];
            changePhone.phoneString = ^(NSString * str){
                _userphone.text = str;
            };
            [self.navigationController pushViewController:changePhone animated:YES];
        }
            break;
        case 1:{
            sender.selected = !sender.selected;
            
            if (sender.selected== YES) {
                UIView * shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
                shadeView.backgroundColor = [UIColor blackColor];
                shadeView.alpha = 0.5;
                shadeView.tag = 70;
                shadeView.userInteractionEnabled = NO;
                [self.view addSubview:shadeView];
                [self createUserImageView];
               
            }else{
                [_changeImage removeFromSuperview];
                UIView * shadeView = [self.view viewWithTag:70];
                [shadeView removeFromSuperview];
            }

        }
            break;
        case 2:{
            
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"enter"]!=nil) {
                changePasswordViewController * passWord = [[changePasswordViewController alloc] init];
                [self.navigationController pushViewController:passWord animated:YES];
            }else{
                
                [AlertTool alertMesasge:@"没有登录，请先登录" confirmHandler:nil viewController:self];
            }
            
           
        }
        default:
            break;
    }
    
}

-(void)createUserImageView{
    
    _changeImage = [[UIView alloc] init];
    _changeImage.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_changeImage];
    [_changeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(25);
        make.right.equalTo(self.view.mas_right).offset(-25);
        make.top.mas_equalTo(_userImage.mas_bottom);
        make.height.mas_equalTo(200);
    }];
    
    LNLabel * nameLabel = [LNLabel addLabelWithTitle:@"修改头像" TitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0  blue:51/255.0  alpha:1.0] Font:18 BackGroundColor:nil];
    
    [_changeImage addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_changeImage.mas_left).offset(15);
        make.right.equalTo(_changeImage.mas_right).offset(-15);
        make.top.mas_equalTo(_changeImage.mas_top).offset(20);
        make.height.mas_equalTo(50);
    }];
    
    LNLabel * wire = [LNLabel addLabelWithTitle:nil TitleColor:nil Font:13 BackGroundColor:[UIColor groupTableViewBackgroundColor]];
    
    [_changeImage addSubview:wire];
    [wire mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_changeImage.mas_left);
        make.right.equalTo(_changeImage.mas_right);
        make.top.mas_equalTo(nameLabel.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    LNButton * photographBtn = [LNButton buttonWithType:UIButtonTypeSystem Title:@"从相册选择" TitleColor:[UIColor blackColor] Font:18 Target:self AndAction:@selector(topick:)];
    photographBtn.tag = 45;
    [photographBtn.layer setBorderWidth:1.0];
    [photographBtn setTintColor:[UIColor colorWithRed:51/255.0 green:51/255.0  blue:51/255.0  alpha:1.0]];
    [photographBtn.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [_changeImage addSubview:photographBtn];
    [photographBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_changeImage.mas_left).offset(25);
        make.right.equalTo(_changeImage.mas_right).offset(-25);
        make.top.mas_equalTo(wire.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        
    }];
    
    LNButton * takePhoneBtn = [LNButton buttonWithType:UIButtonTypeSystem Title:@"重新拍一张" TitleColor:[UIColor blackColor] Font:18 Target:self AndAction:@selector(topick:)];
    takePhoneBtn.tag = 46;
    [takePhoneBtn.layer setBorderWidth:1.0];
    [takePhoneBtn setTintColor:[UIColor colorWithRed:51/255.0 green:51/255.0  blue:51/255.0  alpha:1.0]];
    [takePhoneBtn.layer setBorderColor:[UIColor groupTableViewBackgroundColor].CGColor];
    [_changeImage addSubview:takePhoneBtn];
    [takePhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_changeImage.mas_left).offset(25);
        make.right.equalTo(_changeImage.mas_right).offset(-25);
        make.top.mas_equalTo(photographBtn.mas_bottom).offset(20);
        make.height.mas_equalTo(40);
        
    }];
    
}

#pragma mark - 选取照片
-(void)topick:(UIButton *)button{
    
    // 从相册选取
    if (button.tag == 45) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:^{
            
        }];

        
        //相机选取
    }else{
      
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:^{
                
            }];
       
            
        }else{
            
            NSLog(@"该设备无摄像头");
        }
       
    }
}

//选完照片后调用
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //选择完照片 或者 照完相之后,会调用该方法,并且选择的图片或者刚照出来的图片都存在了info里
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        //如果刚才的图片是从相册里选的
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        NSData * imageData = UIImageJPEGRepresentation(image, 1);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"] ;
          [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"];
        _userImage.image = image;
        
    }else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        
        //如果刚才的图片是刚刚照出来的
        
        UIImage *image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        NSData * imageData = UIImageJPEGRepresentation(image, 1);
        [[NSUserDefaults standardUserDefaults] setObject:imageData forKey:@"image"] ;
        _userImage.image = image;
    }
    //选完之后 让相册消失
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    [_changeImage removeFromSuperview];
    UIView * shadeView = [self.view viewWithTag:70];
    [shadeView removeFromSuperview];

    
    
}
//取消选择照片调用
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    [_changeImage removeFromSuperview];
    UIView * shadeView = [self.view viewWithTag:70];
    [shadeView removeFromSuperview];
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
