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
#import "GSOrderDetailViewController.h"
#import "GSGroupOrderInfoController.h"
#import "UIImageView+WebCache.h"
#import "GroupBuyNowController.h"
@interface GSCustomOrderCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *user_countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *descrip;
@property (weak, nonatomic) IBOutlet UILabel *refund_label;

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
    self.titleLabel.text = [NSString stringWithFormat:@"%@ ",orderModel.title];
//    人数
    self.user_countLabel.text = [NSString stringWithFormat:@"%@人团",orderModel.user_num];
//    价格
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@",orderModel.group_price];
//    状态信息
    self.statusLabel.text = orderModel.o_status_desc;
    self.descrip.text= orderModel.descrip;
    self.refund_label.text = orderModel.refund;
}
//团购详情
- (IBAction)groupInfo:(UIButton *)sender {
    GroupBuyNowController *groupVC = [[GroupBuyNowController alloc] init];
    groupVC.tun_id =self.orderModel.tuan_id;
    groupVC.enterstyle = enterWith_Dingdan;
//    GSGroupInfoViewController *groupVC = [[GSGroupInfoViewController alloc] init];
//    groupVC.tuan_id = self.orderModel.tuan_id;
    [self.viewController.navigationController pushViewController:groupVC animated:YES];
    
}
//订单详情
- (IBAction)orderInfo:(UIButton *)sender {
//    //点击cell  让颜色变回来
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GSOrderDetailViewController *orderDetailViewController = ViewController_in_Storyboard(@"Main", @"orderDetailViewController");
    
    orderDetailViewController.orderType = GSOrderTypeGroupOrder;
    orderDetailViewController.order_id  = _orderModel.order_id;
    [self.viewController.navigationController pushViewController:orderDetailViewController animated:YES];

   

}
@end
