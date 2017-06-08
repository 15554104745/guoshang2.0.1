//
//  GSReimburseCell.m
//  guoshang
//
//  Created by 金联科技 on 16/9/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSReimburseCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+UIViewController.h"
#import "GSRefuseViewController.h"
#import "GSRefundViewController.h"
#import "HeaderView.h"
#import "JJHeaders.h"

static NSString *cellIdentify = @"cellIdentify";
@interface GSReimburseCell () {
    UIView *jjHeaderView;
}

@property (weak, nonatomic) IBOutlet UILabel *return_num;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *order_num;
@property (weak, nonatomic) IBOutlet UILabel *return_money;
@property (weak, nonatomic) IBOutlet UILabel *consignee_info;
@property (weak, nonatomic) IBOutlet UIView *photo_img;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet UIButton *middleBtn;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;

@property (nonatomic,strong) NSArray *statusArray;
//@property (nonatomic,strong) JJHeaders *icon_view;
@end

@implementation GSReimburseCell

+(instancetype)cellWithTabelView:(UITableView*)tableView{
    GSReimburseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GSReimburseCell" owner:nil options:nil] lastObject];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(GSReimburseModel *)model{
    _model = model;
    self.return_num.text = model.return_order_sn;
    self.time.text = model.add_time;
    self.status.text = model.status;
    self.order_num.text= model.order_sn;
    self.return_money.text = model.total_fee;
    self.consignee_info.text = [NSString stringWithFormat:@"%@ %@",model.consignee,model.mobile];
//  GSMyGroupGoodsModel *goodModel =model.goods_list.firstObject;
//    [self.photo_img sd_setImageWithURL:[NSURL URLWithString:goodModel.goods_thumb] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    NSMutableArray *images = [NSMutableArray array];
//
    for (GSMyGroupGoodsModel *goodModel in model.goods_list) {
        [images addObject:goodModel.goods_thumb];
    }
   
    if (jjHeaderView) {
        [jjHeaderView removeFromSuperview];
    }
    
    jjHeaderView = [JJHeaders createHeaderView:80
                                          images:images];
    [self.photo_img addSubview:jjHeaderView];
    
    
    NSString *status = model.status;
    if ([status isEqualToString: @"处理中"]) {
        
        self.leftBtn.hidden = NO;
        self.middleBtn.hidden = NO;
        [self.middleBtn setTitle:@"同意" forState:UIControlStateNormal];
        self.middleBtn.tag = 100;
    }else if([status isEqualToString:@"已拒绝"]){
        self.leftBtn.hidden = YES;
        self.middleBtn.hidden = NO;
        [self.middleBtn setTitle:@"同意" forState:UIControlStateNormal];
        self.middleBtn.tag=100;
    }else if ([status isEqualToString:@"待确认"]){
        self.leftBtn.hidden = YES;
        self.middleBtn.hidden = NO;
        [self.middleBtn setTitle:@"确认" forState:UIControlStateNormal];
        self.middleBtn.tag = 10;
        
    }else if ([status isEqualToString:@"已退款"]||[status isEqualToString:@"已取消"]){
        self.middleBtn.hidden = YES;
        self.leftBtn.hidden = YES;
    }
}
//查看
- (IBAction)lookBtnAction:(UIButton *)sender {
    NSLog(@"查看");
    GSRefundViewController *refoundInfoVc = [[GSRefundViewController alloc] init];
    refoundInfoVc.order_sn = _model.order_sn;
    [self.viewController.navigationController pushViewController:refoundInfoVc animated:YES];
}

- (IBAction)middleBtnAction:(UIButton *)sender {
    NSLog(@"%d",sender.tag);
    NSString * status= sender.tag==100?@"consent":@"confirm";
   
    if(self.btnStatus){
        self.btnStatus(status,self.model.order_sn);
    }
   }

//拒绝
- (IBAction)refusedBtnAction:(UIButton *)sender {
    NSLog(@"拒绝");
    GSRefuseViewController *refuseVC = [[GSRefuseViewController alloc] init];
    refuseVC.orderModel = self.model;
    [self.viewController.navigationController pushViewController:refuseVC animated:YES];
}


@end
