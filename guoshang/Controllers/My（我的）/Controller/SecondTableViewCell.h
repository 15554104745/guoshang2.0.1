//
//  SecondTableViewCell.h
//  guoshang
//
//  Created by JinLian on 16/8/15.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseLocationView.h"

typedef void(^passValueBlock)();

@interface SecondTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lab_postagelab;

@property (weak, nonatomic) IBOutlet UILabel *lab_service;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIButton *selectAddressBtn;

@property (nonatomic, copy)passValueBlock block;

@property (nonatomic, copy)NSString *address;

@property (nonatomic, strong)ChooseLocationView *chooseLocationView;

@property (nonatomic, strong)NSDictionary *addressDic;

@property (nonatomic, copy)NSString *service;

@end
