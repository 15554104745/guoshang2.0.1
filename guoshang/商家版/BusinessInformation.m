//
//  BusinessInformation.m
//  guoshang
//
//  Created by JinLian on 16/7/23.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "BusinessInformation.h"

@implementation BusinessInformation


- (id)init {
    if ( self = [super init ]) {
        
        [self createUI];
        
    }
    return self;
}

- (void)createUI {
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 0, Width-10, 1)];
    image.backgroundColor = [UIColor grayColor];
    [self addSubview:image];
    
    //商店头像
    UIImageView *image2 = [[UIImageView alloc]init];
    image2.backgroundColor = [UIColor redColor];
    image2.image = self.image;
    [self addSubview:image2];
    [image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self).offset(5);
        make.width.height.equalTo(@60);
    }];
    
    //商店名称
    LNLabel  *shopnameLab = [LNLabel addLabelWithTitle:self.shopName TitleColor:[UIColor lightGrayColor] Font:12  BackGroundColor:[UIColor clearColor]];
    [self addSubview:shopnameLab];
    [shopnameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image2.mas_top);
        make.left.equalTo(image2.mas_right).offset(10);
        make.size.mas_equalTo([LNLabel calculateLableSizeWithString:self.shopName AndFont:12]);
    }];

    //关注
    UIButton * concern = [UIButton buttonWithType:UIButtonTypeCustom];
    concern.backgroundColor = [UIColor redColor];
    [concern addTarget:self.superview action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:concern];
    [concern mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image2.mas_bottom).offset(10);
        make.right.equalTo(image2.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.width.equalTo(@80);
    }];
    
    
    
    
    
    NSArray *buttonTitleArray = @[@"全部宝贝",@"上新宝贝",@"关注人数",];
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(image2.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(10);
        make.width.mas_offset(Width-100);
        make.height.equalTo(@50);
    }];
    

//    UIView *bottomView = [[UIView alloc] init];
//    [_toolView addSubview:bottomView];
////    
//    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(topView.mas_bottom).offset(0);
//        make.left.right.bottom.mas_offset(0);
//    }];
//    UIView *lastView = nil;
//    
//    for (NSInteger i = 0; i < 4; i ++) {
//        UIView *tempView = [[UIView alloc] init];
//        //tempView.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
//        [bottomView addSubview:tempView];
//        [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.mas_offset(0);
//            if (!lastView) {
//                make.left.offset(0);
//            } else {
//                make.left.equalTo(lastView.mas_right).offset(0);
//                make.width.equalTo(lastView.mas_width);
//            }
//            
//            if (i == 3) {
//                make.right.offset(0);
//            }
//        }];
//        
//        UILabel *tempLab = [[UILabel alloc] init];
//        tempLab.textColor = [UIColor lightGrayColor];
//        tempLab.font = [UIFont systemFontOfSize:14.0f];
//        tempLab.text = buttonTitleArray[i];
//        [tempView addSubview:tempLab];
//        
//        [tempLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(tempView.mas_centerX);
//            make.bottom.offset(-10);
//        }];
    
//        UIImageView *tempImageView = [[UIImageView alloc] init];
//        tempImageView.image = [UIImage imageNamed:buttonImageNameArray[i]];
//        [tempView addSubview:tempImageView];
//        
//        [tempImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(tempView.mas_centerX);
//            make.bottom.equalTo(tempLab.mas_top).offset(-10);
//        }];
//        
//        UIButton *tempButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [tempButton addTarget:self action:@selector(toolButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        tempButton.tag = ButtonTag((i+1));
//        [tempView addSubview:tempButton];
//        
//        [tempButton mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.bottom.mas_offset(0);
//        }];
//        
//        lastView = tempView;
//    }
//
//    
//    
    
    
    
    
    
    
    
}

- (void)buttonAction:(UIButton *)sneder {
    
    NSLog(@"关注按钮");
}


@end
