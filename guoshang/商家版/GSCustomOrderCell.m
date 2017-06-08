//
//  GSCustomOrderCell.m
//  guoshang
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCustomOrderCell.h"
#import "UIView+UIViewController.h"
#import "GSGroupInfoViewController.h"

#import "GSGroupOrderInfoController.h"
#import "UIImageView+WebCache.h"
@interface GSCustomOrderCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *user_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation GSCustomOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

+(GSCustomOrderCell*)createCellWithTableView:(UITableView*)tableView{
   GSCustomOrderCell* cell= [tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (!cell) {
        
     cell  =  [[[NSBundle mainBundle] loadNibNamed:@"GSCustomOrderCell" owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(void)setOrderModel:(GSGroupOrderModel *)orderModel{
    _orderModel = orderModel;
//    图片
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:orderModel.goods_img] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
//    标题
    self.titleLabel.text = [NSString stringWithFormat:@"%@ %@",orderModel.title,orderModel.descrip];
//    人数
    self.user_countLabel.text = [NSString stringWithFormat:@"%@人团",orderModel.max_user_amount];
//    价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",orderModel.price];
//    状态信息
    self.statusLabel.text = orderModel.status_desc;
}
//团购详情
- (IBAction)groupInfo:(UIButton *)sender {
    GSGroupInfoViewController *groupVc = [[GSGroupInfoViewController alloc] init];
    groupVc.tuan_id = self.orderModel.tuan_id;
    [self.viewController.navigationController pushViewController:groupVc animated:YES];
    
}
//订单详情
- (IBAction)orderInfo:(UIButton *)sender {
    GSGroupOrderInfoController *vc = [[GSGroupOrderInfoController alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
}
@end
