//
//  SecondTableViewCell.m
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SecondTableViewCell.h"
#import "ChooseLocationView.h"
#define timerNotificationName @"alreadTimeNotificationNameBuyNow"

@interface SecondTableViewCell ()
@property (nonatomic,strong) UIView  *cover;

@property (weak, nonatomic) IBOutlet UILabel *address_lab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_address;

@end

@implementation SecondTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self registerNSNotificationCenter];
    
}

- (void)dealloc {
    
    [self removeNSNotificationCenter];
}

#pragma mark - 通知中心
- (void)registerNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(notificationCenterEvent:)
                                                 name:timerNotificationName
                                               object:nil];
    
}

- (void)removeNSNotificationCenter {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:timerNotificationName object:nil];
}

- (void)notificationCenterEvent:(id)sender {
    self.selectBtn.userInteractionEnabled = NO;
}









- (IBAction)selectBtn:(UIButton *)sender {
    
    if (self.block) {
        self.block();
    }
}



- (void)setService:(NSString *)service {
    if (service != nil && service != NULL) {
        self.lab_service.text = service;
    }else {
        self.lab_service.text = @"由国商易购加盟店进行发货";
    }
    
    //写死运费方式
    self.lab_postagelab.text = @"到店自提";
    
    //隐藏选择地址模块  （打开时注意改变cell的高度 +18）
    self.address_lab.hidden = YES;
    self.selectAddressBtn.hidden = YES;
    
    self.layout_top.priority = 800;
    self.layout_address.priority  =700;
    
}

-(void)setAddressDic:(NSDictionary *)addressDic {
    _addressDic = addressDic;
    
    [self.selectAddressBtn setTitle:[addressDic objectForKey:@"address"] forState:UIControlStateNormal];
}









#pragma mark - 运费模板  打开即可
- (IBAction)selectAddress:(UIButton *)sender {
    
    //    [self createAddressView];
    //
    //    __weak typeof(self) weakSelf = self;
    //
    //    [UIView animateWithDuration:0.25 animations:^{
    //        self.superview.transform =CGAffineTransformMakeScale(0.95, 0.95);
    //
    //    } completion:^(BOOL finished) {
    //
    //        [UIView animateWithDuration:0.25 animations:^{
    //            CGAffineTransform transform = weakSelf.chooseLocationView.transform;
    //            weakSelf.chooseLocationView.transform = CGAffineTransformTranslate(transform, 0, -350);
    //
    //        }];
    //
    //    }];
    //    self.cover.hidden = !self.cover.hidden;
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
    
    if (self.chooseLocationView.chooseFinish) {
        self.chooseLocationView.chooseFinish();
    }
    
}
- (void)createAddressView {
    
    self.cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.cover];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapCover:)];
    [self.cover addGestureRecognizer:tap];
    tap.delegate = self;
    self.cover.hidden = YES;
    
    self.chooseLocationView = [[ChooseLocationView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 350)];
    __weak typeof (self) weakSelf = self;
    [self.cover addSubview:self.chooseLocationView];
    self.chooseLocationView.chooseFinish = ^{
        
        [UIView animateWithDuration:0.25 animations:^{
            
            CGAffineTransform transform = weakSelf.chooseLocationView.transform;
            weakSelf.chooseLocationView.transform = CGAffineTransformTranslate(transform, 0, 350);
            [weakSelf.selectAddressBtn setTitle:weakSelf.chooseLocationView.address forState:UIControlStateNormal];
            NSLog(@"%@",weakSelf.chooseLocationView.provience_id);
            
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
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
