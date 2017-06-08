//
//  GSSpecificationsManager.m
//  guoshang
//
//  Created by Rechied on 2016/11/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSpecificationsManager.h"
#import "GSSelectSpecificationsView.h"

@interface GSSpecificationsManager()
@property (weak, nonatomic) UIView *currentView;
@property (strong, nonatomic) id goodsModel;
@property (assign, nonatomic) BOOL showFcousAnimation;
@property (weak, nonatomic) UIView *maskView;

@end

@implementation GSSpecificationsManager

- (UIView *)maskView {
    if (!_maskView) {
        UIView *maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        maskView.backgroundColor = [UIColor colorWithHexString:@"848689" alpha:0.5f];
        maskView.alpha = 0.0f;
        _maskView = maskView;
        return _maskView;
    }
    return _maskView;
}
- (void)showChooseSpecificationsNotChangeCountWithGoodsModel:(id)goodsModel {
    self.goodsModel = goodsModel;
    self.showFcousAnimation = NO;
    [self createSelectSpectficationsViewWithGoodsModel:goodsModel showSpecifications:YES];
    self.selectView.notShowChangCount = YES;
    [self open];
    
}

- (void)showChooseSpecificationsWithCurrentView:(UIView *)currentView goodsModel:(id)goodsModel showFcousAnimaiton:(BOOL)showFcousAnimation {
    self.currentView = currentView;
    self.goodsModel = goodsModel;
    self.showFcousAnimation = showFcousAnimation;
    
    [self createSelectSpectficationsViewWithGoodsModel:goodsModel showSpecifications:YES];
    [self open];
}

- (void)showAddToCarViewWithCurrentView:(UIView *)currentView goodsModel:(id)goodsModel {
    self.currentView = currentView;
    self.goodsModel = goodsModel;
    self.showFcousAnimation = YES;
    
    [self createSelectSpectficationsViewWithGoodsModel:goodsModel showSpecifications:NO];
    [self open];
}

- (void)createSelectSpectficationsViewWithGoodsModel:(id)goodsModel showSpecifications:(BOOL)showSpecifications {
    GSSelectSpecificationsView *selectView = [[GSSelectSpecificationsView alloc] initWithGoodsModel:goodsModel hasSpecifications:showSpecifications];
    self.selectView = selectView;
}

// 动画1
- (CATransform3D)firstStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DScale(transform, 0.98, 0.98, 1.0);
    transform = CATransform3DRotate(transform, 5.0 * M_PI / 180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -30.0);
    return transform;
}
// 动画2
- (CATransform3D)secondStepTransform {
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstStepTransform].m34;
    transform = CATransform3DTranslate(transform, 0, Height * -0.08, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
    return transform;
}

/**
弹出选择规格的弹出框
*/
- (void)open {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.selectView];
    if (self.showFcousAnimation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.currentView.layer.transform = [self firstStepTransform];
            self.maskView.alpha = 1.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.15 animations:^{
                self.currentView.layer.transform = [self secondStepTransform];
                self.selectView.transform = CGAffineTransformTranslate(self.selectView.transform, 0, -(Height - 180));
            }];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.maskView.alpha = 1.0;
            self.selectView.transform = CGAffineTransformTranslate(self.selectView.transform, 0, -(Height - 180));
        }];
    }
    
    
}

/**
 关闭选择规格的弹出框
 */
- (void)close {
    if (self.showFcousAnimation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.currentView.layer.transform = [self firstStepTransform];
            self.selectView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.25 animations:^{
                self.currentView.layer.transform = CATransform3DIdentity;
                self.maskView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.maskView removeFromSuperview];
                [self.selectView removeFromSuperview];
            }];
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.maskView.alpha = 0.0;
            self.selectView.transform = CGAffineTransformIdentity;
            self.selectView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
            [self.selectView removeFromSuperview];
        }];
    }
}

@end
