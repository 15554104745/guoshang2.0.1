//
//  GSGroupOrderInfoController.m
//  guoshang
//
//  Created by 金联科技 on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupOrderInfoController.h"
#import "GSGroupOrderInfoCell.h"
#import "GSCustomOrderInfoModel.h"
#import "GSMyOrderInfoModel.h"
#import "GSMyOrderModel.h"
#import "GSMyOrderPayController.h"
@interface GSGroupOrderInfoController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong,   nonatomic) GSCustomOrderInfoModel *orderInfoModel;
@property (strong,   nonatomic) GSMyOrderInfoModel *myOrderModel;
@property (weak,   nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak,   nonatomic) IBOutlet UIButton *buttomBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *consigneeH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sViewH;




//footer数据设置
//收件人
@property (weak, nonatomic) IBOutlet UILabel *consignee;
//电话
@property (weak, nonatomic) IBOutlet UILabel *tel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *strAddress;
//配送方式
@property (weak, nonatomic) IBOutlet UILabel *shipping_name;

@property (weak, nonatomic) IBOutlet UILabel *order_sn;
//支付方式
@property (weak, nonatomic) IBOutlet UILabel *pay_name;
//订单时间
@property (weak, nonatomic) IBOutlet UILabel *order_time;
//应付金额
@property (weak, nonatomic) IBOutlet UILabel *order_amount;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *order_status;
@property (weak, nonatomic) IBOutlet UILabel *logisticsLabel;


@end

@implementation GSGroupOrderInfoController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.buttomBtn.layer.cornerRadius = 5;
    self.buttomBtn.layer.masksToBounds = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self defualtSetting];
    
    [self createData];
  }

-(void)createData{
    switch (self.oderType) {
        case GSOrderTypeCustomer:
        {
            [self loadCustomData];
        }
            
            break;
        case GSOrderTypeUser:
        {
            [self loadUserData];
        }
            
            break;
            

        default:
            break;
    }
}

-(void)defualtSetting{
    self.title = @"订单详情";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = self.footerView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


-(void)loadCustomData{
    
    NSString * encryptString;
    
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@", GS_Business_Shop_id,self.order_ID];

    encryptString = [userId encryptStringWithKey:KEY];
    
    
    NSLog(@"%@",encryptString);
    
    
    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/user/myOrderDetail") parameters:@{@"token":encryptString} success:^(id responseObject) {
        NSLog(@"-----商户%@",responseObject);
        if ([responseObject[@"status"] isEqualToString:@"3"]) {
          
            GSCustomOrderInfoModel *orderInfo = [GSCustomOrderInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            
            weakSelf.orderInfoModel = orderInfo;
            if([orderInfo.order_status isEqualToString:@"已取消"]||[orderInfo.order_status isEqualToString:@"已关闭"]||[orderInfo.order_status isEqualToString:@"待付款"]||[orderInfo.order_status isEqualToString:@"已完成"])
            {
                weakSelf.buttomBtn.hidden = YES;
            }
            else if ([orderInfo.order_status isEqualToString:@"待收货"]||[orderInfo.order_status isEqualToString:@"已付款"]||[orderInfo.order_status isEqualToString:@"待发货"])

            {
                [weakSelf.buttomBtn setTitle:@"退款" forState:0];
            }
        } else if([responseObject[@"status"] isEqualToString:@"2"]){
             [AlertTool alertMesasge:@"没有该订单消息" confirmHandler:nil viewController:weakSelf];
        }else{
            
          [AlertTool alertMesasge:@"订单获取失败" confirmHandler:nil viewController:weakSelf];
          [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });

        
       
    } failure:^(NSError *error) {
    
    }];
}
-(void)loadUserData{
    
    NSString * encryptString;
    
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@", GS_Business_Shop_id,self.order_ID];
    
    encryptString = [userId encryptStringWithKey:KEY];

    __weak typeof(self) weakSelf = self;
    [HttpTool POST: URLDependByBaseURL(@"/Api/Repository/PurchaseOrderInfo") parameters:@{@"token":encryptString} success:^(id responseObject) {
    
        if ([responseObject[@"status"] isEqualToString:@"0"]) {
            GSMyOrderInfoModel *model = [GSMyOrderInfoModel mj_objectWithKeyValues:responseObject[@"result"]];
            weakSelf.myOrderModel = model;
            if([model.purchase_order.order_state_desc isEqualToString:@"已取消"]||[model.purchase_order.order_state_desc isEqualToString:@"已关闭"]||[model.purchase_order.order_state_desc isEqualToString:@"已付款"]||[model.purchase_order.order_state_desc isEqualToString:@"已签收"])
            {
                weakSelf.buttomBtn.hidden = YES;
            }

        } else if([responseObject[@"status"] isEqualToString:@"2"]){
            
            [AlertTool alertMesasge:@"获取失败" confirmHandler:nil viewController:self];
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [weakSelf.tableView reloadData];
        });
        
    } failure:^(NSError *error) {
//        NSLog(@"wwwwwww%@",error);
        
    }];
}


-(void)setMyOrderModel:(GSMyOrderInfoModel *)myOrderModel{
    _myOrderModel = myOrderModel;
    [self clearData];
    self.consigneeH.constant = 0;
    self.sViewH.constant = 235-70;
  GSPurchaseOrderModel *purchaseModel = myOrderModel.purchase_order;
    self.order_sn.text =purchaseModel.order_id;
    self.pay_name.text = purchaseModel.pay_type;
    self.order_time.text = purchaseModel.order_time;
    self.order_amount.text =purchaseModel.goods_total_price;
    self.order_status.text = purchaseModel.order_state_desc;
    self.shipping_name.text = @"到店自取";
    self.logisticsLabel.text = @"暂无";

    
}

-(void)clearData{
    self.consignee.text = @"";
    self.tel.text =@"";
    self.strAddress.text =@"";
    self.shipping_name.text = @"";
    self.order_sn.text =@"";
    self.pay_name.text = @"";
    self.order_time.text = @"";
    self.order_amount.text= @"";
    self.order_status.text =@"";
  
}
-(void)setOrderInfoModel:(GSCustomOrderInfoModel *)orderInfoModel{
    _orderInfoModel = orderInfoModel;
    [self clearData];
    self.consignee.text = orderInfoModel.consignee;
    self.tel.text = orderInfoModel.tel;
    self.strAddress.text =orderInfoModel.strAddress;
    self.shipping_name.text = [orderInfoModel.shipping_name isEqualToString:@""]?@"到店自取":orderInfoModel.shipping_name;
    self.order_sn.text = orderInfoModel.order_sn;
    self.pay_name.text = orderInfoModel.pay_name;
    self.order_time.text = orderInfoModel.add_time;
    self.order_amount.text= [NSString stringWithFormat:@"￥%@",orderInfoModel.order_amount];
    self.order_status.text = orderInfoModel.order_status;
     self.logisticsLabel.text = @"到店自取";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.oderType == GSOrderTypeCustomer) {
        
        return self.orderInfoModel.goods_list.count;
    }else{
        return self.myOrderModel.purchase_goods.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSGroupOrderInfoCell *cell =[[[NSBundle mainBundle] loadNibNamed:@"GSGroupOrderInfoCell" owner:nil options:nil] firstObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.oderType == GSOrderTypeCustomer) {
        NSArray * listArray = self.orderInfoModel.goods_list;
        cell.model =listArray[indexPath.row];
    }else{
        NSArray *goodsList =  self.myOrderModel.purchase_goods;
        cell.myGoodsModel = goodsList[indexPath.row];
        
    }
   

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}


- (IBAction)buttomBtnAction:(UIButton *)sender {
    
    //GSMyOrderModel *orderModel =(GSMyOrderModel*) self.myOrderModel;
    NSLog(@"%@",sender.currentTitle);
    if ([sender.currentTitle isEqualToString:@"退款"]) {
        NSString * encryptString;


        NSString * userId = [NSString stringWithFormat:@"shop_id=%@,order_id=%@",GS_Business_Shop_id,_orderInfoModel.order_id];
        encryptString = [userId encryptStringWithKey:KEY];
        //    NSLog(@"%@",encryptString);
        __weak typeof(self) weakSelf = self;
        [HttpTool POST: URLDependByBaseURL(@"/Api/Shop/RefundOrder") parameters:@{@"token":encryptString} success:^(id responseObject) {
            //        NSLog(@"%@",responseObject);
            if ([responseObject[@"status"] isEqualToString:@"0"]) {

                [weakSelf.navigationController popViewControllerAnimated:YES];
                [AlertTool alertMesasge:@"退款成功" confirmHandler:nil viewController:nil];

            }else{
                [AlertTool alertMesasge:@"退款失败" confirmHandler:nil viewController:nil];
            }

        } failure:^(NSError *error) {
            
            //        NSLog(@"%@",error);
        }];
        

    }
    else
    {
    GSMyOrderPayController *payVC = [[GSMyOrderPayController alloc] init];
    payVC.orderID = self.myOrderModel.purchase_order.ID;
    payVC.shopID = self.myOrderModel.purchase_order.shop_id;
    payVC.all_goods_price = self.myOrderModel.purchase_order.goods_total_price;
    payVC.all_goods_count = self.myOrderModel.purchase_order.goods_num;
    payVC.isOrder = NO;
    [self.navigationController pushViewController:payVC animated:YES];
    }
}
- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
