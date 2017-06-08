//
//  FootAccountView.h
//  guoshang
//
//  Created by 宗丽娜 on 16/2/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FootAccountViewDelegate <NSObject>

-(void)didSelectedBtn:(UIButton *)btn;
-(void)didPaySelectedBtn:(UIButton *)btn;

@end

@interface FootAccountView : UIView
@property(weak,nonatomic)id<FootAccountViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *allPrice;//合计
@property (weak, nonatomic) IBOutlet UILabel *fieghtPrice;//运费
@property (weak, nonatomic) IBOutlet UIButton *payBtn;//付款按钮
@property (weak, nonatomic) IBOutlet UIButton *allBtn;//全选按钮
@property (weak, nonatomic) IBOutlet UILabel *allSelectLabel;//全选
- (IBAction)allSelectBtn:(id)sender;//全选按钮
- (IBAction)toPayBtn:(UIButton *)sender;//付款按钮

+(id)createFootAccountView;

@end
