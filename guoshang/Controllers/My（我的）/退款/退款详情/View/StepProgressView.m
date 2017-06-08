//
//  StepProgressView.m
//  Progress
//
//  Created by JinLian on 16/9/23.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import "StepProgressView.h"

static const float imgBtnWidth = 18;    //圆点大小
static const float progress_y = 15;     //进度条位置
static const float progress_H = 2.0;    //进度条高度

#define kUIColorFromRGBValue(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface StepProgressView ()

@property (nonatomic,strong) UIProgressView *progressView;

//用UIButton防止以后有点击事件
@property (nonatomic,strong) NSMutableArray *imgBtnArray;

@end

@implementation StepProgressView


+(instancetype)progressViewFrame:(CGRect)frame withTitleArray:(NSArray *)titleArray
{
    StepProgressView *stepProgressView=[[StepProgressView alloc]initWithFrame:frame];
    //进度条
    stepProgressView.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(20, progress_y, frame.size.width-40, progress_H)];
    stepProgressView.progressView.progressViewStyle=UIProgressViewStyleBar;
    stepProgressView.progressView.transform = CGAffineTransformMakeScale(1.0f,0.6f);
    stepProgressView.progressView.progressTintColor= kUIColorFromRGBValue(0xe73736) ;
    stepProgressView.progressView.trackTintColor= [UIColor whiteColor];
    stepProgressView.progressView.progress=1;
    [stepProgressView addSubview:stepProgressView.progressView];
    
    
    stepProgressView.imgBtnArray=[[NSMutableArray alloc]init];
//    NSArray *images = @[@"round_icon_white",@"round_icon_white",@"round_icon_white"];
//    NSArray *selectImages = @[@"round_icon_red",@"round_icon_red",@"round_icon_red"];
    float _btnWidth=frame.size.width/(titleArray.count);
    float progressStep = (frame.size.width-40) / (titleArray.count - 1);
    for (int i=0; i<titleArray.count; i++) {
        //图片按钮
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"round_icon_white"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"round_icon_red"] forState:UIControlStateSelected];
//        NSLog(@"%f",20 + progressStep*i);
        btn.frame=CGRectMake(15 + progressStep*i, progress_y-(imgBtnWidth-progress_H)/2, imgBtnWidth, imgBtnWidth);
        btn.layer.cornerRadius = btn.frame.size.width/2;
        btn.selected=YES;
        
        [stepProgressView addSubview:btn];
        [stepProgressView.imgBtnArray addObject:btn];
        
        //文字
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.text=[titleArray objectAtIndex:i];
        [titleLabel setTextColor:[UIColor whiteColor]];
        titleLabel.font=[UIFont systemFontOfSize:11];
        [stepProgressView addSubview:titleLabel];
        if (i == 0) {
            titleLabel.textAlignment=NSTextAlignmentLeft;
            titleLabel.frame = CGRectMake(btn.frame.origin.x, 25, _btnWidth, 20);
        }else if (i == titleArray.count - 1) {
            titleLabel.textAlignment=NSTextAlignmentRight;
            titleLabel.frame = CGRectMake(btn.frame.origin.x+btn.frame.size.width-_btnWidth, 25, _btnWidth, 20);
        }else {
            titleLabel.textAlignment=NSTextAlignmentCenter;
            titleLabel.frame = CGRectMake(btn.center.x-_btnWidth/2, 25, _btnWidth, 20);
        }
    }
    stepProgressView.stepIndex=-1;
    return stepProgressView;
    
}
-(void)setStepIndex:(NSInteger)stepIndex
{
    //  默认为－1 小于－1为－1 大于总数为总数
    _stepIndex=stepIndex<-1?-1:stepIndex;
    _stepIndex=stepIndex >=(NSInteger)_imgBtnArray.count-1?_imgBtnArray.count-1:stepIndex;
    float _btnWidth=self.bounds.size.width/(_imgBtnArray.count);
    for (int i=0; i<_imgBtnArray.count; i++) {
        UIButton *btn=[_imgBtnArray objectAtIndex:i];
        if (i<=_stepIndex) {
            btn.selected=YES;
        }
        else{
            btn.selected=NO;
        }
    }
    if (_stepIndex==-1) {
        self.progressView.progress=0.0;
    }
    else if (_stepIndex==_imgBtnArray.count-1)
    {
        self.progressView.progress=1.0;
    }
    else
    {
        self.progressView.progress=(0.5+_stepIndex)*_btnWidth/self.frame.size.width;
    }
}



@end
