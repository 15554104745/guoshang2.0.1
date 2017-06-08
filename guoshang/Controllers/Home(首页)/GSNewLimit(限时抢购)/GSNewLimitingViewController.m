//
//  GSNewLimitingViewController.m
//  guoshang
//
//  Created by 时礼法 on 16/11/21.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSNewLimitingViewController.h"
#import "GSNewLimiteTableViewCell.h"
#import "GSGoodsDetailInfoViewController.h"
#import "LimitSelectView.h"
#import "GSNewLimitModel.h"
#import "GSLimitSubModel.h"
#import "UIImageView+WebCache.h"


static NSString *Reuse = @"GSNewLimiteTableViewCell";
@interface GSNewLimitingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,strong)NSArray *SubdataArray;


@end

@implementation GSNewLimitingViewController
{
LimitSelectView *_selectView;

    BOOL cellsetNo;
    
    NSString *_buytype;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myTableView.backgroundColor = MyColor;
    
    cellsetNo = NO;
    //当正在抢购时间已过
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NoClickCell:) name:@"timeGone" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Firstbuytype:) name:@"buyType" object:nil];
    [self createTableView];
   
}

-(void)setDataArray:(NSMutableArray *)dataArray
{
    _dataArray = dataArray;
    GSNewLimitModel *model = _dataArray[0];
    _SubdataArray = model.goods_list;
}


-(void)createTableView{
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70.5, Width, Height - 134.5) style:UITableViewStylePlain];
    [self.myTableView registerNib:[UINib nibWithNibName:@"GSNewLimiteTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:Reuse];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    
    [self.view addSubview:self.myTableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    GSNewLimitModel *model = _dataArray[0];
    NSArray *subArr = model.goods_list;
    return subArr.count;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GSLimitSubModel *model = _SubdataArray[indexPath.row];
    GSNewLimiteTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:Reuse];
    [cell.goodImageView sd_setImageWithURL:[NSURL URLWithString:model.goods_img] placeholderImage:Goods_Pleaceholder_Image];
    cell.titlaLabel.text = [NSString stringWithFormat:@"%@",model.goods_name];
    cell.goodsPriceLabel.text = [NSString stringWithFormat:@"%@",model.shop_price];
    cell.sold_percent.text = [NSString stringWithFormat:@"%@",model.sold_percent];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([model.goods_number isEqualToString:@"0"]) {
        cell.goBuy.layer.borderColor = [UIColor grayColor].CGColor;
        cell.goBuy.text = @"已抢光";
        cell.goBuy.textColor = [UIColor grayColor];
        return cell;
    }
    
    if ([_buytype isEqualToString:@"1"] || [_buytype isEqualToString:@"2"]) {

        cell.goBuy.layer.borderColor = [UIColor redColor].CGColor;
        cell.goBuy.text = @"抢购中";
        cell.goBuy.textColor = [UIColor redColor];
        return cell;
        //已售完
    }else if([_buytype isEqualToString:@"0"])
    {
        cell.goBuy.layer.borderColor = [UIColor grayColor].CGColor;
        cell.goBuy.text = @"即将开始";
        cell.goBuy.textColor = [UIColor grayColor];
        return cell;
    }else
    {
        cell.goBuy.layer.borderColor = [UIColor grayColor].CGColor;
        cell.goBuy.text = @"时间结束";
        cell.goBuy.textColor = [UIColor grayColor];
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击cell  让颜色变回来
   
    
    if ([_buytype isEqualToString:@"1"] || [_buytype isEqualToString:@"2"]) {
        
        GSLimitSubModel *model = _SubdataArray[indexPath.row];
        if ([model.goods_number isEqualToString:@"0"]) {
            return;
        }else{
            GSGoodsDetailInfoViewController * gsvc = [[GSGoodsDetailInfoViewController alloc] init];
            gsvc.recommendModel = model;
            gsvc.hidesBottomBarWhenPushed = YES;
            [self.popView.navigationController pushViewController:gsvc animated:YES];
        }
    }else
    {
        return;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 120;
}

-(void)NoClickCell:(NSNotification *)notification
{
    cellsetNo = YES;
    [self.myTableView reloadData];
}

-(void)Firstbuytype:(NSNotification *)notification
{
    _buytype = [notification.userInfo objectForKey:@"buyType"];
    [self.myTableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"timeGone" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"buyType" object:nil];
}

-(NSArray *)SubdataArray
{
    if (_SubdataArray == nil) {
        _SubdataArray = [NSArray array];
    }
    return _SubdataArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
