//
//  GSRefuseViewController.m
//  guoshang
//
//  Created by 金联科技 on 16/10/9.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSRefuseViewController.h"
#import "JJHeaders.h"
@interface GSRefuseViewController ()<UITextViewDelegate>
//订单号
@property (weak, nonatomic) IBOutlet UILabel *order_id_label;
//退款额度
@property (weak, nonatomic) IBOutlet UILabel *money_label;
//买家号
@property (weak, nonatomic) IBOutlet UILabel *mai_Num_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
//剩余字数
@property (weak, nonatomic) IBOutlet UILabel *text_count_label;
//请输入拒绝理由
@property (weak, nonatomic) IBOutlet UITextField *placeHolder;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIView *img_photoView;
@property (nonatomic,strong) UIView *jjHeaderView;


@end

@implementation GSRefuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textView.delegate = self;
    [self defaultSetting];
    
}
-(void)defaultSetting{
    self.order_id_label.text = _orderModel.order_sn;
    self.money_label.text = _orderModel.total_fee;
    self.mai_Num_label.text = _orderModel.mobile;
    self.time_label.text = _orderModel.add_time;
    NSMutableArray *images=[NSMutableArray array];
    for (GSMyGroupGoodsModel *goodModel in _orderModel.goods_list) {
        [images addObject:goodModel.goods_thumb];
    }
    
    if (_jjHeaderView) {
        [_jjHeaderView removeFromSuperview];
    }
    
    _jjHeaderView = [JJHeaders createHeaderView:80
                                        images:images];
    [self.img_photoView addSubview:_jjHeaderView];

}




#pragma mark ------------delegate-------
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.placeHolder.hidden=YES;
    
    return YES;
   }

- (void)textViewDidChange:(UITextView *)textView{
    self.placeHolder.hidden = textView.text.length==0?NO:YES;
    self.text_count_label.text = [NSString stringWithFormat:@"%u",500-textView.text.length];
}

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)confirmAction:(UIButton *)sender {
//    确认
    [self submitData];
}


-(void)submitData{
    
    NSString * encryptString;
    NSString * userId = [NSString stringWithFormat:@"shop_id=%@,status=reject,order_id=%@,adminnote=%@",GS_Business_Shop_id,self.orderModel.order_sn,self.textView.text];
    encryptString = [userId encryptStringWithKey:KEY];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/ShopReturnOrder/changeReturn") parameters:@{@"token":encryptString} success:^(id responseObject) {
        if([responseObject[@"status"] isEqualToString:@"1"]){
            [AlertTool alertMesasge:responseObject[@"message"] confirmHandler:^(UIAlertAction *action) {
                
                [weakSelf backAction:nil];
                
            } viewController:weakSelf];
            
        }
//        NSLog(@"----%@",responseObject);
        
    } failure:^(NSError *error) {
        
        NSLog(@"--------%@",error);
        
    }];
    
    
}

@end
