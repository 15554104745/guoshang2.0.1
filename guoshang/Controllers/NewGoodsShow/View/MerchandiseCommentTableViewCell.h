//
//  MerchandiseCommentTableViewCell.h
//  Demo
//
//  Created by suntao on 16/8/7.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseLocationView.h"

extern NSString *const kMerchandiseCommentTableViewCellIdentifier;

@interface MerchandiseCommentTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UILabel *freight;

@property (weak, nonatomic) IBOutlet UILabel *servers;

@property (nonatomic, strong)NSDictionary *dataListDic;

@property (nonatomic, strong)ChooseLocationView *chooseLocationView;


@end
