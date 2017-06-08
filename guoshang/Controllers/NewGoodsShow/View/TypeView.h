//
//  TypeView.h
//  Demo
//
//  Created by JinLian on 16/8/9.
//  Copyright © 2016年 GroupFly. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TypeSeleteDelegete <NSObject>
-(void)btnindex:(int) tag;
@end

@interface TypeView : UIView

@property(nonatomic)float height;
@property(nonatomic)int seletIndex;

@property (nonatomic,retain) id<TypeSeleteDelegete> delegate;

-(instancetype)initWithFrame:(CGRect)frame andDatasource:(NSArray *)arr :(NSString *)typename;

@end
