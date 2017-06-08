//
//  GoodsListViewController.m
//  guoshang
//
//  Created by 宗丽娜 on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsListViewController.h"
#import "chooesViewController.h"
#import "breadViewController.h"
#import "EggViewController.h"
#import "DrinkViewController.h"
#import "VegetablesViewController.h"
#import "MoreViewController.h"
#import "OrderSelectView.h"
#import "Common.h"
#import "SVProgressHUD.h"
#import "GSStoreCategoryModel.h"
//需要在这里导入您要展示新闻界面的控制器 然后修改与其相对应的名字
//#import "HZYNewsListViewController.h"
@interface GoodsListViewController ()<HZYListTabBarDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{

    NSInteger recardIndex;
}
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic, strong) HZYListTabBar *listTabBar;
/**
 *  装有ViewController的ScrollView
 */
@property (nonatomic, weak) UIScrollView *contentScrollView;
/**
 *  当前viewController的索引
 */
@property (nonatomic, assign)NSInteger currentIndex;
/**
 *  用来存放listtabBar上item的标题和item对应界面请求数据的URL
 */
@property (nonatomic, strong) NSMutableArray *newsUrlList;

//@property (nonatomic, weak) UIImageView *imageView;
@end

@implementation GoodsListViewController
{
    UIImageView *_imageView;
       BOOL _isDone;//判断view的状态
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _isDone = NO;
    self.view.backgroundColor = [UIColor whiteColor];

    UIView * NAVVIEW = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 64)];
    NAVVIEW.backgroundColor = NewRedColor;
    UITextField * SearchTF = [[UITextField alloc]initWithFrame:CGRectMake(60, 25, Width-100, 30)];
    SearchTF.placeholder = @"棒球服";
       SearchTF.returnKeyType = UIReturnKeySearch;
    SearchTF.borderStyle = UITextBorderStyleRoundedRect;

    UIImageView *imageViewUserName=[[UIImageView alloc]initWithFrame:CGRectMake(20, 0, 15, 15)];
    imageViewUserName.image=[UIImage imageNamed:@"fangdajing"];
    SearchTF.leftView=imageViewUserName;
    SearchTF.delegate = self;
    SearchTF.leftViewMode=UITextFieldViewModeAlways; //此处用来设置leftview现实时机
    SearchTF.backgroundColor  = [UIColor whiteColor];
    UIButton * BT = [[UIButton alloc]initWithFrame:CGRectMake(15, 30, 15, 15)];
    [BT addTarget:self action:@selector(BACK) forControlEvents:UIControlEventTouchUpInside];
    [BT setBackgroundImage:[UIImage imageNamed:@"back_jt@3x"] forState:0];
    [NAVVIEW addSubview:BT];
    [NAVVIEW addSubview:SearchTF];
    [self.view addSubview:NAVVIEW];
    self.newsUrlList = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.dataArr.count; i++) {
        GSStoreCategoryModel * model = self.dataArr[i];
//        NSLog(@"%@",model.category_title);
        NSMutableDictionary * dic  = [[NSMutableDictionary alloc]init];
        [dic setValue:model.category_title forKey:@"title"];
         [dic setValue:model.category_id forKey:@"urlString"];
         [dic setValue:model.shop_id forKey:@"shopid"];
        [self.newsUrlList addObject:dic];
    }
    [self initSubView];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //_keyword = textField.text;
   // [_dataSourceArray removeAllObjects];
    chooesViewController * vc =  self.childViewControllers[recardIndex];
    [vc search:textField.text];

   
//    NSLog(@"%d",recardIndex);
    [textField resignFirstResponder];

  //  [self getDataWithKeyWord:textField.text page:@"1"];

    return YES;
}
-(void)BACK

{
    [self.navigationController popViewControllerAnimated:YES];
}
//- (NSArray *)newsUrlList{
//
//    if (_newsUrlList == nil) {
//
//        _newsUrlList = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NewsUrl.plist" ofType:nil]];
//    }
//
//    return _newsUrlList;
//}
- (void)initSubView{

    self.automaticallyAdjustsScrollViewInsets = NO;
    //设置能够滑动的listTabBar
    self.listTabBar = [[HZYListTabBar alloc] initWithFrame:CGRectMake(0, kNavY, kScreenSize.width, kListTabBarH)];
    self.listTabBar.delegate = self;


    //这句代码调用了HZYListTabBar的 setitemsTitle 方法  会到HZYListTabBar里设置数据
    self.listTabBar.itemsTitle = self.newsUrlList;
    [self.view addSubview:self.listTabBar];

    //添加能滚动显示ViewController的ScrollView
    CGFloat scroolY = CGRectGetMaxY(self.listTabBar.frame);
    CGFloat scroolH = kScreenSize.height - scroolY;

    UIScrollView *contentScroolView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, scroolY, kScreenSize.width, scroolH)];

    contentScroolView.showsHorizontalScrollIndicator = NO;
    contentScroolView.delegate = self;

    //设置scrollView能够分页
    contentScroolView.pagingEnabled = YES;
    //关闭scrollView的弹簧效果
    contentScroolView.bounces = NO;
    contentScroolView.backgroundColor = [UIColor whiteColor];

    self.contentScrollView = contentScroolView;
    [self.view addSubview:self.contentScrollView];

    //添加子控制器
    [self addChildViewControllers];

    self.contentScrollView.contentSize = CGSizeMake(kScreenSize.width * self.childViewControllers.count,0);

    //添加默认显示的控制器
    chooesViewController *newsVc = [self.childViewControllers firstObject];
    newsVc.view.frame = self.contentScrollView.bounds;
    [self.contentScrollView addSubview:newsVc.view];

}
- (void)addChildViewControllers{

    for (int i = 0; i < self.newsUrlList.count; i ++) {

        chooesViewController*vc = [[chooesViewController alloc] init];
        vc.title = self.newsUrlList[i][kPlistTitle];
        vc.classid = self.newsUrlList[i][kPlistUrlString];
  vc.shopid =self.newsUrlList[i][@"shopid"];
        [self addChildViewController:vc];
    }


}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.index) {
        self.listTabBar.currentItemIndex = self.index;
        recardIndex = self.index;
        [self.contentScrollView setContentOffset:CGPointMake(self.index* kScreenSize.width, 0) animated:YES];
    }
    else
    {
        recardIndex = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- scrollView 的代理方法 --

/**
 *  scrollView 滚动时调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    //当scrollView滑动超过了屏幕一半时就让它进入下一个界面
    self.currentIndex = scrollView.contentOffset.x / kScreenSize.width + 0.5;

}

/**
 *  scrollView 动画滚动结束时调用  只有通过代码（设置contentOfset）使scrollView停止滚动才会调用
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{

    //这句代码调用了HZYListTabBar的 setCurrentItemIndex 方法  会到HZYListTabBar里设置数据
    self.listTabBar.currentItemIndex = self.currentIndex;

    chooesViewController *vc = self.childViewControllers[self.currentIndex];
    //如果当前试图控制器的View已经加载过了,就直接返回,不会重新加载了（这句代码很重要）
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = scrollView.bounds;
    [self.contentScrollView addSubview:vc.view];
}

/**
 *  这个是由手势导致scrollView滚动结束调用（减速）(不实现这个代理方法用手滑scrollView并不会加载控制器)
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    [self scrollViewDidEndScrollingAnimation:scrollView];
}

#pragma mark -- HZYListTabBar的代理方法 --
- (void)listTabBar:(HZYListTabBar *)listTabBar didSelectedItemIndex:(NSInteger)index{

    recardIndex = index;
    [self.contentScrollView setContentOffset:CGPointMake(index * kScreenSize.width, 0) animated:YES];
}

- (void)listTabBarDidClickedArrowButton:(HZYListTabBar *)listTabBar{

//    listTabBar.currentItemIndex = 3;
//    [self.contentScrollView setContentOffset:CGPointMake(3 * kScreenSize.width, 0) animated:YES];
    [self popView];

}

-(void)createButtonPopView{

    _imageView =[[UIImageView alloc]initWithFrame:CGRectMake(0, self.listTabBar.endPointY, Width, 180)];
    _imageView.backgroundColor =[UIColor whiteColor];
    _imageView.userInteractionEnabled = NO;
    [_imageView setUserInteractionEnabled:YES];
    for (int i = 0; i<self.newsUrlList.count; i++) {

        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        // 设置边框
        btn.layer.borderColor = [UIColor grayColor].CGColor;
        btn.layer.borderWidth = 0.5f;
        // 绘制圆角
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = YES;

        btn.frame=CGRectMake((i % 4) * (Width/ 4)+5, (i /4) * 30+20, Width/4-15, 20);
        [btn setTitle:self.newsUrlList[i][kPlistTitle] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor grayColor]  forState:UIControlStateNormal];
        btn.titleLabel.tintColor=[UIColor grayColor];
        btn.titleLabel.font=[UIFont systemFontOfSize:15];

        [btn setTitleColor:[UIColor grayColor] forState:UIControlStateSelected];
        btn.tag=i;
        if(i==0)
        {
            [btn setSelected:YES];
            btn.titleLabel.font=[UIFont systemFontOfSize:15];

        }
        [btn addTarget:self action:@selector(titleNameClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_scrarray addObject:btn];
        [_imageView addSubview:btn];
    }
    self.view.userInteractionEnabled =YES;
//    _imageView.backgroundColor = [UIColor blackColor];
//    _isDone = NO;
    [self.view addSubview:_imageView];
}
-(void)titleNameClick:(UIButton*)BT
{
//    NSLog(@"%ld,",(long)BT.tag);
    recardIndex = BT.tag;
        _listTabBar.currentItemIndex = BT.tag;
        [self.contentScrollView setContentOffset:CGPointMake(BT.tag * kScreenSize.width, 0) animated:YES];
     _isDone =!_isDone;
      _imageView.frame =CGRectMake(0, -200, Width, 180);
}

-(void)popView{
    _isDone =!_isDone;
    if (_isDone==NO) {

        _imageView.frame =CGRectMake(0, -200, Width, 180);

//        NSLog(@"收起");
//        [_imageView removeFromSuperview];
//        [self createButtonPopView];
    }else{

//        NSLog(@"展开");

        [self createButtonPopView];
    }
}


////更多里面按钮点击事件
//-(void)titleNameClick:(UIButton *)button
//{
//
//}


#pragma mark - Navigation



@end
