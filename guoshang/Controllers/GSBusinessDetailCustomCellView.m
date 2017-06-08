//
//  GSBusinessDetailCustomCellView.m
//  guoshang
//
//  Created by Rechied on 16/7/25.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSBusinessDetailCustomCellView.h"

@implementation GSBusinessDetailCustomCellView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithLeftLabelText:(NSString *)leftText rightLabelText:(NSString *)rightText {
    self = [super init];
    if (self) {
        self.leftLabel = [[UILabel alloc] init];
        _leftLabel.text = leftText;
        _leftLabel.font = [UIFont systemFontOfSize:14];
        _leftLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        self.rightLabel = [[UILabel alloc] init];
        _rightLabel.text = rightText;
        _rightLabel.font = [UIFont systemFontOfSize:14];
        _rightLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:_rightLabel];
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_leftLabel.mas_right).offset(0);
            make.centerY.equalTo(self.mas_centerY);
        }];
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_offset(0);
            make.height.offset(1);
        }];
        
        
    }
    return self;
}


- (void)setShowRightIcon:(BOOL)showRightIcon {
    _showRightIcon = showRightIcon;
    if (showRightIcon) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"re_business_detail_phone"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.offset(-20);
            make.centerY.equalTo(_rightLabel.mas_centerY);
        }];
    }
}

- (void)buttonClick {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_rightLabel.text]]];
}


/*
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        [self addSubview:_leftLabel];
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(15);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return _leftLabel;
}

- (UILabel *)rightLabel {
    
        if (!_rightLabel) {
            _rightLabel = [[UILabel alloc] init];
            
        }
        return _leftLabel;
    
}
 */

@end
