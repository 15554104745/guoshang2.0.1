//c
//  GSCarSettleToolsView.m
//  guoshang
//
//  Created by Rechied on 2016/11/17.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSCarSettleToolsView.h"

@interface GSCarSettleToolsView()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation GSCarSettleToolsView
- (IBAction)selectAllAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectAllGoodsStatusChange" object:nil userInfo:@{@"value":@(sender.selected)}];
}

- (IBAction)editSelectAllButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectAllGoodsStatusChange" object:nil userInfo:@{@"value":@(sender.selected)}];
}

- (IBAction)settleAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(carSettleToolsSettleAction)]) {
        [_delegate carSettleToolsSettleAction];
    }
}

- (IBAction)deleteAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(carDeleteToolsDeleteAction)]) {
        [_delegate carDeleteToolsDeleteAction];
    }
}

- (void)changeShowTypeWithIsEdit:(BOOL)isEdit {
    [self.scrollView setContentOffset:CGPointMake(0, isEdit ? 50 : 0)];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectAllGoodsStatusChange" object:nil userInfo:@{@"value":@(NO)}];
    self.editSelectAllButton.selected = NO;
}

@end
