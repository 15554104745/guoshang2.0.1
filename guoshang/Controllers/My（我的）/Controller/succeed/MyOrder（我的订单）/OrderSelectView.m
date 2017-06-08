//
//  OrderSelectView.m
//  guoshang
//
//  Created by 宗丽娜 on 16/3/1.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "OrderSelectView.h"

typedef void(^Block)(NSInteger index);
@implementation OrderSelectView
{
    Block _block;
    
    UIView * _barView;
    NSString *_number;//用来接收信息,作为中转变量用的

    
}
-(void)setIsOrder:(BOOL)isOrder{
    
    _isOrder = isOrder;
     [self createSelectView];
}
-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
       
        
    }
    return self;
}
-(void)createSelectView{
    self.backgroundColor = MyColor;
    NSInteger count;
  
    NSArray * title = [NSArray array];
    if (self.isOrder==YES) {
            NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"order"];
//          NSLog(@"^^%@",str);
        count = [str integerValue];
         title = @[@"全部",@"待付款",@"待发货",@"待确认",@"已完成"];
        
    }else{
        NSString * str = [[NSUserDefaults standardUserDefaults] objectForKey:@"listOrder"];
//        NSLog(@"^^oder%@",str);
        count = [str integerValue];
        title = @[@"精选",@"面包",@"蛋类",@"果汁",@"果蔬",@"更多"];
    }
   
    NSInteger titleCount = title.count;
    for (NSInteger i = 0; i < titleCount; i++) {
        //传值是否被选中 跳转的页面
        if (i ==count) {
         UIButton * btn = [self addBtnWithTitle:title[i] Target:self Action:@selector(btnClicked:) Frame:CGRectMake(i * ((self.frame.size.width-60) / titleCount+10), 0, (self.frame.size.width-60) / titleCount, self.frame.size.height) Tag:i + 100 Select:YES];
            if (!self.isOrder) {
                if (i <=4) {
                    UILabel * lab = [[UILabel alloc] init];
                    lab.backgroundColor = [UIColor grayColor];
                    [self addSubview:lab];
                    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(btn.mas_right).equalTo(@5);
                        make.top.equalTo(btn.mas_top).equalTo(@10);
                        make.bottom.equalTo(btn.mas_bottom).equalTo(@-10);
                        make.width.equalTo(@2);
                    }];
                }
            }
        }else{
       UIButton * btn = [self addBtnWithTitle:title[i] Target:self Action:@selector(btnClicked:) Frame:CGRectMake(i * ((self.frame.size.width-60) / titleCount+10), 0, (self.frame.size.width-60) / titleCount, self.frame.size.height) Tag:i + 100 Select:NO];
            if (!self.isOrder) {
                if (i <=4) {
                    UILabel * lab = [[UILabel alloc] init];
                    lab.backgroundColor = [UIColor grayColor];
                    [self addSubview:lab];
                    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.equalTo(btn.mas_right).equalTo(@5);
                        make.top.equalTo(btn.mas_top).equalTo(@10);
                        make.bottom.equalTo(btn.mas_bottom).equalTo(@-10);
                        make.width.equalTo(@2);
                    }];
    
                }
                }
            }
        
    }
    CGFloat hieght = self.frame.size.width / titleCount;
    
   _barView = [[UIView alloc] initWithFrame:CGRectMake(hieght * count, 30, hieght, 1)];
    
    _barView.backgroundColor = [UIColor colorWithRed:191/255.0 green:44/255.0 blue:43/255.0 alpha:1.0];
    
    [self addSubview:_barView];
  
}

- (UIButton *)addBtnWithTitle:(NSString *)title Target:(id)target Action:(SEL)action Frame:(CGRect)frame Tag:(NSInteger)tag  Select:(BOOL) select {
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitleColor:[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithRed:191/255.0 green:44/255.0 blue:43/255.0 alpha:1.0]forState:UIControlStateSelected];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.frame = frame;
    btn.tag = tag;
    btn.selected = select;
    [self addSubview:btn];
    
    return btn;
    
}
- (void)btnClicked:(UIButton *)btn {
    NSInteger number;
    if (_isOrder) {
        number = 5;
    }else{
        number = 6;
    }
    for (int i = 0; i< number; i++) {
        UIButton * button = [self viewWithTag:i + 100];
        if (i == btn.tag - 100) {
            button.selected = YES;
        }else{
          button.selected = NO;
        }
    }
    
    //当前_barView的中心
    CGPoint center = _barView.center;
    center.x = btn.center.x;
    [UIView animateWithDuration:0.5 animations:^{
        _barView.center = center;
        
    }];
    
    NSInteger index = btn.tag - 100;
    
    // 调用block运行
    if (_block) {
        _block(index);
    }
}


- (void)setCallbackBlock:(void(^)(NSInteger index))block {
    _block = [block copy];
}


- (void)selectBtn:(NSInteger)index {
    NSInteger number;
    if (_isOrder) {
        number = 5;
    }else{
        number = 6;
    }
    
    //循环遍历button 让button的颜色改变
    for (int i = 0; i< number; i++) {
        UIButton * button = [self viewWithTag:i + 100];
        if (i == index) {
            
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
    
    CGPoint center = _barView.center;
    UIButton * btn = [self viewWithTag:index + 100];
    center.x = btn.center.x;
[UIView animateWithDuration:0.5 animations:^{
        _barView.center = center;
    }];

}

-(void)toSelectBtn:(NSNotification *)noti{
//    NSLog(@"togj");
    _number = noti.object;
//    NSLog(@"$$$$%@",noti.userInfo[@"one"]);
    
//    NSInteger  count = [_number integerValue];

    
}
@end
