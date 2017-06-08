//
//  GSOrderBaseViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/7/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSOrderBaseViewController.h"
#import "GSGroupOrderInfoController.h"

#import "GSSellerOrderViewCell.h"
#import "GSSellerOrderHeader.h"
#import "GSSellerOrderFooter.h"
@interface GSOrderBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation GSOrderBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self createTableView];

    self.dataArray = [[NSMutableArray alloc]init];
    self.myTableView.backgroundColor = [UIColor whiteColor];
  
}
-(void)createTableView{
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height - 105) style:UITableViewStyleGrouped];
    
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    
    self.myTableView.dataSource = self;
    
    [self.view addSubview:self.myTableView];
   
        self.myTableView.frame = CGRectMake(0, 0, Width, Height-64);
    
}
- (void)loadData{
}



#pragma mark -- UITableViewDelegate --
-(void)alWithTitle:(NSString *)message {
    UIAlertView *al = [[UIAlertView alloc] initWithTitle:@"温馨提示:" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [al show];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    
    return self.dataArray.count;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    
   GSCustomOrderModel *model = self.dataArray[section];
    
    return model.goods_list.count;

   
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GSSellerOrderViewCell *cell = [GSSellerOrderViewCell orederCellWithTableView:tableView withOrderType:self.orderType];
    
    
    if (self.orderType == GSOrderTypeUser && indexPath.section<self.dataArray.count) {
        
        GSMyOrderModel *orderModel =self.dataArray[indexPath.section];
        NSArray *goodsListArray =orderModel.goods_list;
        cell.myGoodsModel = goodsListArray[indexPath.row];
        
    }else if (self.orderType == GSOrderTypeCustomer && indexPath.section<self.dataArray.count){
        
        GSCustomOrderModel *orderModel =self.dataArray[indexPath.section];
        NSArray *goodsListArray =orderModel.goods_list;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"orderStatus"] =  orderModel.order_status;
        dic[@"consignee"] =  orderModel.consignee;
        dic[@"tel"] =  orderModel.tel;
        cell.customOrderInfo = dic;
        cell.customGoodsModel =goodsListArray[indexPath.row];
    }
    
    return cell;
    
}
    


//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    GSSellerOrderHeader *headerView =[GSSellerOrderHeader sellerHeaderViewWithOrderType:self.orderType];
    if (section<self.dataArray.count) {
        headerView.model = self.dataArray[section];
            }
    return headerView;
    
}


//尾视图
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    GSSellerOrderFooter *footerView = [[GSSellerOrderFooter alloc] initWithFrame:CGRectMake(0, 0, Width, 0)];
    
    footerView.footerInfoDic =[self footerDataWithsectionIndex:section];
        __weak typeof(self) weakSelf = self;
        footerView.loadData = ^(){
            [weakSelf.dataArray removeAllObjects];
            
            [weakSelf loadData];
        };

    return footerView;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSGroupOrderInfoController *infoVC = [[GSGroupOrderInfoController alloc] init];
    NSLog(@"类型是多少%ld",self.orderType);
    
    if (self.orderType == GSOrderTypeCustomer) {
        GSCustomOrderModel *orderModel =self.dataArray[indexPath.section];
        infoVC.order_ID =orderModel.order_id;
        
    }else{
        GSMyOrderModel *myOrder =self.dataArray[indexPath.section];
        infoVC.order_ID = myOrder.ID;
 
    }
    infoVC.oderType = self.orderType;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController pushViewController:infoVC animated:YES];
}



//单元格行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 113;
}

//头视图高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (self.orderType == GSOrderTypeUser) {
        return 60;
    }
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    
    return [self FooterHeightWithSection:section];
}
#pragma   -------other-----

-(CGFloat)FooterHeightWithSection:(NSInteger)section{
    
    NSDictionary *dd = [self footerDataWithsectionIndex:section];
    NSString *status = dd[@"status"];
    if ((self.orderType ==GSOrderTypeCustomer && [status isEqualToString:@"待发货"])||(self.orderType ==GSOrderTypeCustomer && [status isEqualToString:@"待收货"])||(self.orderType == GSOrderTypeUser && [status intValue] ==5)||(self.orderType == GSOrderTypeUser && [status intValue] ==1)||(self.orderType == GSOrderTypeUser && [status intValue] ==4)) {
        
        return 40;
    }
    return 0;
}
-(NSDictionary*)footerDataWithsectionIndex:(NSInteger)index{
    NSMutableDictionary *infoDic = [NSMutableDictionary dictionary];
    NSString *status = @"";
    NSString *orderId = @"";
    if (index<self.dataArray.count) {
        if (self.orderType == GSOrderTypeCustomer) {
            
            GSCustomOrderModel *model  = self.dataArray[index];
            status = model.order_status;
            orderId = model.order_id;
        }else{
            GSMyOrderModel *model  = self.dataArray[index];
            NSString *good_id = @"";
            if ( model.goods_list.count>0) {
                GSMyGoodModel * goodsModel = model.goods_list[0];
                good_id = goodsModel.goods_id;
            }
            
            status = model.order_state;
            orderId = model.ID;
            [infoDic setObject:good_id forKey:@"good_id"];
            [infoDic setObject:model.shop_id forKey:@"shop_id"];
            [infoDic setObject:model.goods_total_price forKey:@"goods_total_price"];
            [infoDic setObject:model.goods_num forKey:@"goods_num"];
        }
    }
    
    [infoDic setObject:status forKey:@"status"];
    [infoDic setObject:orderId forKey:@"order_id"];
    [infoDic setObject:[NSString stringWithFormat:@"%zi",self.orderType] forKey:@"orderType"];

    return infoDic;
}

@end
