//
//  GSSingleSpecificationsView.m
//  guoshang
//
//  Created by Rechied on 2016/11/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSingleSpecificationsView.h"
#import "GSSpecificationsModel.h"
#import "GSSpecificationsDetailModel.h"

@interface GSSingleSpecificationsView()

@property (weak, nonatomic) GSSingleSpecificationsViewItemButton *selectItemButton;
@property (strong, nonatomic) NSMutableArray <__kindof GSSingleSpecificationsViewItemButton *>*itemButtonArray;

@end

@implementation GSSingleSpecificationsView

- (NSMutableArray *)itemButtonArray {
    if (!_itemButtonArray) {
        _itemButtonArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _itemButtonArray;
}

- (instancetype)initWithSpecificationsModel:(GSSpecificationsModel *)specificationsModel {
    self = [super init];
    if (self) {
        self.specificationsModel = specificationsModel;
        
        /**
         规格名称
         */
        UILabel *specificationsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        specificationsNameLabel.text = specificationsModel.f_name;
        specificationsNameLabel.textColor = [UIColor blackColor];
        specificationsNameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:specificationsNameLabel];
        
        BOOL  isLineReturn = NO;
        float upX = 10;
        float upY = 40;
        for (int i = 0; i < specificationsModel.attr_next.count; i++) {
            GSSpecificationsDetailModel *specificationsDetaiModel = specificationsModel.attr_next[i];
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
            CGSize size = [specificationsDetaiModel.object_name sizeWithAttributes:dic];
            
            if ( upX > (Width-20 -size.width-35)) {
                isLineReturn = YES;
                upX = 10;
                upY += 30;
            }
            
            GSSingleSpecificationsViewItemButton *specificationsViewItemButton= [GSSingleSpecificationsViewItemButton buttonWithType:UIButtonTypeCustom];
            specificationsViewItemButton.frame = CGRectMake(upX, upY, size.width+30,25);
            
            specificationsViewItemButton.specificationsDetailModel = specificationsDetaiModel;
            [specificationsViewItemButton setTitle:specificationsDetaiModel.object_name forState:UIControlStateNormal];
            [self addSubview:specificationsViewItemButton];
            
            
            [specificationsViewItemButton addTarget:self action:@selector(specificationsViewItemButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            upX+=size.width+35;
            [self.itemButtonArray addObject:specificationsViewItemButton];
        }
        
        upY +=30;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, upY + 10, self.frame.size.width, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        self.contentHeight = upY + 11;
    }
    return self;
}

- (void)specificationsViewItemButtonAction:(GSSingleSpecificationsViewItemButton *)itemButton {
    if (!itemButton.selected) {
        itemButton.selected = YES;
        [itemButton setBackgroundColor:[UIColor colorWithHexString:@"f23030"]];
        if ([_delegate respondsToSelector:@selector(singleSpecificationsViewDidSelectSpecificationsWithFid:attrbute_id:)]) {
            
            [_delegate singleSpecificationsViewDidSelectSpecificationsWithFid:self.specificationsModel.f_id attrbute_id:itemButton.specificationsDetailModel.attrbute_id];
        }
    } else {
        itemButton.selected = NO;
        //[_delegate singleSpecificationsViewDidSelectSpecificationsWithFid:self.specificationsModel.f_id attrbute_id:nil];
    }
    if (self.selectItemButton) {
        [self.selectItemButton setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
        self.selectItemButton.selected = NO;
    }
    if (self.selectItemButton == itemButton) {
        [_delegate singleSpecificationsViewDidDeSelectSpecificationsWithFid:self.specificationsModel.f_id];
    }
    self.selectItemButton = self.selectItemButton == itemButton ? nil : itemButton;
}

- (void)setCanUseSpecifications:(NSArray *)canUseSpecifications {
    
        [self.itemButtonArray enumerateObjectsUsingBlock:^(__kindof GSSingleSpecificationsViewItemButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (![canUseSpecifications containsObject:obj.specificationsDetailModel.attrbute_id]) {
                obj.enabled = NO;
                [obj setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            } else {
                obj.enabled = YES;
                [obj setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
            }
        }];
    
}

- (void)resetCanUseSpecifications {
    [self.itemButtonArray enumerateObjectsUsingBlock:^(__kindof GSSingleSpecificationsViewItemButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.enabled = YES;
        [obj setTitleColor:[UIColor colorWithHexString:@"242424"] forState:UIControlStateNormal];
    }];
}

@end

@implementation GSSingleSpecificationsViewItemButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType {
    GSSingleSpecificationsViewItemButton *itemButton = [super buttonWithType:buttonType];
    if (itemButton) {
        [itemButton setupAttrbutes];
    }
    return itemButton;
}

- (void)setupAttrbutes {
    [self setBackgroundColor:[UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1]];
    [self setTitleColor:[UIColor colorWithHexString:@"242424"] forState:0];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.layer.cornerRadius = 8;
    self.layer.borderColor = [UIColor clearColor].CGColor;
    self.layer.borderWidth = 0;
    [self.layer setMasksToBounds:YES];
}

@end
