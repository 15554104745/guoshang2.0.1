//
//  GSCreateGroupRuleView.h
//  guoshang
//
//  Created by Rechied on 16/9/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSGroupModelRuleModel.h"

@interface GSCreateGroupRuleView : UIView

@property (strong, nonatomic) GSGroupModelRuleModel *ruleModel;
@property (weak, nonatomic) UIImageView *ruleImageView;
@property (weak, nonatomic) UILabel *ruleLabel;
@end
