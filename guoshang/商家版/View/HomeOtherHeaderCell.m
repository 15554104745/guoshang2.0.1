//
//  HomeOtherHeaderCell.m
//  guoshang
//
//  Created by 宗丽娜 on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "HomeOtherHeaderCell.h"

@implementation HomeOtherHeaderCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        
    }
    return self;
}
-(void)setBannerArray:(NSMutableArray *)bannerArray{
    
    _bannerArray = bannerArray;
    [self createUI];
  
    
}
-(void)createUI{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, self.frame.size.height)];
    _View = view;
    _View.backgroundColor = MyColor;
    _View.userInteractionEnabled = YES;
    [self addSubview:_View];
    if (_bannerArray.count>0) {
        ImagesScrollView * sc = [[ImagesScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, JHHeight-30)];
        sc.isLoop = YES;
        sc.autoScrollInterval = 2;
        sc.delegate = self;
        
        sc.placeholderImage = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
        [_View addSubview:sc];
    }else {
        UIImageView *secondImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, Width, JHHeight-30)];
        secondImageView.image = [UIImage imageNamed:@"ic_load_image_pleaceholder"];
        [_View addSubview:secondImageView];
    }
    
    
    LNLabel * titleLabel = [LNLabel addLabelWithTitle:@"精品推荐" TitleColor:WordColor Font:16.0f BackGroundColor:[UIColor clearColor]];
    
    titleLabel.frame = CGRectMake(10, JHHeight-30, self.frame.size.width, 30);
    
    [_View addSubview:titleLabel];
}


-(NSInteger)numberOfImagesInImagesScrollView:(ImagesScrollView *)imagesScrollView{
//    NSLog(@"1%ld",_bannerArray.count);
    return _bannerArray.count;

}


//填充图片
-(NSString *)imagesScrollView:(ImagesScrollView *)imagesScrollView imageUrlStringWithIndex:(NSInteger)index{
//    HomeModel * model = _bannerArr[index];
    
//    NSLog(@"首页轮播的图片数据%@",_bannerArray[index]);
    
    return _bannerArray[index];
    
    
}


-(void)imagesScrollView:(ImagesScrollView *)imagesScrollView didSelectIndex:(NSInteger)index{
    //    HomeModel * model = _bannerArr[index];
    //    if ([model.type isEqualToString:@"goods_id"]) {
    //        //调到商品详情
    //        GoodsShowViewController * goods = [[GoodsShowViewController alloc] init];
    //        goods.goodId = model.params;
    //        goods.hidesBottomBarWhenPushed = YES;
    //        [self.popView.navigationController pushViewController:goods animated:YES];
    //
    //    }else if ([model.type isEqualToString:@"salegoods"]){
    //        LimitViewController * limit = [[LimitViewController alloc] init];
    //        limit.hidesBottomBarWhenPushed = YES;
    //        [self.popView.navigationController pushViewController:limit animated:YES];
    //
    //    }
    
//    NSLog(@"轮播图的跳转");
    //
}

@end
