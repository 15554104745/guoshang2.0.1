//
//  GroupInfoList.m
//  guoshang
//
//  Created by JinLian on 16/9/19.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GroupInfoList.h"


@interface GroupInfoList () {
    
}

@property (assign,nonatomic) NSUInteger numRows;
@property (assign,nonatomic) NSUInteger dy;
@property (retain,nonatomic) NSMutableArray *switchButtons;

@end

@implementation GroupInfoList

- (id)initWithFrame:(CGRect)frame andColumnsWidths:(NSArray*)columns{
    self = [super initWithFrame:frame];
    if (self)
    {
        SwitchButtonString =@"SwitchButtonString";
        self.numRows =0;
        self.columnsWidths = columns;
        self.dy =0;
        self.numRows =0;
        self.switchButtons = [NSMutableArray array];
    }
    return self;
}


- (void)addRecordWithArr:(NSArray *)record
{
    if(record.count !=self.columnsWidths.count)
    {
        NSLog(@"不匹配");
        return;
    }
    
    self.lastRowHeight =42;
    uint dx = 0;
    
    NSMutableArray* labels = [NSMutableArray array];
    
    for(uint i=0; i<record.count; i++)
    {
        float colWidth = [[self.columnsWidths objectAtIndex:i] floatValue];//colwidth as given at setup
        CGRect rect = CGRectMake(dx, self.dy, colWidth,self.lastRowHeight);
        
        if(i>0)
        {
            rect.origin.x -= i;
        }
        
        NSString *oneRecord = [record objectAtIndex:i];
        
        if ([oneRecord isEqualToString:SwitchButtonString])
        {
            oneRecord = @"";
        }
        
        UILabel* col1 = [[UILabel alloc] init];
        [col1.layer setBorderColor:[[UIColor colorWithWhite:0.821 alpha:1.000]CGColor]];
        [col1.layer setBorderWidth:1.0];
        col1.font = [UIFont fontWithName:@"Helvetica" size:self.numRows ==0 ? 14.0f :12.0f];
        col1.textColor = [UIColor darkGrayColor];
        col1.frame = rect;
        
        if ([self isRoundCorner:i])
        {
            col1.layer.cornerRadius =5;
            col1.layer.masksToBounds =YES;
        }
        
        NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle]mutableCopy];
        style.alignment =NSTextAlignmentCenter;
        
        NSAttributedString *attrTex = [[NSAttributedString alloc]initWithString:oneRecord attributes:@{NSParagraphStyleAttributeName : style}];
        
        col1.lineBreakMode =NSLineBreakByCharWrapping;
        col1.numberOfLines = 0;
        col1.attributedText = attrTex;
        [col1 sizeToFit];
        
        CGFloat h = col1.frame.size.height +10;
        if(h > self.lastRowHeight){
            self.lastRowHeight = h;
        }
        
        rect.size.width = colWidth;
        col1.frame = rect;
        
        [labels addObject:col1];
        
        dx += colWidth;
    }
    
    for(uint i=0; i<labels.count; i++)
    {
        UILabel* tempLabel = (UILabel*)[labels objectAtIndex:i];
        CGRect tempRect = tempLabel.frame;
        tempRect.size.height =self.lastRowHeight;
        tempLabel.frame = tempRect;
        [self addSubview:tempLabel];
    }
    
    if ([record.firstObject isEqualToString:SwitchButtonString])
    {
        UILabel *firstlabel = labels.firstObject;
        UIButton *oneSwitchButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0,[self.columnsWidths.firstObject integerValue], 40)];
        oneSwitchButton.center = firstlabel.center;
        [oneSwitchButton addTarget:self action:@selector(tapedSwitchButton:) forControlEvents:UIControlEventTouchUpInside];
        [oneSwitchButton setBackgroundImage:self.selectedImage forState:UIControlStateSelected];
        [oneSwitchButton setBackgroundImage:self.unselectedImage forState:UIControlStateNormal];
        [self.switchButtons addObject:oneSwitchButton];
        
        if (self.switchButtons.firstObject == oneSwitchButton)
        {
            oneSwitchButton.selected = YES;
        }
        
        [self addSubview:oneSwitchButton];
    }
    
    self.numRows++;
    
    self.dy +=self.lastRowHeight-1;
    
    CGRect tempRect = self.frame;
    tempRect.size.height =self.dy;
    self.frame = tempRect;
    
    if (self.block) {
        self.block(self.dy);
    }
}

- (void)tapedSwitchButton:(UIButton *)button
{
    button.selected = !button.selected;
    
    [self.switchButtons enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop) {
        UIButton *oneButton = obj;
        
        if (oneButton != button)
        {
            oneButton.selected = NO;
        }
    }];
}

- (NSUInteger)selectedIndex
{
    __block NSUInteger index =0;
    
    [self.switchButtons enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop) {
        UIButton *oneButton = obj;
        
        if (oneButton.selected ==YES)
        {
            index = idx;
            *stop = YES;
        }
    }];
    return index;
}

- (BOOL)isRoundCorner:(NSInteger)row
{
    return NO;
}


@end
