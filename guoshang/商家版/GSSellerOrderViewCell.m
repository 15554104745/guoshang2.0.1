//
//  GSSellerOrderViewCell.m
//  guoshang
//
//  Created by 金联科技 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

 
#import "GSSellerOrderViewCell.h"
#import "UIImageView+WebCache.h"
@interface GSSellerOrderViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *goodsImabeVIew;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeInfoLabel;

@end

@implementation GSSellerOrderViewCell

static GSOrderInfoType _orderType;
# warning 加载问题--------
+(instancetype)orederCellWithTableView:(UITableView*)tableView withOrderType:(GSOrderInfoType)type{
    
    _orderType =type;
    
    return [[[NSBundle mainBundle] loadNibNamed:@"GSSellerOrderViewCell" owner:nil options:nil] lastObject];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
   
}


#pragma mark   ---------设置数据
-(void)setMyGoodsModel:(GSMyGoodModel *)myGoodsModel{
    _myGoodsModel = myGoodsModel;
    self.statusLabel.hidden = YES;
    self.consigneeInfoLabel.hidden = YES;
    
    //    标题
    _goodsName.text = [NSString stringWithFormat:@"%@",myGoodsModel.goods_name];
    //    数量
    _countLabel.text = [NSString stringWithFormat:@"x %@",myGoodsModel.goods_num];
    //    价格
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",myGoodsModel.goods_price];
    //    图片
    [_goodsImabeVIew sd_setImageWithURL:[NSURL URLWithString:myGoodsModel.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
}
-(void)setCustomGoodsModel:(GSCustomGoodsModel *)customGoodsModel{
    _customGoodsModel= customGoodsModel;
    //  标题
    _goodsName.text = [NSString stringWithFormat:@"%@",customGoodsModel.goods_name];
    //  价格
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",customGoodsModel.goods_price];
    //  数量
    _countLabel.text = [NSString stringWithFormat:@"x%@",customGoodsModel.goods_number];
    //   图片
    [_goodsImabeVIew sd_setImageWithURL:[NSURL URLWithString:customGoodsModel.goods_thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
}
//设置买家信息
-(void)setCustomOrderInfo:(NSDictionary *)customOrderInfo{
    _customOrderInfo = customOrderInfo;
    //    订单状态
    _statusLabel.text =customOrderInfo[@"orderStatus"];
    
    NSString *name =customOrderInfo[@"consignee"];
    
    NSString *tel =customOrderInfo[@"tel"];
    //    买家信息
    _consigneeInfoLabel.text = [NSString stringWithFormat:@"买家信息: %@ %@",name,tel];

}


@end
