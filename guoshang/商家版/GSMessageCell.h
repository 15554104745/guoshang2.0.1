//
//  MessageCell.h
//  UISetting
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 jlkj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GSMessageModel.h"
@class GSMessageCell;
@protocol GSMessageCellDelegate  <NSObject>

- (void)readMessage:(GSMessageCell *)cell withModel:(GSMessageModel*) model;
- (void)deleteMessage:(GSMessageCell*)cell withModel:(GSMessageModel*) model withRow:(NSInteger)row;
@end

@interface GSMessageCell : UITableViewCell
@property (nonatomic,weak) id<GSMessageCellDelegate> delegate;
@property (nonatomic,strong) GSMessageModel *messageModel;
@property (nonatomic,assign) NSInteger row;
@end