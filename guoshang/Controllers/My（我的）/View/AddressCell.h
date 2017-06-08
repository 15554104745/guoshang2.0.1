//
//  AddressCell.h
//  guoshang
//
//  Created by 宗丽娜 on 16/3/7.
//  Copyright © 2016年 宗丽娜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAddressModel.h"
@interface AddressCell : UITableViewCell

@property  (nonatomic,strong) MyAddressModel *addressModel;
@property (nonatomic,assign) NSInteger cellRow;
@property (weak, nonatomic) IBOutlet UILabel *userName;//用户姓名
@property (weak, nonatomic) IBOutlet UILabel *userPhone;//用户手机号
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;//默认字样
@property (weak, nonatomic) IBOutlet UILabel *userAddressLabel;//用户地址
- (IBAction)alterbtn:(UIButton *)sender;

@end
