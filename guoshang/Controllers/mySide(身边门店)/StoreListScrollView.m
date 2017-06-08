//
//  StoreListScrollView.m
//  guoshang
//
//  Created by 大菠萝 on 16/7/22.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "StoreListScrollView.h"

@interface StoreListScrollView ()<UIScrollViewDelegate>

//当前页数
@property (nonatomic,assign)int page;
//全局变量形式的图片数组
@property (nonatomic,strong)NSArray * array;

@end


@implementation StoreListScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame AndPicArray:(NSArray *)picArr{
    if (self = [super initWithFrame:frame]) {
        //初始化
       self.page = 0;
       self.array = picArr;
        //创建滚动视图
        float width = frame.size.width;
        float height = frame.size.height;
        self.mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
        self.mainScrollView.pagingEnabled = YES;
        self.mainScrollView.showsHorizontalScrollIndicator = NO;
        self.mainScrollView.showsVerticalScrollIndicator = NO;
        //滚动视图可以显示的大小
        self.mainScrollView.contentSize = CGSizeMake(width * picArr.count, height);
        self.mainScrollView.bounces = NO;
        //建立代理连接
        self.mainScrollView.delegate = self;
        [self addSubview:self.mainScrollView];
        //创建广告页
        for (int i = 0; i < picArr.count; i++) {
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(width * i, 0, width, height)];
            imageView.backgroundColor=[UIColor redColor];
            [self.mainScrollView addSubview:imageView];
            imageView.backgroundColor=[UIColor yellowColor];
            //给予图片
            StoreListScrollModel * model = picArr[i];
            //得到图片网址
            NSString * picUrl = model.shoplogo;
        
             [imageView setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@""]];
            imageView.image=picArr[i];
            //添加手势
            //开启用户交互
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDown:)];
            [imageView addGestureRecognizer:tap];
           
            imageView.tag = 100 + i;
        
          
                 }
        //添加分页控制器
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(width - 100, height - 50, 80, 20)];
        self.pageControl.numberOfPages = picArr.count;
        self.pageControl.currentPage = 0;
        self.pageControl.currentPageIndicatorTintColor = [UIColor greenColor];
        [self.pageControl addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.pageControl];
        //滚动轮播功能
        NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timeRefresh:) userInfo:nil repeats:YES];
        //定时器关闭
        [timer setFireDate:[NSDate distantFuture]];
        //定时器开启
        [timer setFireDate:[NSDate distantPast]];
        
    }
    return self;
    
}

- (void)tapDown:(UITapGestureRecognizer*)tap{
    
}

    - (void)timeRefresh:(NSTimer*)timer{
        self.pageControl.currentPage = self.page;
       
        //更改ScrollView偏移量
        self.mainScrollView.contentOffset = CGPointMake(self.page * self.frame.size.width, 0);
        self.page++;
        if (self.page == self.array.count) {
            //重置页数
            self.page = 0;
        }
    }
    - (void)pageChange:(UIPageControl*)pageControl{
        //重置ScrollView偏移量
        /*
         self.mainScrollView.contentOffset = CGPointMake(pageControl.currentPage * self.frame.size.width, 0);
         */
        //动态效果
        float width = self.frame.size.width;
        float height = self.frame.size.height;
        [self.mainScrollView scrollRectToVisible:CGRectMake(pageControl.currentPage * width, 0, width, height) animated:YES];
    }
#pragma mark ScrollViewDel
    //停止减速
    - (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
        //更新页数
        float width = self.frame.size.width;
        self.pageControl.currentPage = scrollView.contentOffset.x / width;
    }
    



@end
