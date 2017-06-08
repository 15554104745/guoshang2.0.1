//
//  AddGoodsView.m
//  guoshang
//
//  Created by 孙涛 on 16/9/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "AddGoodsView.h"
#import "PhotoView.h"
#import "GoodsInformationView.h"
#import "CategoryViewController.h"
#import "RequestManager.h"
#import "CateGoryView.h"
#import "UIView+UIViewController.h"

#define color [UIColor colorWithRed:229/255.0f green:229/255.0f blue:229/255.0f alpha:1.0f]

@implementation AddGoodsView {
    
    NSArray *_data;
    __block NSString *categoryStr;
    __block NSString *shopIDStr;
    
    
    NSDictionary * imageDic;
    UIButton *terracebutton;  //分类按钮
    UIButton *shop_button;  //分类按钮
    PhotoView *phototView;
    CateGoryView *cateView;
    GoodsInformationView *goodsView;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        _addGoodsDic = [[NSMutableDictionary alloc]init];
        
        [self createUI];
        //获取通知中心
        NSNotificationCenter * center =[NSNotificationCenter defaultCenter];
        
        //添加观察者 Observer表示观察者  reciveNotice:表示接收到的消息  name表示再通知中心注册的通知名  object表示可以相应的对象 为nil的话表示所有对象都可以相应
        [center addObserver:self selector:@selector(reciveNotice:) name:@"notice" object:nil];
        [center addObserver:self selector:@selector(reciveNoticeShopID:) name:@"noticeShopID" object:nil];
    }
    return self;
}

- (void)reciveNoticeShopID:(NSNotification *)notification {
    NSString *str = [NSString stringWithFormat:@"商铺分类  %@",[notification.userInfo objectForKey:@"text"]];
    [shop_button setTitle:str forState:UIControlStateNormal];
    
}

- (void)reciveNotice:(NSNotification *)notification{
    
    NSString *str = [NSString stringWithFormat:@"平台分类  %@",[notification.userInfo objectForKey:@"text"]];
    
    [terracebutton setTitle:str forState:UIControlStateNormal];
    
}

- (void)returnValue:(passAllValueBlock)block {
    _block = block;
}

- (void)createUI {
    
    LNLabel  *searchImageLB = [LNLabel addLabelWithTitle:@"选择图片"TitleColor:[UIColor blackColor] Font:12  BackGroundColor:[UIColor clearColor]];
    [self addSubview:searchImageLB];
    [searchImageLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"选择图片" AndFont:14]);
    }];
    
    LNLabel  *searchImageLBsubhearding = [LNLabel addLabelWithTitle:@"显示在首页大图位置，最多上传5张"TitleColor:[UIColor grayColor] Font:12  BackGroundColor:[UIColor clearColor]];
    [self addSubview:searchImageLBsubhearding];
    [searchImageLBsubhearding mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(searchImageLB.mas_bottom);
        make.left.equalTo(searchImageLB.mas_right).offset(5);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"显示在首页大图位置，最多上传5张" AndFont:12]);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchImageLB.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@1);
    }];
    
    //加载图片选择视图
    UIScrollView *scrollview = [[UIScrollView alloc]init];
    scrollview.showsHorizontalScrollIndicator = NO;
    scrollview.bounces = NO;
    [self addSubview:scrollview];
    scrollview.contentSize = CGSizeMake(Width + 200, 100);
    [scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@100);
    }];
    
#pragma mark - 图片选择
    if (phototView) {
        
    }else {
        phototView = [[PhotoView alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    }
    [phototView returnValueWithBlock:^(NSArray *arr) {
        [_addGoodsDic setValue:arr forKey:@"imageName"];
        
    }];
    phototView.backgroundColor = [UIColor whiteColor];
    [scrollview addSubview:phototView];
    
    UILabel  *lab1 = [[UILabel alloc]init];
    lab1.backgroundColor = color;
    [self addSubview:lab1];
    [lab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollview.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@10);
    }];
    
    LNLabel  *informationLab = [LNLabel addLabelWithTitle:@"详情描述"TitleColor:[UIColor blackColor] Font:12  BackGroundColor:[UIColor clearColor]];
    [self addSubview:informationLab];
    [informationLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab1.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(20);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:@"详情描述" AndFont:14]);
    }];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"xuxian"]];
    [self addSubview:imageView2];
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(informationLab.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@1);
    }];
    
    //加载图片选择视图
    UIScrollView *scrollview2 = [[UIScrollView alloc]init];
    scrollview2.showsHorizontalScrollIndicator = NO;
    scrollview2.bounces = NO;
    [self addSubview:scrollview2];
    scrollview2.contentSize = CGSizeMake(Width + 200, 100);
    [scrollview2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView2.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@100);
    }];
    PhotoView *phototView2 = [[PhotoView alloc] initWithFrame:CGRectMake(0,0, 0, 0)];
    [phototView2 returnValueWithBlock:^(NSArray *arr) {
        
        [_addGoodsDic setValue:arr forKey:@"imageInfo"];
        
    }];
    phototView2.backgroundColor = [UIColor whiteColor];
    [scrollview2 addSubview:phototView2];
    
    
    UILabel  *lab2 = [[UILabel alloc]init];
    lab2.backgroundColor = color;
    [self addSubview:lab2];
    [lab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollview2.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(5);
        make.right.equalTo(self.mas_right).offset(-5);
        make.height.equalTo(@10);
    }];
    
    
    
    goodsView = [[[NSBundle mainBundle]loadNibNamed:@"GoodsInformation" owner:nil options:nil]lastObject];
    [goodsView returnVale:^(NSDictionary *dic) {
        
        [_addGoodsDic setObject:dic forKey:@"goodsInformation"];
        
    }];
    [self addSubview:goodsView];
    [goodsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lab2.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@194);
    }];
    
    
    terracebutton = [[UIButton alloc]init];
    terracebutton.tag = 9001;
    terracebutton.backgroundColor = color;
    [terracebutton addTarget:self action:@selector(viewbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:terracebutton];
    terracebutton.titleLabel.font = [UIFont systemFontOfSize:14];
    terracebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [terracebutton setTitle:@"平台分类" forState:UIControlStateNormal];
    [terracebutton setImage:[UIImage imageNamed:@"chimaxuanze"] forState:UIControlStateNormal];
    [terracebutton setImageEdgeInsets:UIEdgeInsetsMake(0, Width-20, 0, 0)];
    [terracebutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodsView.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@30);
    }];
    
    
    shop_button = [[UIButton alloc]init];
    shop_button.tag = 9003;
    shop_button.backgroundColor = color;
    [shop_button addTarget:self action:@selector(viewbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shop_button];
    shop_button.titleLabel.font = [UIFont systemFontOfSize:14];
    shop_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [shop_button setTitle:@"店铺分类" forState:UIControlStateNormal];
    [shop_button setImage:[UIImage imageNamed:@"chimaxuanze"] forState:UIControlStateNormal];
    [shop_button setImageEdgeInsets:UIEdgeInsetsMake(0, Width-20, 0, 0)];
    [shop_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(terracebutton.mas_bottom).offset(5 );
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@30);
        
    }];
    
    
    UIButton *uploadBut = [[UIButton alloc]init];
    uploadBut.tag = 9002;
    [uploadBut setBackgroundColor:[UIColor redColor]];
    uploadBut.layer.cornerRadius = 5;
    uploadBut.clipsToBounds = YES;
    [uploadBut addTarget:self action:@selector(viewbuttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:uploadBut];
    [uploadBut setTitle:@"确认添加" forState:UIControlStateNormal];
    [uploadBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(terracebutton.mas_bottom).offset(50);
        make.width.equalTo(@90);
        make.height.equalTo(@30);
    }];
    
    
}



- (void)viewbuttonAction:(UIButton *)sender {
    
    [goodsView passValue];
    
    NSInteger index = sender.tag - 9000;
    switch (index) {
        case 1:{  //平台分类
            shop_button.userInteractionEnabled = NO;
            terracebutton.userInteractionEnabled = NO;
            [self showPickerViewWith:1];
        }
            break;
            
        case 2:{
            if (categoryStr != nil) {
                
                [[_addGoodsDic objectForKey:@"goodsInformation"] setObject:categoryStr forKey:@"category_id"];
                [[_addGoodsDic objectForKey:@"goodsInformation"] setObject:shopIDStr forKey:@"shop_cat_id"];
            }
            _block(_addGoodsDic);
            
        }
            break;
            
        case 3: {
            shop_button.userInteractionEnabled = NO;
            terracebutton.userInteractionEnabled = NO;
            [self showPickerViewWith:3];
        }
            break;
        default:
            break;
    }
    
}

- (void)showPickerViewWith:(NSInteger)tag {
    
    if (tag == 1) {
        [self createPickerView1];
        
    }else if (tag == 3) {
        
        [self createPickerView2];
    }
    
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGAffineTransform transForm = cateView.transform;
        cateView.transform = CGAffineTransformTranslate(transForm, 0, -170);
        
    } completion:^(BOOL finished) {
    }];
}

//平台分类
- (void)createPickerView1 {
    __weak typeof(self) weakSelf = self;
    
    cateView = [[CateGoryView alloc]initWithFrame:CGRectMake(0, self.viewController.view.bounds.size.height, self.viewController.view.bounds.size.width, 170) withCateType:cateTypeOfdefault];
    
    [cateView returnValue:^(NSString *shopID) {
        categoryStr = shopID;
        [weakSelf dismissPickerView];
    }];
    
    cateView.dismissBlock = ^() {
        [weakSelf dismissPickerView];
    };
    
    [self.viewController.view addSubview:cateView];
    
}
//商铺分类
- (void)createPickerView2 {
    __weak typeof(self) weakSelf = self;
    
    cateView = [[CateGoryView alloc]initWithFrame:CGRectMake(0, self.viewController.view.bounds.size.height, self.viewController.view.bounds.size.width, 170) withCateType:cateTypeOfshopCate];
    
    [cateView returnValue:^(NSString *shopID) {
        shopIDStr = shopID;
        [weakSelf dismissPickerView];
    }];
    
    cateView.dismissBlock = ^() {
        [weakSelf dismissPickerView];
    };
    
    [self.viewController.view addSubview:cateView];
    
}


- (void)dismissPickerView {
    
    shop_button.userInteractionEnabled = YES;
    terracebutton.userInteractionEnabled = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        CGAffineTransform transform = cateView.transform;
        cateView.transform = CGAffineTransformTranslate(transform, 0, 170);
        
    } completion:^(BOOL finished) {
        
        [cateView removeFromSuperview];
    }];
    
}



@end



