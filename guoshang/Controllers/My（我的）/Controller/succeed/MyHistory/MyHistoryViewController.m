//
//  MyHistoryViewController.m
//  guoshang
//
//  Created by 张涛 on 16/3/14.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "MyHistoryViewController.h"
#import "MyCollectTableViewCell.h"
//#import "MyHistoryModel.m"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "MyHistoryModel.h"
#import "GSGoodsDetailInfoViewController.h"
@interface MyHistoryViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    BOOL isAllSelected;
    UITableView * _tableView;

    NSMutableArray * dataArray;
    // 要移除的数据
    NSMutableArray * removeArray;
    UIButton * editButton;
    UIButton * selectButton;
    UIButton * deleteButton;
    UILabel * selectAll;

}
@end

@implementation MyHistoryViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"浏览记录";
    isAllSelected = NO;

    dataArray = [[NSMutableArray alloc] init];
    removeArray = [[NSMutableArray alloc] init];

    [self createUI];

    [self dataInit];

}
// 初始化数据源
-(void)dataInit{
    NSString * userId = [NSString stringWithFormat:@"user_id=%@",UserId];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    [MBProgressHUD showHUDWithCustomAnimationAddedTo:nil];
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=User&a=UserBrowseGoods") parameters:@{@"token":encryptString} success:^(id responseObject) {
        for (NSDictionary *dic in responseObject[@"result"]) {
            [MBProgressHUD hideHUDForView:nil animated:YES];
            MyHistoryModel * model = [[MyHistoryModel alloc]initWithDictionary:dic];
            [dataArray addObject:model];
        }
        [_tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:nil animated:YES];
    }];
}

-(void)createUI{

    // 添加编辑按钮
    self.editButtonItem.title = @"编辑";
    self.navigationItem.rightBarButtonItem = self.editButtonItem;

    //创建tableview
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, Width, Height-64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.allowsMultipleSelectionDuringEditing=YES;
    _tableView.backgroundColor = MyColor;
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:_tableView];

    selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectButton.frame = CGRectMake(0, Height-114, Width/2, 50);
    [selectButton setTitle:@"全选" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selectButton.backgroundColor = [UIColor whiteColor];
    [selectButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];

    selectAll = [[UILabel alloc]initWithFrame:CGRectMake(Width/4-40, 15, 20, 20)];
    selectAll.layer.borderWidth = 1;
    selectAll.layer.cornerRadius = 10;
    selectAll.clipsToBounds = YES;
    selectAll.backgroundColor = [UIColor whiteColor];
    [selectButton addSubview:selectAll];

    deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteButton.frame = CGRectMake(Width/2, Height-114, Width/2, 50);
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    deleteButton.backgroundColor = [UIColor redColor];
    deleteButton.tag =11;
    [deleteButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -tableView协议方法

// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

// 返回cell表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加标识
    static NSString * cellId = @"cellId";

    // xib
    MyCollectTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"MyCollectTableViewCell" owner:self options:nil]lastObject];
        cell.titleLabel.text = [dataArray[indexPath.row] goods_name];
//        [cell.iconIV setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataArray[indexPath.row] goods_img]]]];
        [cell.iconIV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dataArray[indexPath.row] goods_img]]]placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
   //     NSString * exchange = [NSString stringWithString:(NSString *)[dataArray[indexPath.row] isCheck]];
//        if ([exchange isEqualToString:@"1"]) {
//            //国币
//            [cell.icon setImage:[UIImage imageNamed:@"guobi"]];
//            NSString * price = [NSString stringWithString:[[dataArray[indexPath.row] shop_price] substringFromIndex:1]];
//            cell.priceLabel.text = [NSString stringWithFormat:@"%@个",price];
//        }else if ([exchange isEqualToString:@"2"]){
//            //特卖
//            cell.priceLabel.text = [dataArray[indexPath.row] shop_price];
//        }else{
//            //金币
//            NSString * price = [NSString stringWithString:[[dataArray[indexPath.row] shop_price] substringFromIndex:1]];
//            cell.GBLabel.text = [NSString stringWithFormat:@"送%@国币",price];
//            cell.priceLabel.text = [dataArray[indexPath.row] shop_price];
//        }
    }
    return cell;
}

//每个cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

// 返回编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

// 编辑按钮触发的事件
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // 编辑按钮有两个字样Edit(此时editing=NO)  Done(此时editing为YES)
    // 调用父类方法
    [super setEditing:editing animated:animated];
    // tableView的编辑性打开 才可以进行编辑
    [_tableView setEditing:editing animated:animated];

    if (editing) {
        self.editButtonItem.title = @"完成";
        isAllSelected = NO;
        [self.view addSubview:selectButton];
        [self.view addSubview:deleteButton];
        _tableView.frame = CGRectMake(0, 0, Width, Height-114);
        if (!isAllSelected) {
            selectAll.backgroundColor = [UIColor whiteColor];
            selectAll.text = @" ";
        }
    } else {
        self.editButtonItem.title = @"编辑";
        [selectButton removeFromSuperview];
        [deleteButton removeFromSuperview];
        _tableView.frame = CGRectMake(0, 0, Width, Height-64);
        [removeArray removeAllObjects];
    }
}

// 点击cell选中触发的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        [removeArray addObject:indexPath];
    }else{
        //点击cell  让颜色变回来
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        GSGoodsDetailInfoViewController * show = [[GSGoodsDetailInfoViewController alloc] init];
        show.recommendModel = dataArray[indexPath.row];
        show.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:show animated:YES];
    }
}
// 取消选中状态触发的方法
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.editing) {
        if (isAllSelected) {
            isAllSelected = NO;
            [_tableView deselectRowAtIndexPath:indexPath animated:YES];
            [removeArray removeObjectAtIndex:indexPath.row];
            selectAll.backgroundColor = [UIColor whiteColor];
            selectAll.text = @" ";
        }else{
            [removeArray removeObject:indexPath];
        }
    }
}

//button点击事件
-(void)buttonClick:(UIButton *)button{
    //删除按钮
    if (button.tag == 11) {
        // 处于结束编辑
        if (removeArray.count !=0 || removeArray.count == dataArray.count) {
            //删除服务器上数据
            if ([self collectGoodsEdit]) {
                //对数组进行排序
                NSArray * array = [removeArray sortedArrayUsingSelector:@selector(compare:)];
                // 将要删除的数据移除
                for (NSInteger i = array.count-1 ; i >= 0; i--) {
                    // 移除数据
                    [dataArray removeObjectAtIndex:[array[i] row]];
                }
                [_tableView deleteRowsAtIndexPaths:removeArray withRowAnimation:UITableViewRowAnimationRight];

                // 移除掉之前删除过的数据
                [removeArray removeAllObjects];
            }
        }
    }else{
        isAllSelected = !isAllSelected;
        if (isAllSelected) {
            selectAll.backgroundColor = [UIColor blueColor];
            UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"40"]];
            [selectAll setBackgroundColor:color];
            selectAll.font = [UIFont systemFontOfSize:16];
            selectAll.textAlignment = NSTextAlignmentCenter;
            selectAll.textColor = [UIColor whiteColor];
            [removeArray removeAllObjects];
            //选中所有cell
            for (int i = 0; i < dataArray.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [removeArray addObject:indexPath];
                [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            }
        }else{
            selectAll.backgroundColor = [UIColor whiteColor];
            selectAll.text = @" ";
            for (int i = 0; i < dataArray.count; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
                [_tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
            [removeArray removeAllObjects];
        }
    }
}

-(BOOL)collectGoodsEdit{
    NSMutableString * rec_id = [[NSMutableString alloc]init];

    for (NSIndexPath * indexPath  in removeArray) {
//        NSLog(@"%ld",(long)indexPath.row);
        MyHistoryModel * model = dataArray[indexPath.row];
        [rec_id appendFormat:@"%@#",model.browse_id];
    }
    [rec_id substringToIndex:rec_id.length-1];
    NSString * userId = [NSString stringWithFormat:@"user_id=%@,browse_id=%@",UserId,rec_id];
    NSString * encryptString = [userId encryptStringWithKey:KEY];
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=user&a=DeleteUserBrowseGoods") parameters:@{@"token":encryptString} success:^(id responseObject) {
//        NSLog(@"%@",responseObject);
    } failure:^(NSError *error) {

    }];
    return YES;
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
