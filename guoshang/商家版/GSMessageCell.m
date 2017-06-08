//
//  MessageCell.m
//  UISetting
//
//  Created by 金联科技 on 16/7/20.
//  Copyright © 2016年 jlkj. All rights reserved.
//

#import "GSMessageCell.h"

@interface GSMessageCell ()

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIButton *readerMessage;
@property (weak, nonatomic) IBOutlet UIButton *deleteMessage;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation GSMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.readerMessage.layer.cornerRadius = self.readerMessage.frame.size.height/2;
    self.readerMessage.layer.masksToBounds= YES;
    self.deleteMessage.layer.cornerRadius = self.deleteMessage.frame.size.height/2;
    self.deleteMessage.layer.masksToBounds = YES;
    
}





-(void)setMessageModel:(GSMessageModel *)messageModel{
    _messageModel = messageModel;
    self.messageLabel.text = messageModel.content;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:messageModel.time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];//格式化
    [formatter  setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* s1 = [formatter stringFromDate:date];
    self.timeLabel.text = s1;

    if ([messageModel.is_read isEqualToString:@"1"]) {
        
        self.readerMessage.backgroundColor = [UIColor lightGrayColor];
    }else{
        self.readerMessage.backgroundColor = [UIColor redColor];
    }
    
}

- (IBAction)readMessgeAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(readMessage: withModel:)]) {
        [self.delegate readMessage:self withModel:self.messageModel];
    }
    
    
}
- (IBAction)deleteMessageAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteMessage:withModel:withRow:)]) {
        
        [self.delegate deleteMessage:self withModel:self.messageModel withRow:self.row];
    }
}


@end
