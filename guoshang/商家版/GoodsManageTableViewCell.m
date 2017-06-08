//
//  GoodsManageTableViewCell.m
//  guoshang
//
//  Created by 孙涛 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GoodsManageTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
@implementation GoodsManageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _goods_Upsell.layer.cornerRadius = 5;
    _goods_Upsell.layer.masksToBounds = YES;
    
}


- (void)setModel:(GoodsManageModel *)model {
    
    _model = model;
    
    self.goods_addtime.text = [NSString stringWithFormat:@"添加时间:%@",model.add_time];

    self.goods_name.text = model.goods_name;
    self.goods_price.text = [NSString stringWithFormat:@"￥:%@",model.shop_price];
    self.goods_inventory.text =  [NSString stringWithFormat:@"库存:%@",model.goods_number]; //库存
    [self.goods_image sd_setImageWithURL:[NSURL URLWithString:model.goods_img]placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    
    NSString *oldStr = [NSString stringWithFormat:@"￥:%@",model.market_price];
    NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:oldStr];
    NSUInteger length = [oldStr length];
    
    [attriStr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    
    [attriStr addAttribute:NSStrikethroughColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, length)];
    [self.goods_oldPrice setAttributedText:attriStr];
    
    if (model.sale_num == nil || model.sale_num == NULL) {
        model.sale_num = [NSString stringWithFormat:@"0"];
    }
    self.goods_sellcount.text = [NSString stringWithFormat:@"销量:%@",model.sale_num];
    self.goods_saveCount.text = [NSString stringWithFormat:@"收藏:%@",model.collect_num];

    
    //商品的审核状态  暂时不添加
    self.goods_stats.text = [NSString stringWithFormat:@"审核状态:%@",model.is_check_desc];
  /*
    @property (weak, nonatomic) IBOutlet UIImageView *goods_image;
    @property (weak, nonatomic) IBOutlet UILabel *goods_sellcount;
    @property (weak, nonatomic) IBOutlet UILabel *goods_saveCount;
    @property (weak, nonatomic) IBOutlet UILabel *goods_stats;
    @property (weak, nonatomic) IBOutlet UIImageView *goods_rightImage;
    @property (weak, nonatomic) IBOutlet UILabel *goods_inventory;
   */
    
    
    /*
     "add_time" = "2016-07-23";
     "goods_img" = "http://192.168.1.168/Apis/Uploads/20160723/579318f19fa08.jpeg";
     "goods_name" = "\U5f20\U4e09";
     "goods_number" = 100;
     "goods_thumb" = "http://192.168.1.168/Apis/Uploads/20160723/579318f19fa08.jpeg";
     "is_on_sale" = 1;
     "market_price" = "10.00";
     "original_img" = "http://192.168.1.168/Apis/Uploads/20160723/579318f19fa08.jpeg";
     "sale_number" = 0;
     "shop_price" = "15.00";
     
     */
    
    if ([_model.enable_onsale isEqual:@"Y"] || [_model.is_on_sale isEqual:@"0"]) {//可上架；不隐藏
        _goods_Upsell.hidden = NO;
    }else {
        _goods_Upsell.hidden = YES;
    }
}



- (IBAction)goodsSellButtonClick:(UIButton *)sender {
//    NSLog(@"%@======%@",_model.goods_name,_model.goods_id);
    
    if (! IsNilOrNull(_model.goods_id) && [_model.enable_onsale isEqual:@"Y"]) {
        //库存列表
        [self loadDataWithParams:@"/Api/Shop/setStockGoodsOnSale"];
    }else if ([_model.is_on_sale isEqual:@"0"]){
        //下架列表
       [self loadDataWithParams:@"/Api/Shop/BatchOnSale"];
    }else {
         [SVProgressHUD showErrorWithStatus:@"该商品不存在"];
    }
}
/**
 *  上架
 */
- (void)loadDataWithParams:(NSString *)url{
    
    NSDictionary *paramsDic = @{@"shop_id":GS_Business_Shop_id,
             @"goods_id":_model.goods_id
             };
    if (UserId) {
        __weak typeof(self) weakSelf = self;
        [HttpTool POST:URLDependByBaseURL(url) parameters:@{@"token":[paramsDic paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"status"] integerValue] == 0) {
                
                [SVProgressHUD showSuccessWithStatus:responseObject[@"message"]];
                if (weakSelf.GoodsManageCellBlock) {
                    //库存上架
                    if ([url isEqualToString:@"/Api/Shop/setStockGoodsOnSale"]) {
                        weakSelf.GoodsManageCellBlock(YES);
                    }else {
                        //下架 上架
                        weakSelf.GoodsManageCellBlock(NO);
                    }
                    
                }
            }else {
                 [SVProgressHUD showErrorWithStatus:responseObject[@"message"]];
            }
        } failure:^(NSError *error) {
             [SVProgressHUD showErrorWithStatus:@"网络故障"];
        }];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
