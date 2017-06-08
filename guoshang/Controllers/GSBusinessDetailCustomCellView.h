//
//  GSBusinessDetailCustomCellView.h
//  guoshang
//
//  Created by Rechied on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSBusinessDetailCustomCellView : UIView


@property (strong, nonatomic) UILabel *leftLabel;
@property (strong, nonatomic) UILabel *rightLabel;
@property (assign, nonatomic) BOOL showRightIcon;
@property (strong, nonatomic) UIWebView *phoneWebView;

- (instancetype)initWithLeftLabelText:(NSString *)leftText rightLabelText:(NSString *)rightText;
@end
