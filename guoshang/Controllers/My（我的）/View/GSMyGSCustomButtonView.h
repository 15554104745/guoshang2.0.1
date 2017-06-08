//
//  GSMyGSCustomButtonView.h
//  guoshang
//
//  Created by Rechied on 16/7/28.
//  Copyright © 2016年 hi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GSMyGSCustomButtonView : UIView

@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *titleName;

- (instancetype)initWithTarget:(id)target action:(SEL)action imageName:(NSString *)imageName title:(NSString *)title tag:(NSInteger)tag;

@end
