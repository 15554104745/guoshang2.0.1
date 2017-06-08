//
//  ChooseView.m
//  Demo
//
//  Created by JinLian on 16/8/9.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import "ChooseView.h"
#import "TypeView.h"
#import "UIView+UIViewController.h"
#import "UIImageView+WebCache.h"
#import "GoodsDetailGoodsInfoModel.h"

@implementation ChooseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

-(void)setDataList:(NSDictionary *)dataList {
    
    _dataList = dataList;
    
    [self creatSubView];
    
}
- (void)buttonActionabc {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"buttonCancel" object:self];
}
/**
 *  创建商品属性选择视图
 */
- (void)creatSubView {
    
    GoodsDetailGoodsInfoModel *model = [_dataList objectForKey:@"goodsInfo"];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    //商品图片
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(10, -20, 100, 100)];
    [_img sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    _img.backgroundColor = [UIColor yellowColor];
    _img.layer.cornerRadius = 4;
    _img.layer.borderColor = [UIColor whiteColor].CGColor;
    _img.layer.borderWidth = 5;
    _img.contentMode = UIViewContentModeScaleAspectFill;
    [_img.layer setMasksToBounds:YES];
    [self addSubview:_img];
    
    //退出商品属性选择
    _bt_cancle= [UIButton buttonWithType:UIButtonTypeCustom];
    _bt_cancle.frame = CGRectMake(self.frame.size.width-40, 10,30, 30);
    [_bt_cancle setBackgroundImage:[UIImage imageNamed:@"close"] forState:0];
    [self addSubview:_bt_cancle];
    [_bt_cancle addTarget:self action:@selector(buttonActionabc) forControlEvents:UIControlEventTouchUpInside];
    
    //商品价格
    _lb_price = [[UILabel alloc] initWithFrame:CGRectMake(_img.frame.origin.x+_img.frame.size.width+20, 10, self.frame.size.width-(_img.frame.origin.x+_img.frame.size.width+40+40), 20)];
    _lb_price.textColor = [UIColor redColor];
    _lb_price.text = model.shop_price_formated;
    _lb_price.font = [UIFont systemFontOfSize:14];
    [self addSubview:_lb_price];
    
    //商品库存
    _lb_stock = [[UILabel alloc] initWithFrame:CGRectMake(_img.frame.origin.x+_img.frame.size.width+20, _lb_price.frame.origin.y+_lb_price.frame.size.height, self.frame.size.width-(_img.frame.origin.x+_img.frame.size.width+40+40), 20)];
    _lb_stock.textColor = [UIColor blackColor];
    _lb_stock.font = [UIFont systemFontOfSize:14];
    _lb_stock.text = model.goods_number;
    [self addSubview:_lb_stock];
    
    //用户所选择商品的尺码和颜色
    _lb_detail = [[UILabel alloc] initWithFrame:CGRectMake(_img.frame.origin.x+_img.frame.size.width+20, _lb_stock.frame.origin.y+_lb_stock.frame.size.height, self.frame.size.width-(_img.frame.origin.x+_img.frame.size.width+40+40), 40)];
    _lb_detail.numberOfLines = 2;
    _lb_detail.textColor = [UIColor blackColor];
    _lb_detail.font = [UIFont systemFontOfSize:14];
    [self addSubview:_lb_detail];
    
    //分界线
    _lb_line = [[UILabel alloc] initWithFrame:CGRectMake(0, _img.frame.origin.y+_img.frame.size.height+20, self.frame.size.width, 0.5)];
    _lb_line.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:_lb_line];
    
    //加入购物车
    _bt_sure= [UIButton buttonWithType:UIButtonTypeCustom];
    _bt_sure.frame = CGRectMake(0, self.frame.size.height-44,self.frame.size.width/2, 44);
    [_bt_sure setBackgroundColor:[UIColor colorWithRed:252/255.0 green:168/255.0 blue:44/255.0 alpha:1]];
    [_bt_sure setTitleColor:[UIColor whiteColor] forState:0];
    _bt_sure.titleLabel.font = [UIFont systemFontOfSize:20];
    [_bt_sure setTitle:@"取消" forState:0];
    [self addSubview:_bt_sure];
    
    //立即购买
    _bt_buyNew= [UIButton buttonWithType:UIButtonTypeCustom];
    _bt_buyNew.frame = CGRectMake(self.frame.size.width/2, self.frame.size.height-44,self.frame.size.width/2, 44);
    [_bt_buyNew setBackgroundColor:[UIColor colorWithRed:255/255.0 green:39/255.0 blue:66/255.0 alpha:1]];
    [_bt_buyNew setTitleColor:[UIColor whiteColor] forState:0];
    _bt_buyNew.titleLabel.font = [UIFont systemFontOfSize:20];
    [_bt_buyNew setTitle:@"确定" forState:0];
    [self addSubview:_bt_buyNew];
    
    //有的商品尺码和颜色分类特别多 所以用UIScrollView 分类过多显示不全的时候可滑动查看
    _mainscrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _lb_line.frame.origin.y+_lb_line.frame.size.height, self.frame.size.width, _bt_sure.frame.origin.y-(_lb_line.frame.origin.y+_lb_line.frame.size.height))];
    _mainscrollview.showsHorizontalScrollIndicator = NO;
    _mainscrollview.showsVerticalScrollIndicator = NO;
    [self addSubview:_mainscrollview];
    
    //购买数量的视图
    _countView = [[BuyCountView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [_mainscrollview addSubview:_countView];
    [_countView.bt_add addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    _countView.tf_count.delegate = self;
    [_countView.bt_reduce addTarget:self action:@selector(reduce) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)tapAction {
    
    _mainscrollview.contentOffset = CGPointMake(0, 0);
    [_countView.tf_count resignFirstResponder];
    
}

-(void)add
{
    int count =[_countView.tf_count.text intValue];
    if (count < self.stock) {
        _countView.tf_count.text = [NSString stringWithFormat:@"%d",count+1];
        NSString *str =  [_lb_price.text substringFromIndex:1];
//        NSLog(@"%d",count);
        float price = ([str floatValue]/count) * (count+1);
        _lb_price.text = [NSString stringWithFormat:@"￥%.2f",price];
    }else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"库存不足" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    
}
-(void)reduce
{
    int count =[_countView.tf_count.text intValue];
    if (count > 1) {
        _countView.tf_count.text = [NSString stringWithFormat:@"%d",count-1];
        NSString *str =  [_lb_price.text substringFromIndex:1];
        float price = ([str floatValue]/count) * (count-1);
        _lb_price.text = [NSString stringWithFormat:@"￥%.2f",price];
    }
}




@end
