//
//  GSClassfiyLeftTableViewCell.m
//  guoshang
//
//  Created by Rechied on 2016/11/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSClassfiyLeftTableViewCell.h"
#import "UIColor+HaxString.h"

@implementation GSClassfiyLeftTableViewCell

- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
        _tapView.backgroundColor = [UIColor colorWithHexString:@"e42144"];
    }
    return _tapView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMenuModel:(GSClassfiyMenuModel *)menuModel {
    _menuModel = menuModel;
    self.iconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_classfiy_%@",menuModel.ID]];
    self.iconImageView.highlightedImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_classfiy_%@_highlight",menuModel.ID]];
    self.titleLabel.text = menuModel.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected == YES) {
        [self.contentView addSubview:self.tapView];
        [_tapView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.bottom.mas_offset(0);
            make.width.offset(2);
        }];
    } else {
        if (_tapView) {
            [_tapView removeFromSuperview];
        }
    }
    self.rightLine.hidden = selected;
    self.botLine.hidden = selected;
    [self.iconImageView setHighlighted:selected];
    self.titleLabel.textColor = selected ? [UIColor colorWithHexString:@"e42144"] : [UIColor colorWithHexString:@"333333"];
    self.contentView.backgroundColor = selected ? [UIColor whiteColor] : [UIColor colorWithHexString:@"efefef"];
}

@end
