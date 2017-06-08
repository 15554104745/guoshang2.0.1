//
//  AddGoodsViewController.m
//  guoshang
//
//  Created by JinLian on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "AddGoodsViewController.h"
#import "PhotoView.h"
#import "GoodsInformationView.h"
#import "RequestManager.h"
#import "AddGoodsView.h"
#import<AssetsLibrary/AssetsLibrary.h>
#import "SVProgressHUD.h"

@interface AddGoodsViewController () {
    
    UIScrollView *_scrollView;
    NSMutableArray *_dataList;
    NSArray *_data;
    NSArray *imageArr;
    NSDictionary *_passDic;
//    NSDictionary *imageDic;
    
}

@property (nonatomic, assign)NSInteger index;
@end

@implementation AddGoodsViewController


- (void)viewDidLoad {
    _dataList = [NSMutableArray array];
    [super viewDidLoad];
    
//    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
//
//    if (author == ALAuthorizationStatusNotDetermined || author == ALAuthorizationStatusRestricted){
//
//        //没有权限
//        [self alertView];
//    }
    
    
    [self createScrollView];
    [self createUI];
    [self createNavigationItem];
    
}

- (void)alertView {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请设置相册权限" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

}

- (void)createNavigationItem {
    
    //创建导航栏
    UIView *navBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    navBarView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:navBarView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((Width -100)*0.5 , 20, 100, 44)];
    titleLabel.text = @"添加商品";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [navBarView addSubview:titleLabel];
    
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 22, 40, 40)];
    leftBtn.tag = 807;
    [leftBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(addButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:leftBtn];
    
}

- (void)addButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createScrollView {
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, Width, Height-64)];
    [self.view addSubview:_scrollView];
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.contentSize = CGSizeMake(Width, Height + 200);
    
}
- (void)createUI {
    
    AddGoodsView *goodsView = [[AddGoodsView alloc]initWithFrame:CGRectMake(0, 0, Width, Height+200)];
    
    //获取信息
    [goodsView returnValue:^(NSDictionary *dataList) {
        
        _passDic = dataList;
        
        if (IsNilOrNull([dataList objectForKey:@"imageInfo"]) || IsNilOrNull([dataList objectForKey:@"imageName"])) {
            [self cretaAlertwith:@"图片信息不能为空"];
            return ;
        }
        
        if (IsNilOrNull([dataList objectForKey:@"goodsInformation"])) {
            [self cretaAlertwith:@"请补全商品信息"];
        }else {
            [self upload];
        }
        
    }];
    [_scrollView addSubview:goodsView];
}


- (void)cretaAlertwith:(NSString *)status {

    if ([status isEqualToString:@"产品添加成功"]) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:status preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
            
        }];
        
        [alertVC addAction:alertAction];
        [self presentViewController:alertVC animated:YES completion:nil];

    } else {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:status preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertVC addAction:alertAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        
    }
    

}

//压缩图片、只需传入图片要压缩后的宽度即可
-(UIImage *)imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    CGSize imageSize = sourceImage.size;
    
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = defineWidth;
    
    CGFloat targetHeight = (targetWidth / width) * height;
    
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    
    [sourceImage drawInRect:CGRectMake(0, 0, targetWidth, targetHeight)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (void)upload {
    
    [SVProgressHUD showWithStatus:@"正在上传..."];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    __block NSMutableString *imageInfoURLStr = [[NSMutableString alloc] initWithCapacity:0];
    __block NSMutableString *imageNameURLStr = [[NSMutableString alloc] initWithCapacity:0];
    dispatch_group_t getDataGroup = dispatch_group_create();
    
    NSArray *infoArr = [_passDic objectForKey:@"imageInfo"];
    dispatch_group_enter(getDataGroup);
    dispatch_apply(infoArr.count, dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL), ^(size_t index) {
        
        UIImage *image = [infoArr objectAtIndex:index];
        
        [[[RequestManager alloc]init]uploadImageWithImage:image completed:^(id responseObject, NSError *error) {
            
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            
            if (imageInfoURLStr.length > 0) {
                [imageInfoURLStr appendString:@"#"];
            }
            [imageInfoURLStr appendString:[dic objectForKey:@"image_url"]];

            if (index == infoArr.count - 1) {
                dispatch_group_leave(getDataGroup);
            }
        }];

    });

    NSArray *nameArr = [_passDic objectForKey:@"imageName"];
    dispatch_group_enter(getDataGroup);
    dispatch_apply(nameArr.count, dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL), ^(size_t index) {
        
        UIImage *image = [nameArr objectAtIndex:index];
        [[[RequestManager alloc]init]uploadImageWithImage:image completed:^(id responseObject, NSError *error) {
            
            NSDictionary *dic = [responseObject objectForKey:@"result"];
            if (imageNameURLStr.length > 0) {
                [imageNameURLStr appendString:@"#"];
            }
            [imageNameURLStr appendString:[dic objectForKey:@"image_url"]];
//            NSLog(@"%@",imageNameURLStr);
            if (index == nameArr.count - 1) {
                dispatch_group_leave(getDataGroup);
            }
        }];
        
    });
            
            
    dispatch_group_wait(getDataGroup, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSMutableDictionary *params = _passDic[@"goodsInformation"];
        [params setObject:[NSString stringWithString:imageNameURLStr] forKey:@"goods_image"];
        [params setObject:[NSString stringWithString:imageInfoURLStr] forKey:@"content_image"];
        [params setObject:GS_Business_Shop_id forKey:@"shop_id"];
        __weak typeof(self) weakSelf = self;
//        NSLog(@"%@",[params paramsDictionaryAddSaltString]);
        [HttpTool POST:URLDependByBaseURL(@"/Api/Shop/AddGoods")  parameters:@{@"token":[params paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *message = [responseObject objectForKey:@"message"];
                if (message.length == 0) {
                    message = [responseObject objectForKey:@"status"];
                }
                
                [weakSelf cretaAlertwith:message];
                [SVProgressHUD dismiss];
            });
        }
               failure:^(NSError *error) {
                   [SVProgressHUD dismiss];
//                   NSLog(@"-=-    %@",error);
               }];
        
    });
            
    });

}















@end
