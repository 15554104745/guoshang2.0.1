//
//  GSGroupInfoViewCell.m
//  guoshang
//
//  Created by 金联科技 on 16/7/26.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSGroupInfoViewCell.h"
#import "UIImageView+WebCache.h"
@interface GSGroupInfoViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *group_flag;


@end

@implementation GSGroupInfoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
   }
-(void)setGrouper:(BOOL)grouper{
    _grouper = grouper;
   self.group_flag.hidden = !_grouper;
}
-(void)setModel:(GSGroupUserModel *)model{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
}
@end
