//
//  MerchandiseCommentTableViewCell.m
//  Demo
//
//  Created by suntao on 16/8/7.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import "MerchandiseCommentTableViewCell.h"
#import "GoodsDetailShopInfoModel.h"
#import "GoodsDetailGoodsInfoModel.h"
#import "ChooseLocationView.h"
#import "GSGoodsDetailSingleClass.h"
#import "GSRefundViewController.h"
#import "UIView+UIViewController.h"
NSString *const kMerchandiseCommentTableViewCellIdentifier = @"MerchandiseCommentTableViewCell";

NSString *addressInGoodsDetailViewModel;
NSString *address_idInGoodsDetailViewModel;


@interface MerchandiseCommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (strong, nonatomic)GSGoodsDetailSingleClass *singleClass;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *freightLabTop;

@property (nonatomic,strong) UIView  *cover;

@end

@implementation MerchandiseCommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    //创建单例类用于在购物车界面使用本页面获取的省份id
    _singleClass = [GSGoodsDetailSingleClass sharInstance];

}

- (void)setDataListDic:(NSDictionary *)dataListDic {
    
    _dataListDic = dataListDic;
    
    GoodsDetailGoodsInfoModel *goodsModel = [dataListDic objectForKey:@"goodsInfo"];
    GoodsDetailShopInfoModel *shopModel = [dataListDic objectForKey:@"shop_info"];
    
    //地址  国商选择地址记录，第二次选择商品自动添加上次选择的地址。
    if (shopModel && [shopModel.shop_id integerValue] == 0 && addressInGoodsDetailViewModel && address_idInGoodsDetailViewModel) {
        [self.addressBtn setTitle:addressInGoodsDetailViewModel forState:UIControlStateNormal];
        [self uploadWith:address_idInGoodsDetailViewModel];
    }else {
        NSString *address_str = [dataListDic objectForKey:@"address_str"];
        [self.addressBtn setTitle:address_str forState:UIControlStateNormal];
        //邮费
        self.freight.text = goodsModel.shipping_rule;
    }

    //如果是第三方门店，隐藏收货地址
    if ([shopModel.shop_id integerValue] != 0 ) {
        self.addressLab.hidden = YES;
        self.addressBtn.hidden = YES;
        
        self.freightLabTop.constant = 5;
        self.freight.text = @"到店自提";
    }
    
    //服务
    self.servers.text = [NSString stringWithFormat:@"由%@为您服务",shopModel.shop_title];
    
    _singleClass.province_id = [dataListDic objectForKey:@"province_id"];
    
//    if (UserId) {
//        
//    }
    
}

//选择收货地址
- (IBAction)selectAddress:(id)sender {
    
//    GSRefundViewController *refund = [[GSRefundViewController alloc]init];
//    [self.viewController.navigationController pushViewController:refund animated:YES];
    
        [self createAddressView];
    
        __weak typeof (self) weakSelf = self;
    
        [UIView animateWithDuration:0.25 animations:^{
            self.superview.transform =CGAffineTransformMakeScale(0.95, 0.95);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                CGAffineTransform transform = weakSelf.chooseLocationView.transform;
                weakSelf.chooseLocationView.transform = CGAffineTransformTranslate(transform, 0, -350);
            }];
            
        }];
    
        self.cover.hidden = !self.cover.hidden;
        self.chooseLocationView.hidden = self.cover.hidden;

}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (CGRectContainsPoint(_chooseLocationView.frame, point)){
        //        CGPoint point = [gestureRecognizer locationInView:_chooseLocationView];
        //        [_chooseLocationView hitTest:point withEvent:[[UIEvent alloc]init]];
        return NO;
    }
    return YES;
}
- (void)tapCover:(UITapGestureRecognizer *)tap{
    
//        if (_chooseLocationView.chooseFinish) {
//            _chooseLocationView.chooseFinish();
//        }
    
    [self closeSelectAddress];
    
}

//地址选择视图
- (void)createAddressView {
    
    _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    [[UIApplication sharedApplication].keyWindow addSubview:_cover];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
    [_cover addGestureRecognizer:tap];
    tap.delegate = self;
    _cover.hidden = YES;
    
    _chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 350)];
    __weak typeof (self) weakSelf = self;
    [_cover addSubview:_chooseLocationView];
    _chooseLocationView.chooseFinish = ^{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            CGAffineTransform transform = weakSelf.chooseLocationView.transform;
            weakSelf.chooseLocationView.transform = CGAffineTransformTranslate(transform, 0, 350);
            if (weakSelf.chooseLocationView.address.length > 0) {
                [weakSelf.addressBtn setTitle:weakSelf.chooseLocationView.address forState:UIControlStateNormal];
            }
            [weakSelf performSelectorOnMainThread:@selector(uploadWith:) withObject:weakSelf.chooseLocationView.provience_id waitUntilDone:YES];
            addressInGoodsDetailViewModel = weakSelf.chooseLocationView.address;
            address_idInGoodsDetailViewModel = weakSelf.chooseLocationView.provience_id;
            weakSelf.singleClass.province_id = weakSelf.chooseLocationView.provience_id;
            
            //NSLog(@"%@",weakSelf.chooseLocationView.city_id);
            //NSLog(@"%@",weakSelf.chooseLocationView.district_id);
            //NSLog(@"%@",weakSelf.chooseLocationView.district);
            //NSLog(@"%@",weakSelf.chooseLocationView.city);
            //NSLog(@"%@",weakSelf.chooseLocationView.provience);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                weakSelf.cover.hidden = YES;
                weakSelf.superview.transform = CGAffineTransformIdentity;
                
            } completion:^(BOOL finished) {
                
                [weakSelf.chooseLocationView removeFromSuperview];
                [weakSelf.cover removeFromSuperview];
            }];
        }];
    };
    
    //在方法内关闭
    _chooseLocationView.closeSelfBlock = ^{
        [weakSelf closeSelectAddress];
    };
    
    
}

//关闭地址选择
- (void)closeSelectAddress {
    __weak typeof (self) weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        
        CGAffineTransform transform = weakSelf.chooseLocationView.transform;
        weakSelf.chooseLocationView.transform = CGAffineTransformTranslate(transform, 0, 350);

    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.cover.hidden = YES;
            weakSelf.superview.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            [weakSelf.chooseLocationView removeFromSuperview];
            [weakSelf.cover removeFromSuperview];
        }];
    }];
}

//获取配送方式。
- (void)uploadWith:(NSString *)provience_id {
    
    GoodsDetailGoodsInfoModel *goodsModel = [_dataListDic objectForKey:@"goodsInfo"];
    if (provience_id != nil && goodsModel.goods_id.length > 0) {
        
        NSDictionary *paramas = @{
                                  @"goods_id":goodsModel.goods_id,
                                  @"province_id":provience_id
                                  };
        __weak typeof(self) weakSelf = self;
//        NSLog(@"%@",[paramas paramsDictionaryAddSaltString]);
        [HttpTool POST:URLDependByBaseURL(@"/Api/Shipping/ShippingRule") parameters:@{@"token":[paramas paramsDictionaryAddSaltString]} success:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"status"]integerValue] == 1) {
                weakSelf.freight.text = [responseObject objectForKey:@"result"];
            }
            
        } failure:^(NSError *error) {
            
        }];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
