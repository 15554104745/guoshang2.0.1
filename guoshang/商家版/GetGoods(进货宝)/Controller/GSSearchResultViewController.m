//
//  GSSearchResultViewController.m
//  guoshang
//
//  Created by chenl on 16/8/24.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "GSSearchResultViewController.h"
#import "ShoppingTableViewCell.h"
#import "ShoppingCollectionViewCell.h"
#import "GoodsShowViewController.h"
#import "ClassifyViewController.h"
#import "GSGoodsDetailInfoViewController.h"
#import "GoodsDetailViewController.h"

@interface GSSearchResultViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL isChanged;
    BOOL isSifted;
    
    BOOL pop;
    BOOL sal;
    BOOL pri;
    
    BOOL is_down;
    
    //确定按钮
    UIButton * _certainButton;
    //折叠按钮的状态
    BOOL bsFolded;//品牌
    BOOL clFolded;//分类
    
    UIView * downView;
    
    NSString * brandTitle;
    
    //按钮名数组
    NSMutableArray * menuArray;
    
    NSArray * coinArr;         //币类型
    NSMutableArray * brandArr1;//品牌总数据
    NSMutableArray * classArr1;//分类总数据
}

#define scale Width/414.0
@end

@implementation GSSearchResultViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [downView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MyColor;
    [self dataInit];
    
    [self createUI];
    
    [self refreshView];
    
    [self.collectionView.mj_header beginRefreshing];
}

//参变量初始化
-(void)dataInit{
    //    isCome = NO;
    isChanged = NO;
    isSifted  = NO;
    bsFolded  = NO;
    clFolded  = NO;
    is_down = NO;
    
    _page = 1;
    
    menuArray = [[NSMutableArray alloc]initWithObjects:@"分类:",@"品牌:",@"销售类别:", nil];
    
    _brandArray = [[NSMutableArray alloc]init];
    _classArray = [[NSMutableArray alloc]init];
    coinArr = [[NSArray alloc]initWithObjects:@"国币"@"金币", nil];
    
    _dataArray = [[NSMutableArray alloc]init];
    _popArray  = [[NSMutableArray alloc]init];
    _salArray  = [[NSMutableArray alloc]init];
    _priArray  = [[NSMutableArray alloc]init];
    _classTitle = [[NSString alloc]init];
    brandTitle = [[NSString alloc]init];
    
    _keywords= [[NSString alloc]init];
    _cat_id  = [[NSString alloc]init];
    _brand   = [[NSString alloc]init];
    _order   = [[NSString alloc]init];
    _sort    = [[NSString alloc]init];
    _url     = URLDependByBaseURL(@"/Api/Repository/GoodsList");
    
}

//网络数据请求
-(void)allDataInit{
    
    UIButton * btn = [self.view viewWithTag:10];
    UIButton * btn1 = [self.view viewWithTag:11];
    UIButton * btn2 = [self.view viewWithTag:12];
    //总数据  @"is_exchange":_is_exchange,
    NSString * page = [NSString stringWithFormat:@"%ld",_page*10];

        if (_keywords.length) {
            _parameters = @{
                            @"page":page,
                            @"keywords":_keywords};
        }else{
            _parameters = @{
                            @"page":page};
        }
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:_url parameters:_parameters success:^(id responseObject) {
        if (weakSelf.page == 1) {
            [weakSelf.dataArray removeAllObjects];
        }
       
        for (NSDictionary * dic in responseObject[@"result"]) {
            GoodsDetailModel * model = [[GoodsDetailModel alloc]initWithDictionary:dic error:nil];
//            _is_exchange = model.is_exchange;
            [weakSelf.dataArray addObject:model];
        }
        if (_dataArray.count==0) {
            UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:@"该类商品暂时无货,敬请期待!" delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
            [NSTimer scheduledTimerWithTimeInterval:3.0f
                                             target:weakSelf
                                           selector:@selector(timerFireMethod:)
                                           userInfo:promptAlert
                                            repeats:NO];
            [promptAlert show];
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.tableView reloadData];
        btn.userInteractionEnabled  = YES;
        btn1.userInteractionEnabled = YES;
        btn2.userInteractionEnabled = YES;
        
        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
        if (weakSelf.classArray.count == 0) {
            weakSelf.classArray = [[NSMutableArray alloc]init];
            //分类
//            for (NSDictionary * dic in responseObject[@"result"][@"select"][@"category"]) {
//                CategoryModel * model = [[CategoryModel alloc]initWithDictionary:dic error:nil];
//                [self.classArray addObject:model];
//            }
            
        }
    } failure:^(NSError *error) {
        // 停止刷新
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.collectionView.mj_header endRefreshing];
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
    
}
//品牌数据请求
-(void)brandData{
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=Category&a=category")  parameters:@{@"cat_id":_cat_id,@"is_exchange":_is_exchange} success:^(id responseObject) {
        
        weakSelf.brandArray = [[NSMutableArray alloc]init];
        
        for (NSDictionary * dic in responseObject[@"result"][@"select"][@"brand"]) {
            BrandModel * model = [[BrandModel alloc]init];
            model.brand_id = dic[@"brand_id"];
            model.brand_name = dic[@"brand_name"];
            model.goods_num = [NSString stringWithFormat:@"%@",dic[@"goods_num"]];
            [weakSelf.brandArray addObject:model];
        }
        for (int i = 300; i < _classArray.count+300; i++) {
            UIButton * btn = [weakSelf.view viewWithTag:i];
            btn.userInteractionEnabled = YES;
        }
        brandArr1 = [[NSMutableArray alloc]initWithArray:_brandArray];
        [weakSelf siftDataInit];
        [_menuView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    } failure:^(NSError *error) {
        
    }];
    
}

-(void)siftDataInit{
    if (!bsFolded) {
        NSInteger temp = _brandArray.count;
        if (temp>4) {
            for (int i =4; i<temp; i++) {
                [_brandArray removeObjectAtIndex:4];
            }
        }
    }
    if (!clFolded) {
        NSInteger temp1 = _classArray.count;
        if (temp1>4) {
            classArr1 = [[NSMutableArray alloc]initWithArray:_classArray];
            for (int i =4; i<temp1; i++) {
                [_classArray removeObjectAtIndex:4];
            }
        }
    }
}

//界面创建
-(void)createUI{
    self.title = @"搜索结果";
    
    UIBarButtonItem * backItem = [UIBarButtonItem barButtonItemWithBackgroundImage:[UIImage imageNamed:@"fanhui"] highlightedImage:nil target:self action:@selector(toHome:) forControlEvents:
                                  UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIView * buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 35)];
    buttonsView.backgroundColor = MyColor;
    [self.view addSubview:buttonsView];
    
    NSInteger len = Width/5-2;
    
    UIButton * popularButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popularButton.frame = CGRectMake(10, 5, len-10, 25);
    [popularButton setTitle:@"按人气" forState:UIControlStateNormal];
    [popularButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [popularButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [popularButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -len/5, 0, 0)];
    popularButton.titleLabel.font = [UIFont systemFontOfSize:14];
    popularButton.tag = 10;
    [popularButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:popularButton];
    
    UIButton * salesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    salesButton.frame = CGRectMake(len+10, 5, len-10, 25);
    [salesButton setTitle:@"按销量" forState:UIControlStateNormal];
    [salesButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [salesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [salesButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -len/5, 0, 0)];
    salesButton.titleLabel.font = [UIFont systemFontOfSize:14];
    salesButton.tag = 11;
    [salesButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:salesButton];
    
    UIButton * priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    priceButton.frame = CGRectMake(len*2+10, 5, len-10, 25);
    [priceButton setTitle:@"按价格" forState:UIControlStateNormal];
    [priceButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    [priceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [priceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -len/5, 0, 0)];
    priceButton.titleLabel.font = [UIFont systemFontOfSize:14];
    priceButton.tag = 12;
    [priceButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:priceButton];
    //筛选按钮
    _siftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _siftButton.frame = CGRectMake( CGRectGetMaxX(priceButton.frame)+5, 5, len, 25);
    [_siftButton setTitle:@"筛选" forState:UIControlStateNormal];
    [_siftButton setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
    //    _siftButton.selected = NO;
    [_siftButton setImage:[UIImage imageNamed:@"zhengxu"] forState:UIControlStateNormal];
    [_siftButton setBackgroundImage:[self buttonImageFromColor:[UIColor colorWithRed:243/255.0 green:105/255.0 blue:50/255.0 alpha:1]] forState:UIControlStateSelected];
    [_siftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_siftButton setImage:[UIImage imageNamed:@"daoxu"] forState:UIControlStateSelected];
    [_siftButton setTitleEdgeInsets:UIEdgeInsetsMake(0,0 ,0, 25)];
    [_siftButton setImageEdgeInsets:UIEdgeInsetsMake(0, len/5*4, 0, 0)];
    _siftButton.titleLabel.font = [UIFont systemFontOfSize:14];
    _siftButton.tag = 13;
    [_siftButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:_siftButton];
    //切换布局按钮
    UIButton * changeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changeButton setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    [changeButton setImage:[UIImage imageNamed:@"iconfont"] forState:UIControlStateSelected];
    changeButton.frame = CGRectMake(len*4+40, 5, len-45, 25);
    changeButton.tag = 14;
    [changeButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonsView addSubview:changeButton];
    
    //TableView
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, Width, Height-143) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.backgroundColor = MyColor;
    _tableView.showsVerticalScrollIndicator = NO;
    
    //CollectionView
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=1;//左右间隔
    flowLayout.minimumLineSpacing=5;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 35, Width, Height-90) collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    _collectionView.backgroundColor = MyColor;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    UINib *nib = [UINib nibWithNibName:@"ShoppingCollectionViewCell" bundle:nil];
    [self.collectionView registerNib: nib forCellWithReuseIdentifier:@"cellID"];
    [self.view addSubview:_collectionView];
    
}

//创建筛选下拉菜单
-(void)createDropMenu{
    [self siftDataInit];
    _menuView = [[UITableView alloc]initWithFrame:CGRectMake(0, 35, Width, 340) style:UITableViewStyleGrouped];
    _menuView.backgroundColor = [UIColor whiteColor];
    _menuView.delegate = self;
    _menuView.dataSource =self;
    _menuView.showsVerticalScrollIndicator = NO;
    _menuView.bounces = NO;
    [self.view addSubview:_menuView];
    
}

- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext(); return img;
}

#pragma mark -tableView协议方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:_menuView] && [_is_exchange isEqual:@0]) {
        return 3;
    }else if ([tableView isEqual:_menuView] && [_is_exchange isEqual:@1] ){
        return 2;
    }
    return 1;
}
// 每组多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_menuView]) {
        return 1;
    }else if ([tableView isEqual:_tableView]){
        return _dataArray.count;
    }else return 0;
}
// 返回cell表格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_menuView]){
        // 添加标识
        static NSString * cellId = @"cell";
        
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        NSInteger len = Width /4;
        int i= 0;
        if (indexPath.section == 0){
            for (CategoryModel * model in _classArray) {
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame =CGRectMake(i%4*(len-5)+20, i/4*40+10, len-13, 25);
                [button setTitle:model.cat_name forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                button.titleLabel.adjustsFontSizeToFitWidth = YES;//字体大小自适应
                if ([model.selected isEqualToNumber:@1]) {
                    button.selected = YES;
                }else{
                    button.selected = NO;
                }
                button.backgroundColor = [UIColor orangeColor];
                //                if (button.selected) {
                //                    button.backgroundColor = [UIColor redColor];
                //                }else{
                //                    button.backgroundColor = [UIColor orangeColor];
                //                }
                button.layer.cornerRadius = 5;
                button.tag = 300+i;
                [button addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                
                i++;
            }
        }else if (indexPath.section == 1) {
            for (BrandModel * model in _brandArray) {
                UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame =CGRectMake(i%4*(len-5)+20, i/4*40+10, len-13, 25);
                [button setTitle:model.brand_name forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:12];
                button.titleLabel.adjustsFontSizeToFitWidth = YES;//字体大小自适应
                if ([model.selected isEqualToNumber:@1]) {
                    button.selected = YES;
                }else{
                    button.selected = NO;
                }
                button.backgroundColor = [UIColor orangeColor];
                //                if (button.selected) {
                //                    button.backgroundColor = [UIColor redColor];
                //                }else{
                //                    button.backgroundColor = [UIColor orangeColor];
                //                }
                button.layer.cornerRadius = 5;
                button.tag = 200+i;
                [button addTarget:self action:@selector(brandButton:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:button];
                i++;
            }
        }else if ([_is_exchange isEqual:@0] && indexPath.section == 2) {
            UIButton * guoCoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
            guoCoinButton.frame = CGRectMake(20, 15, Width/2-50, 30);
            guoCoinButton.backgroundColor = [UIColor orangeColor];
            [guoCoinButton setTitle:@"国 币" forState:UIControlStateNormal];
            guoCoinButton.titleLabel.font = [UIFont systemFontOfSize:14];
            guoCoinButton.layer.cornerRadius = 5;
            guoCoinButton.tag = 23;
            [guoCoinButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:guoCoinButton];
            
            UIButton * goldCoinButton = [UIButton buttonWithType:UIButtonTypeCustom];
            goldCoinButton.frame = CGRectMake(Width/2+25, 15, Width/2-50, 30);
            if (goldCoinButton.selected) {
                goldCoinButton.backgroundColor = [UIColor redColor];
            }else{
                goldCoinButton.backgroundColor = [UIColor orangeColor];
            }
            [goldCoinButton setTitle:@"金 币" forState:UIControlStateNormal];
            goldCoinButton.titleLabel.font = [UIFont systemFontOfSize:14];
            goldCoinButton.layer.cornerRadius = 5;
            goldCoinButton.tag = 24;
            [goldCoinButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:goldCoinButton];
            
        }
        return cell;
    }else if ([tableView isEqual:_tableView]) {
        // 添加标识
        static NSString * cellId = @"cellId";
        // 在复用池中查找
        ShoppingTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        // 找不到创建
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingTableViewCell" owner:self options:nil] lastObject];
        }
        if ([[_dataArray[0] is_exchange] isEqualToNumber:@0]) {
            //金币
            [cell configGoldCellWithModel:_dataArray[indexPath.row]];
        }else if ([[_dataArray[0] is_exchange] isEqualToNumber:@1]){
            //国币
            [cell configGuoCellWithModel:_dataArray[indexPath.row]];
        }
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    } else {
        return nil;
    }
}
//cell高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:_tableView]) {
        return 120;
    }else if ([tableView isEqual:_menuView]){
        CGFloat height = 0.0;
        if ([_is_exchange isEqual:@0]) {
            if (indexPath.section == 0) {
                height = ((_classArray.count-1)/4+1) *40+10;
            }else if (indexPath.section == 1) {
                height = ((_brandArray.count-1)/4+1) *40+10;
            }else if (indexPath.section == 2) {
                height = 50;
            }
        }else if ([_is_exchange isEqual:@1]) {
            if (indexPath.section == 0) {
                height = ((_classArray.count-1)/4+1) *40+10;
            }else if (indexPath.section == 1) {
                height = ((_brandArray.count-1)/4+1) *40+10;
            }
        }
        
        return height;
    }
    return 0;
}

- (void)pushToGoodsDetailWithGoodsModel:(GoodsDetailModel *)goodsModel {
    GSGoodsDetailInfoViewController *detailInfoViewController = [[GSGoodsDetailInfoViewController alloc] init];
    detailInfoViewController.recommendModel = goodsModel;
    detailInfoViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailInfoViewController animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.delaysContentTouches = NO;
    if ([tableView isEqual:_tableView]) {
        //点击cell  让颜色变回来
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self pushToGoodsDetailWithGoodsModel:_dataArray[indexPath.row]];
    }else if ([tableView isEqual:_menuView]){
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
}
//头视图
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:_menuView]) {
        UIView * header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 30)];
        header.backgroundColor = MyColor;
        
        if (section == 0) {
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 50, 20)];
            titleLabel.text = [menuArray objectAtIndex:section];
            titleLabel.textColor = [UIColor grayColor];
            [header addSubview:titleLabel];
            
            UIButton * foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
            foldButton.frame = CGRectMake(Width-40, 5, 30, 20);
            foldButton.tag = 100;
            [foldButton setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
            [foldButton setImage:[UIImage imageNamed:@"he"] forState:UIControlStateSelected];
            //            [foldButton setTitle:@"展开" forState:UIControlStateNormal];
            //            [foldButton setTitle:@"收起" forState:UIControlStateSelected];
            //            [foldButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //            [foldButton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
            [foldButton addTarget:self action:@selector(clickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:foldButton];
            
            UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 80, 20)];
            showLabel.tag = 110;
            if (_classTitle.length) {
                showLabel.font = [UIFont systemFontOfSize:12];
                showLabel.layer.borderWidth = 1;
                showLabel.layer.borderColor = [UIColor redColor].CGColor;
                showLabel.layer.cornerRadius = 5;
                showLabel.layer.masksToBounds = YES;
                showLabel.textAlignment = NSTextAlignmentCenter;
                showLabel.text = _classTitle;
                showLabel.textColor = [UIColor redColor];
            }
            [header addSubview:showLabel];
        }else if (section == 1) {
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 50, 20)];
            titleLabel.text = [menuArray objectAtIndex:section];
            titleLabel.textColor = [UIColor grayColor];
            [header addSubview:titleLabel];
            
            UIButton * foldButton = [UIButton buttonWithType:UIButtonTypeCustom];
            foldButton.frame = CGRectMake(Width-40, 10, 30, 10);
            foldButton.tag = 101;
            [foldButton setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
            [foldButton setImage:[UIImage imageNamed:@"he"] forState:UIControlStateSelected];
            [foldButton addTarget:self action:@selector(clickHeaderButton:) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:foldButton];
            
            UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 80, 20)];
            showLabel.tag = 111;
            if (brandTitle.length) {
                showLabel.font = [UIFont systemFontOfSize:12];
                showLabel.layer.borderWidth = 1;
                showLabel.layer.borderColor = [UIColor redColor].CGColor;
                showLabel.layer.cornerRadius = 5;
                showLabel.layer.masksToBounds = YES;
                showLabel.textAlignment = NSTextAlignmentCenter;
                showLabel.text = brandTitle;
                showLabel.textColor = [UIColor redColor];
            }
            [header addSubview:showLabel];
        }else if ([_is_exchange isEqual:@0] && section == 2) {
            UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 20)];
            titleLabel.text = [menuArray objectAtIndex:section];
            titleLabel.textColor = [UIColor grayColor];
            [header addSubview:titleLabel];
            
            UILabel * showLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 80, 20)];
            showLabel.tag = 112;
            [header addSubview:showLabel];
        }
        return header;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ([_is_exchange isEqual:@0] && section == 2) {
        //金币
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 80)];
        footerView.userInteractionEnabled = YES;
        //确定按钮
        _certainButton= [UIButton buttonWithType:UIButtonTypeCustom];
        _certainButton.frame = CGRectMake(20, 25, Width-40, 40);
        _certainButton.backgroundColor = [UIColor redColor];
        _certainButton.tag = 22;
        [_certainButton setTitle:@"确 定" forState:UIControlStateNormal];
        _certainButton.layer.cornerRadius = 8;
        _certainButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_certainButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_certainButton];
        
        return footerView;
    }else if ([_is_exchange isEqual:@1] && section == 1){
        //国币
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width, 80)];
        //确定按钮
        _certainButton= [UIButton buttonWithType:UIButtonTypeCustom];
        _certainButton.frame = CGRectMake(20, 25, Width-40, 40);
        _certainButton.backgroundColor = [UIColor redColor];
        _certainButton.tag = 22;
        [_certainButton setTitle:@"确 定" forState:UIControlStateNormal];
        _certainButton.layer.cornerRadius = 8;
        _certainButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_certainButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:_certainButton];
        return footerView;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([tableView isEqual:_menuView]) {
        return 30;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2 && [_is_exchange isEqual:@0] ) {
        return 80;
    }else if(section == 1 && [_is_exchange isEqual:@1]){
        return 80;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:_menuView]) {
        NSString *sectionName = [menuArray objectAtIndex:section] ;
        
        return sectionName;
    }
    return nil;
    
}

#pragma mark -collectionView的协议方法

// 返回多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  _dataArray.count;
}
// 3.返回小单元cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 添加标识
    NSString * cellId = @"cellID";
    // Xib
    ShoppingCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    // 赋值
    NSString * urlStr = [_dataArray[indexPath.row] goods_img];
    [cell.iconView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"ic_load_image_pleaceholder"]];
    cell.detailLabel.text = [_dataArray[indexPath.row] goods_name];
    if ([[_dataArray[0] is_exchange] isEqualToNumber:@0]) {
        //金币
        cell.priceLabel.text = [NSString stringWithFormat:@"%@",[_dataArray[indexPath.row] shop_price]];
    }else if ([[_dataArray[0] is_exchange] isEqualToNumber:@1]){
        //国币
        [cell.coinView setImage:[UIImage imageNamed:@"guobi"]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@个",[_dataArray[indexPath.row] shop_price]];
    }
    [cell.saledLabel removeFromSuperview];
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}
// 选中某个item触发的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //点击item  让颜色变回来
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    if([self.url rangeOfString:@"is_exchange"].location !=NSNotFound)//_roaldSearchText
    {
        GoodsDetailViewController * gsvc = [GoodsDetailViewController createGoodsDetailView];
        gsvc.hidesBottomBarWhenPushed = YES;
        //    NSLog(@"%@",self.url);
        gsvc.goodsId = [_dataArray[indexPath.row] goods_id];
        gsvc.from = @"1";
        [self.navigationController pushViewController:gsvc animated:YES];
    }
    else
    {
        [self pushToGoodsDetailWithGoodsModel:_dataArray[indexPath.row]];
    }
    
}


#pragma mark- flowout的协议方法
// 设置每个视图与其他视图的间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    // 上左下右
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
// 设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(Width/2-15, 255*scale);
}



//按钮点击事件
- (void)buttonClick:(UIButton *)button{
    UIButton * btn = [self.view viewWithTag:10];
    UIButton * btn1 = [self.view viewWithTag:11];
    UIButton * btn2 = [self.view viewWithTag:12];
    switch (button.tag) {
        case 10:
        {
            pop = !pop;
            button.selected = YES;
            _dataArray = _popArray;
            button.userInteractionEnabled = NO;
            _tableView.userInteractionEnabled = YES;
            _collectionView.userInteractionEnabled = YES;
            if (!pop) {
                [button setBackgroundImage:[UIImage imageNamed:@"zeng"] forState:UIControlStateSelected];
                _order = [NSMutableString stringWithString:@"DESC"];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateSelected];
                _order = [NSMutableString stringWithString:@"ASC"];
            }
            _sort = @"click_count";
            [_dataArray removeAllObjects];
            [self allDataInit];
            btn1.selected = NO;
            btn2.selected = NO;
            [btn1 setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
            //            NSLog(@"按人气");
        }
            break;
        case 11:
        {
            sal = !sal;
            button.selected = YES;
            button.userInteractionEnabled = NO;
            _tableView.userInteractionEnabled = YES;
            _collectionView.userInteractionEnabled = YES;
            if (!sal) {
                [button setBackgroundImage:[UIImage imageNamed:@"zeng"] forState:UIControlStateSelected];
                _order = [NSMutableString stringWithString:@"DESC"];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateSelected];
                _order = [NSMutableString stringWithString:@"ASC"];
            }
            _sort = @"last_update";
            [_dataArray removeAllObjects];
            [self allDataInit];
            btn.selected = NO;
            btn2.selected = NO;
            [btn setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
            [btn2 setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
            //            NSLog(@"按销量");
        }
            break;
        case 12:
        {
            pri = !pri;
            button.selected = YES;
            button.userInteractionEnabled = NO;
            _tableView.userInteractionEnabled = YES;
            _collectionView.userInteractionEnabled = YES;
            if (!pri) {
                [button setBackgroundImage:[UIImage imageNamed:@"zeng"] forState:UIControlStateSelected];
                _order = [NSMutableString stringWithString:@"DESC"];
            }else{
                [button setBackgroundImage:[UIImage imageNamed:@"jian"] forState:UIControlStateSelected];
                _order = [NSMutableString stringWithString:@"ASC"];
            }
            _sort = @"shop_price";
            [_dataArray removeAllObjects];
            [self allDataInit];
            btn1.selected = NO;
            btn.selected = NO;
            [btn setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
            [btn1 setTitleColor:[UIColor colorWithRed:111/255.0 green:111/255.0 blue:111/255.0 alpha:1] forState:UIControlStateNormal];
            //            NSLog(@"按价格");
        }
            break;
        case 13:
            //筛选
            isSifted = !isSifted;
            _siftButton.selected = isSifted;
            if (isSifted) {
                [self createDropMenu];
                btn.userInteractionEnabled = NO;
                btn1.userInteractionEnabled = NO;
                btn2.userInteractionEnabled = NO;
                _tableView.userInteractionEnabled = NO;
                _collectionView.userInteractionEnabled = NO;
            }else{
                [_menuView removeFromSuperview];
                btn.userInteractionEnabled = YES;
                btn1.userInteractionEnabled = YES;
                btn2.userInteractionEnabled = YES;
                _tableView.userInteractionEnabled = YES;
                _collectionView.userInteractionEnabled = YES;
            }
            break;
        case 14:
            //切换布局
            isChanged = !isChanged;
            button.selected = isChanged;
            if (isChanged) {
                [_collectionView removeFromSuperview];
                [self.view addSubview:_tableView];
            }else{
                [_tableView removeFromSuperview];
                [self.view addSubview:_collectionView];
            }
            if (isSifted) {
                isSifted = !isSifted;
                [_menuView removeFromSuperview];
            }
            _tableView.userInteractionEnabled = YES;
            _collectionView.userInteractionEnabled = YES;
            break;
            
        default:
            break;
    }
}

-(void)dmButton:(UIButton *)button{
    
    
    UIButton * btn = [_menuView viewWithTag:24];
    UIButton * btn1 = [_menuView viewWithTag:23];
    
    UILabel * label = [_menuView viewWithTag:112];
    label.font = [UIFont systemFontOfSize:12];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    
    switch (button.tag) {
        case 22:
        {
            _classTitle = nil;
            brandTitle = nil;
            
            isSifted = !isSifted;
            button.selected = isSifted;
            [_menuView removeFromSuperview];
            _tableView.userInteractionEnabled = YES;
            _collectionView.userInteractionEnabled = YES;
            [_dataArray removeAllObjects];
            [self allDataInit];
        }
            //            NSLog(@"确定");
            
            break;
        case 23:
            button.selected = !button.selected;
            //            if (button.selected) {
            //                button.backgroundColor = [UIColor redColor];
            //            }else{
            //                button.backgroundColor = [UIColor orangeColor];
            //            }
            btn.selected = NO;
            //            btn.backgroundColor = [UIColor orangeColor];
            _is_exchange = @1;
            label.text = @"国币";
            label.textColor = [UIColor redColor];
            break;
        case 24:
            button.selected = !button.selected;
            //            if (button.selected) {
            //                button.backgroundColor = [UIColor redColor];
            //            }else{
            //                button.backgroundColor = [UIColor orangeColor];
            //            }
            btn1.selected = NO;
            //            btn1.backgroundColor = [UIColor orangeColor];
            _is_exchange = @0;
            label.text = @"金币";
            label.textColor = [UIColor redColor];
            break;
        case 25:
        {
            ClassifyViewController * cvc = [[ClassifyViewController alloc]init];
            [self.navigationController pushViewController:cvc animated:YES];
            [downView removeFromSuperview];
            is_down = NO;
        }
            break;
        case 26:
            self.tabBarController.selectedIndex = 0;
            [downView removeFromSuperview];
            is_down = NO;
            break;
            
        default:
            break;
    }
}

-(void)clickHeaderButton:(UIButton *)button{
    
    if (button.tag == 101) {
        bsFolded = !bsFolded;
        button.selected = bsFolded;
        if (!bsFolded) {
            //折叠
            //            [button setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
            NSInteger temp = _brandArray.count;
            for (int i =4; i<temp; i++) {
                [_brandArray removeObjectAtIndex:4];
            }
        }else{
            //展开
            //            [button setImage:[UIImage imageNamed:@"he"] forState:UIControlStateNormal];
            _brandArray = [NSMutableArray arrayWithArray:brandArr1];
        }
        [_menuView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        //        NSLog(@"折叠1");
    }else if (button.tag == 100){
        clFolded = !clFolded;
        button.selected = clFolded;
        
        if (!clFolded) {
            //折叠
            //            [button setImage:[UIImage imageNamed:@"xiala"] forState:UIControlStateNormal];
            NSInteger temp = _classArray.count;
            for (int i =4; i<temp; i++) {
                [_classArray removeObjectAtIndex:4];
            }
        }else{
            //展开
            //            [button setImage:[UIImage imageNamed:@"he"] forState:UIControlStateNormal];
            _classArray = [NSMutableArray arrayWithArray:classArr1];
        }
        [_menuView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        
        //        NSLog(@"折叠2");
    }
    
}

//选择分类
-(void)classButton:(UIButton *)button{
    button.userInteractionEnabled = NO;
    UILabel * label = [_menuView viewWithTag:110];
    label.font = [UIFont systemFontOfSize:12];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    for (int i = 300; i < _classArray.count+300; i++) {
        if (button.tag == i ) {
            CategoryModel * model = classArr1[i-300];
            label.text = model.cat_name;
            _classTitle = model.cat_name;
            label.textColor = [UIColor redColor];
            _cat_id = [model cat_id];
            for (CategoryModel * model in classArr1) {
                model.selected = @0;
            }
            model.selected = @1;
            //更新品牌
            [self brandData];
            //            button.backgroundColor = [UIColor redColor];
        }else{
            UIButton * btn = [_menuView viewWithTag:i];
            btn.selected = NO;
            //            btn.backgroundColor = [UIColor orangeColor];
        }
    }
}

//选择品牌
-(void)brandButton:(UIButton *)button{
    
    UILabel * label = [_menuView viewWithTag:111];
    label.font = [UIFont systemFontOfSize:12];
    label.layer.borderWidth = 1;
    label.layer.borderColor = [UIColor redColor].CGColor;
    label.layer.cornerRadius = 5;
    label.layer.masksToBounds = YES;
    label.textAlignment = NSTextAlignmentCenter;
    for (int i = 200; i < _brandArray.count+200; i++) {
        if (button.tag == i ) {
            BrandModel * model = brandArr1[i-200];
            label.text = model.brand_name;
            brandTitle = model.brand_name;
            label.textColor = [UIColor redColor];
            _brand = (NSMutableString*)model.brand_id;
            for (BrandModel * model in brandArr1) {
                model.selected = @0;
            }
            model.selected = @1;
            //            button.backgroundColor = [UIColor redColor];
        }else{
            UIButton * btn = [_menuView viewWithTag:i];
            btn.selected = NO;
            //            btn.backgroundColor = [UIColor orangeColor];
        }
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
}
#pragma mark -上拉加载 下拉刷新
- (void)refreshView
{
    // 下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [self downloadData];
    }];
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据的接口
        [self downloadData];
    }];
    
    // 上拉加载
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [self uploadData];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 请求加载接口
        [self uploadData];
    }];
    
    
}

// 上拉加载
- (void)uploadData
{
    self.page++;
    [self allDataInit];
}

// 下拉刷新
- (void)downloadData
{
    // 加载第一页数据
    self.page = 1;
    [self allDataInit];
}

-(void)toHome:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toMenu{
    is_down = !is_down;
    if (is_down) {
        [self createDownView];
    }else{
        [downView removeFromSuperview];
    }
}

-(void)createDownView{
    downView = [[UIView alloc]initWithFrame:CGRectMake(Width-70, 0, 70, 70)];
    downView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:downView];
    
    UIButton * classButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classButton.frame = CGRectMake(0, 0, downView.bounds.size.width, 34);
    classButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:57/255.0 blue:51/255.0 alpha:1];
    [classButton setTitle:@"分类" forState:UIControlStateNormal];
    classButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [classButton setImage:[UIImage imageNamed:@"fenlei"] forState:UIControlStateNormal];
    [classButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    classButton.tag = 25;
    [classButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:classButton];
    
    UIButton * homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    homeButton.frame = CGRectMake(0, 35, downView.bounds.size.width, 35);
    homeButton.backgroundColor = [UIColor colorWithRed:75/255.0 green:57/255.0 blue:51/255.0 alpha:1];
    [homeButton setTitle:@"主页" forState:UIControlStateNormal];
    homeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [homeButton setImage:[UIImage imageNamed:@"shouye1"] forState:UIControlStateNormal];
    [homeButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
    [homeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 0, 0)];
    homeButton.tag = 26;
    [homeButton addTarget:self action:@selector(dmButton:) forControlEvents:UIControlEventTouchUpInside];
    [downView addSubview:homeButton];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (is_down) {
        [downView removeFromSuperview];
        is_down = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
