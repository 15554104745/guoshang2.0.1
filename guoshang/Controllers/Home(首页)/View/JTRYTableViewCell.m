//
//  JTRYTableViewCell.m
//  guoshang
//
//  Created by hi on 16/2/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "JTRYTableViewCell.h"
#import "Masonry.h"
@implementation JTRYTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createUI];
    }
    
    return self;
    
}
-(void)createUI{
   int  podding = (self.contentView.frame.size.width - 60) /3;
    
    //1
    self.leftBigIconView = [[UIImageView alloc] init];
    self.leftBigIconView.backgroundColor = [UIColor redColor];
//    self.leftBigIconView.image = [UIImage imageNamed:@"设置"];
    [self.contentView addSubview:self.leftBigIconView];
    [self.leftBigIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(30);
        make.top.mas_equalTo(self.contentView.mas_bottom).with.offset(20);
        make.width.mas_equalTo(podding * 2);
        make.height.mas_equalTo(podding * 2);
        
    }];
    
    //2
    
    self.leftSmallIconView = [[UIImageView alloc] init];
    self.leftSmallIconView.backgroundColor = [UIColor greenColor];
//    self.leftSmallIconView.image = [UIImage imageNamed:@"设置"];
    [self.contentView addSubview:self.leftSmallIconView];
    [self.leftSmallIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).with.offset(30);
        make.top.mas_equalTo(self.leftBigIconView.mas_bottom);
        make.width.mas_equalTo(podding);
        make.height.mas_equalTo(podding);
    }];
    //3
    self.leftSmallTwoIconView = [[UIImageView alloc] init];
//    self.leftSmallIconView.image = [UIImage imageNamed:@"设置"];
    self.leftSmallTwoIconView.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.leftSmallTwoIconView];
    [self.leftSmallTwoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftSmallIconView.mas_right);
        make.top.mas_equalTo(self.leftBigIconView.mas_bottom);
        make.width.mas_equalTo(podding);
        make.height.mas_equalTo(podding);
        
    }];
    //4
    self.rightSmallIconView = [[UIImageView alloc] init];
//    self.rightSmallIconView.image = [UIImage imageNamed:@"设置"];
    self.rightSmallIconView.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:self.rightSmallIconView];
    [self.rightSmallIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBigIconView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_bottom).with.offset(20);
        make.width.mas_equalTo(podding);
        make.height.mas_equalTo(podding);
        
    }];
    //5
    self.rightSmallTwoIconView = [[UIImageView alloc] init];
//    self.rightSmallTwoIconView.image = [UIImage imageNamed:@"设置"];
    self.rightSmallTwoIconView.backgroundColor = [UIColor grayColor];
    [self.contentView addSubview:self.rightSmallTwoIconView];
    [self.rightSmallTwoIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightSmallIconView.mas_right);
        make.top.mas_equalTo(self.contentView.mas_bottom);
        make.width.mas_equalTo(podding);
        make.height.mas_equalTo(podding);
        
    }];
    //6
    self.rightBigIconView = [[UIImageView alloc] init];
    self.rightBigIconView.image = [UIImage imageNamed:@"设置"];
    [self.contentView addSubview:self.rightBigIconView];
    [self.rightBigIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftBigIconView .mas_left);
        make.top.mas_equalTo(self.rightSmallIconView.mas_bottom);
        make.width.mas_equalTo(podding * 2);
        make.height.mas_equalTo(podding * 2);
        
    }];

    
}


@end
