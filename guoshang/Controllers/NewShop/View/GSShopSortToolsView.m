//
//  GSShopSortToolsView.m
//  guoshang
//
//  Created by Rechied on 2016/11/3.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSShopSortToolsView.h"
#import "UIColor+HaxString.h"

@interface GSShopSortToolsView()<GSShopSortToolButtonDelegate>
@property (weak, nonatomic) GSShopSortToolButton *lastSortButton;
@end

@implementation GSShopSortToolsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithDelegate:(id <GSShopSortToolsViewDelegate>)delegate {
    self = [super init];
    if (self) {
        self.delegate = delegate;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self setupBottomLine];
    [self setupSortButton];
}

- (void)setupBottomLine {
    UIView *botLine = [[UIView alloc] init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"e3e5e9"];
    [self addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_offset(0);
        make.height.offset(0.5f);
    }];
}

- (void)initDefaultData {
    
}

- (void)setupSortButton {
    __block GSShopSortToolButton *lastButton = nil;
    NSArray *titleArray = @[@"按人气",@"按销量",@"按价格",@"筛选"];
    NSArray *sortParamsArray = @[@"click_count",@"last_update",@"shop_price"];
    [titleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GSShopSortToolButton *toolsButton = nil;
        
        if (obj == [titleArray lastObject]) {
            toolsButton = [GSShopSortToolButton buttonWithTitle:obj sortType:GSShopSortButtonSortTypeSiftNormal sortParamsString:@""];
            self.siftButton = toolsButton;
        } else {
            toolsButton = [GSShopSortToolButton buttonWithTitle:obj sortType:GSShopSortButtonSortTypeNormal sortParamsString:sortParamsArray[idx]];
        }
        
        toolsButton.delegate = self;
        
        if (obj == [titleArray firstObject]) {
            toolsButton.sortType = GSShopSortButtonSortTypeDown;
            self.lastSortButton = toolsButton;
        }
        
        
        [self addSubview:toolsButton];
        [toolsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_offset(0);
            if (lastButton) {
                make.left.equalTo(lastButton.mas_right);
                make.width.equalTo(lastButton.mas_width);
            } else {
                make.left.offset(0);
            }
            
            if (obj == [titleArray lastObject]) {
                make.right.offset(0);
            }
            lastButton = toolsButton;
        }];
        
    }];
}

#pragma mark - GSShopSortToolButtonDelegate
- (void)shopSortButton:(GSShopSortToolButton *)shopSortButton didSelectWithSortParams:(NSString *)sortParams sortTypeStr:(NSString *)sortTypeStr {
    if (self.lastSortButton && self.lastSortButton != shopSortButton) {
        self.lastSortButton.sortType = GSShopSortButtonSortTypeNormal;
        self.lastSortButton = shopSortButton;
    }
    
    
    if ([_delegate respondsToSelector:@selector(shopSortToolsViewDidChangeSortWithSortParams:sortTypeStr:)]) {
        [_delegate shopSortToolsViewDidChangeSortWithSortParams:sortParams sortTypeStr:sortTypeStr];
    }
}


- (void)shopSortSiftButtonDidClickWithSortType:(GSShopSortButtonSortType)sortType {
    if ([_delegate respondsToSelector:@selector(shopSiftButtonDidClick:sortType:)]) {
        [_delegate shopSiftButtonDidClick:self.siftButton sortType:sortType];
    }
}

@end


