

//
//  GSSellerOrderHeader.m
//  guoshang
//
//  Created by 金联科技 on 16/8/27.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSellerOrderHeader.h"
#import "GSCustomOrderModel.h"
#import "GSMyOrderModel.h"
@interface GSSellerOrderHeader ()
//店铺view
@property (weak, nonatomic) IBOutlet UIView *shopView;
//店铺头像
@property (weak, nonatomic) IBOutlet UIImageView *seller_iconView;
//店铺名字
@property (weak, nonatomic) IBOutlet UILabel *shopName;
//电话号码
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//订单编号
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shopViewH;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusW;



@end

@implementation GSSellerOrderHeader
static GSOrderInfoType orderType;
//初始化方法
+(instancetype)sellerHeaderViewWithOrderType:(GSOrderInfoType)type{
       orderType= type;

    return  [[[NSBundle mainBundle] loadNibNamed:@"GSSellerOrderHeader" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.seller_iconView.layer.cornerRadius = _seller_iconView.frame.size.height/2;
    self.seller_iconView.layer.masksToBounds = YES;
    self.sellerOrderType = orderType;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    判断状态
    if(self.sellerOrderType == GSOrderTypeCustomer){
        self.shopView.hidden = YES;
        self.shopViewH.constant = 0;
        self.statusW.constant = 120;
        self.statusLabel.font = [UIFont systemFontOfSize:10];
        self.statusLabel.textColor = self.orderIdLabel.textColor;
    }

}
//设置model
-(void)setModel:(id)model{
    _model = model;
    switch (self.sellerOrderType) {
//            客户订单头视图
        case GSOrderTypeCustomer:
        {
            GSCustomOrderModel * modelCustom =(GSCustomOrderModel*)model;
           
            _orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@",modelCustom.order_sn];
            _statusLabel.text = modelCustom.add_time;

        }
            break;
//            我的订单头视图
        case GSOrderTypeUser:
        {
            GSMyOrderModel * modell =(GSMyOrderModel*)model;
//            商铺信息
            GSShopModel *shopModel =  modell.supplier;
            _seller_iconView.image = [UIImage imageNamed:@"icon"];
            self.shopName.text = shopModel.suppliers_name ?shopModel.suppliers_name  :@"国商易购";
            self.phoneLabel.text = shopModel.phone?shopModel.phone:@"400-893-1880";
//            订单消息
            _orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@",modell.order_id];
            switch ([modell.order_state integerValue]) {
                    
                case 1:
                    _statusLabel.text = @"待付款";
                    
                    break;
                case 2:
                    _statusLabel.text = @"已付款";
                    
                    break;
                case 3:
                    _statusLabel.text = @"待发货";
                    
                    break;
                case 4:
                    _statusLabel.text = @"已发货";
                    
                    break;
                case 5:
                    _statusLabel.text = @"已完成";
                    
                    break;
                case 6:
                    _statusLabel.text = @"已取消";
                    
                    break;
                    
                default:
                    break;
            }
            
        }
            
            break;
            
        default:
            break;
    }
   
    
}

@end
