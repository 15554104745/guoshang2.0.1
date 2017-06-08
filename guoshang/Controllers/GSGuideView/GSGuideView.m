//
//  GSGuideView.m
//  guoshang
//
//  Created by 宗丽娜 on 16/4/5.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGuideView.h"
#import "GSTabbarController.h"

@interface GSGuideView ()
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}
@end

@implementation GSGuideView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createContentView];
    [self createItems];
}
- (void)createContentView
{

    _scrollView = [[UIScrollView alloc] init];
    _scrollView.frame = self.view.bounds;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(Width * 4, Height);
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    

}
-(void)createItems{
    NSMutableArray *images = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSInteger multiple = (Height == 736) ? 3 : 2;

    NSString *imageString = [NSString stringWithFormat:@"%.0f - %.0f - ",(Width * multiple),(Height * multiple)];
    
    for (NSInteger i = 1; i <= 4; i ++) {
        [images addObject:[NSString stringWithFormat:@"%@%zi",imageString,i]];
    }
    
    for (int i = 0 ; i < images.count ; i++)
    {
        UIView *backView = [[UIView alloc] init];
        CGRect itemFrame = CGRectMake(Width * i, 0, Width, Height);
        backView.frame = itemFrame;
        [_scrollView addSubview:backView];
        NSString *imageName = images[i];
        UIImageView *imageItem = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, Height)];
        imageItem.image = [UIImage imageNamed:imageName];
        [backView addSubview:imageItem];
        
        if (i == 3) {
            UIButton  *commitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImage *iconImage = [UIImage imageNamed:@"icon_guide_experience"];
            [commitBtn setImage:iconImage forState:UIControlStateNormal];
            [commitBtn setImage:[UIImage imageNamed:@"icon_guide_experience_highlight"] forState:UIControlStateHighlighted];
            [commitBtn addTarget:self action:@selector(hideGuideView) forControlEvents:UIControlEventTouchUpInside];
            [backView addSubview:commitBtn];
            
            [commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(backView.mas_centerX).offset(0);
                make.bottom.offset(-(85 * (375.0/667.0)));
            }];
        }
    }
}

-(void)hideGuideView{
    [[NSUserDefaults standardUserDefaults] setObject:@"oneGuide" forKey:@"oneGuide"];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[GSTabbarController alloc] init]];
    nav.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication].delegate window].rootViewController = nav;
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    _pageControl.currentPage = scrollView.contentOffset.x / Width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
