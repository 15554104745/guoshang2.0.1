//
//  SendGoodsInformantionView.m
//  guoshang
//
//  Created by JinLian on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SendGoodsInformantionView.h"

@implementation SendGoodsInformantionView


- (id)init {
    
    if (self = [super init ]) {
        
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    //位置
    UILabel *local = [[UILabel alloc]init];
    local.font = [UIFont systemFontOfSize:12];
    local.textColor = [UIColor grayColor];
    local.text = [NSString stringWithFormat:@"送至  %@",_localInformation];
    [self addSubview:local];
    [local mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@30);
    }];
 
    //运费
    UILabel *FreightLab = [[UILabel alloc]init];
    FreightLab.font = [UIFont systemFontOfSize:12];
    FreightLab.textColor = [UIColor grayColor];
    FreightLab.text = [NSString stringWithFormat:@"运费  %@",_localInformation];
    [self addSubview:FreightLab];
    [FreightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(local.mas_top).offset(30);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@30);
    }];

    //服务
    UILabel *service = [[UILabel alloc]init];
    service.font = [UIFont systemFontOfSize:12];
    service.textColor = [UIColor grayColor];
    service.text = [NSString stringWithFormat:@"服务  %@",_localInformation];
    [self addSubview:service];
    [service mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(FreightLab.mas_top).offset(30);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(@30);

    }];

}




@end
