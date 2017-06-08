//
//  ChooseLocationView.m
//  ChooseLocation
//
//  Created by suntao on 16/9/13.
//  Copyright © 2016年 Hi. All rights reserved.
//

#import "ChooseLocationView.h"
#import "AddressView.h"
#import "UIView+Frame.h"
#import "AddressTableViewCell.h"
#import "AddressItem.h"
#import "MBProgressHUD.h"
#define HYScreenW [UIScreen mainScreen].bounds.size.width

static  CGFloat  const  kHYTopViewHeight = 40; //顶部视图的高度
static  CGFloat  const  kHYTopTabbarHeight = 30; //地址标签栏的高度

@interface ChooseLocationView ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate> {
    UITableView *addressTableView;
}
@property (nonatomic,weak) AddressView * topTabbar;
@property (nonatomic,weak) UIScrollView * contentView;
@property (nonatomic,weak) UIView * underLine;
@property (nonatomic,strong) NSArray * dataSouce;
@property (nonatomic,strong) NSArray * dataSouce1;
@property (nonatomic,strong) NSArray * dataSouce2;
@property (nonatomic,strong) NSArray * dataSouce3;
@property (nonatomic,strong) NSMutableArray * tableViews;
@property (nonatomic,strong) NSMutableArray * topTabbarItems;
@end

@implementation ChooseLocationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (UserId) {
            [self loadAddress:NO];
        }else {
            [self setUpWithNotShowUserAddress:NO];
        }

    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame notShowUserAddress:(BOOL)notShowUserAddress
{
    self = [super initWithFrame:frame];
    if (self) {
        if (UserId) {
            [self loadAddress:notShowUserAddress];
            
        }else {
            [self setUpWithNotShowUserAddress:notShowUserAddress];
        }
    }
    return self;
}

//添加默认收货地址
- (void)loadAddress:(BOOL)notShowUserAddress {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/myaddress") parameters:@{@"token":[@{@"user_id":UserId} paramsDictionaryAddSaltString]} success:^(id responseObject) {
        
        NSArray *dataList = [responseObject objectForKey:@"result"];
        NSMutableArray *address = [NSMutableArray array];
        for (NSDictionary *dic in dataList) {
            NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
            [mDict setValue:dic[@"address_str"] forKey:dic[@"province_id"]];
            AddressItem * item;
            if ([[dic objectForKey:@"is_default"] integerValue] == 1) {
                item = [AddressItem initWithName:dic[@"address_str"] isSelected:YES];
            }else {
                item = [AddressItem initWithName:dic[@"address_str"] isSelected:NO];
            }
            [mDict setValue:item forKey:@"addressItem"];
            [address addObject:mDict];
            
        }
        
        weakSelf.dataSouce3 = address;
        
        [weakSelf setUpWithNotShowUserAddress:notShowUserAddress];
        
//        [addressTableView reloadData];
        [MBProgressHUD hideHUDForView:self animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
    
}


#pragma mark - setUp UI

- (void)setUpWithNotShowUserAddress:(BOOL)notShowUserAddress {
    
    topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, kHYTopViewHeight)];
    [self addSubview:topView];
    topView.backgroundColor = [UIColor whiteColor];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.frame = CGRectMake((topView.frame.size.width-100)/2, 0, 100, kHYTopViewHeight-1);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"配送至";
    titleLabel.textColor = kUIColorFromRGB(0xE73736);
    titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:titleLabel];

    
    separateLine = [self separateLine];
    [topView addSubview: separateLine];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-40, 0, 39, 39)];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(removeSelfAction) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:cancelButton];
    
    backeView = [[UIView alloc]initWithFrame:CGRectMake(0, kHYTopViewHeight, self.frame.size.width*2, self.frame.size.height-kHYTopViewHeight)];
    backeView.backgroundColor = [UIColor whiteColor];
    [self addSubview:backeView];
    
    if (!notShowUserAddress && UserId && self.dataSouce3.count != 0 ) {
        
        //登录时候展示默认地址
        addressTableView = [[UITableView alloc]init];
        addressTableView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-kHYTopViewHeight-44);
        addressTableView.delegate = self;
        addressTableView.dataSource = self;
        [addressTableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
        [backeView addSubview:addressTableView];
 
        selectAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectAddressBtn.backgroundColor = NewRedColor;
        [selectAddressBtn setTitle:@"选择其他地址" forState:UIControlStateNormal];
        [selectAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        selectAddressBtn.frame = CGRectMake(0, self.frame.size.height-kHYTopViewHeight-44, self.frame.size.width, 44);
        [selectAddressBtn addTarget:self action:@selector(selectAddressButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [backeView addSubview:selectAddressBtn];
        
//        [self loadAddress];
        
    }else {
        [self addAddressUI];
        CGAffineTransform transform = backeView.transform;
        backeView.transform = CGAffineTransformTranslate(transform, -self.frame.size.width, 0);
        [self loadDataWithRegionId:@"1"];
    }
    
}

- (void)removeSelfAction {
    
    if (self.closeSelfBlock) {
        self.closeSelfBlock();
    }
    
    if ([_delegate respondsToSelector:@selector(chooseLocationViewDidClose)]) {
        [_delegate chooseLocationViewDidClose];
    }
}



- (void)addAddressUI {
    
    AddressView * topTabbar = [[AddressView alloc]initWithFrame:CGRectMake(self.frame.size.width, 0, self.frame.size.width, kHYTopViewHeight)];
    [backeView addSubview:topTabbar];
    _topTabbar = topTabbar;
    [self addTopBarItem];
    UIView * separateLine1 = [self separateLine];
    [topTabbar addSubview: separateLine1];
    separateLine1.top = topTabbar.height - separateLine.height;
    [_topTabbar layoutIfNeeded];
    topTabbar.backgroundColor = [UIColor whiteColor];
    
    UIView * underLine = [[UIView alloc] initWithFrame:CGRectZero];
    [topTabbar addSubview:underLine];
    _underLine = underLine;
    underLine.height = 2.0f;
    UIButton * btn = self.topTabbarItems.lastObject;
    [self changeUnderLineFrame:btn];
    underLine.top = separateLine1.top - underLine.height;
    
    _underLine.backgroundColor = [UIColor orangeColor];
    UIScrollView * contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(self.frame.size.width, CGRectGetMaxY(topTabbar.frame), self.frame.size.width, self.height - kHYTopViewHeight - kHYTopTabbarHeight)];
    contentView.contentSize = CGSizeMake(HYScreenW, 0);
    [backeView addSubview:contentView];
    _contentView = contentView;
    _contentView.pagingEnabled = YES;
    [self addTableView];
    _contentView.delegate = self;

}

- (void)selectAddressButtonAction:(UIButton *)sender {
    
    
    [self addAddressUI];
    [self loadDataWithRegionId:@"1"];

    [UIView animateWithDuration:0.35 animations:^{
       
        CGAffineTransform transform = backeView.transform;
        backeView.transform = CGAffineTransformTranslate(transform, -self.frame.size.width, 0);

    }];
}

- (void)addTableView {

    UITableView * tabbleView = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViews.count * HYScreenW, 0, HYScreenW, _contentView.height)];
    [_contentView addSubview:tabbleView];
    [self.tableViews addObject:tabbleView];
    tabbleView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tabbleView.delegate = self;
    tabbleView.dataSource = self;
    tabbleView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    [tabbleView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:@"AddressTableViewCell"];
}

- (void)addTopBarItem{
    
    UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
    [topBarItem setTitle:@"请选择" forState:UIControlStateNormal];
    [topBarItem setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [topBarItem sizeToFit];
    topBarItem.titleLabel.font = [UIFont systemFontOfSize:13];
     topBarItem.centerY = _topTabbar.height * 0.5;
    [self.topTabbarItems addObject:topBarItem];
    [_topTabbar addSubview:topBarItem];
    [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.topTabbarItems.count > 1) {
        for (UIButton *button in self.topTabbarItems) {
            if (button != self.topTabbarItems.lastObject) {
                [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - TableViewDatasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if([self.tableViews indexOfObject:tableView] == 0){
        return self.dataSouce.count;
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        return self.dataSouce1.count;
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        return self.dataSouce2.count;
    }else if (tableView == addressTableView) {
        return self.dataSouce3.count;
    }
    return self.dataSouce.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    AddressTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AddressTableViewCell" forIndexPath:indexPath];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //省级别
    if([self.tableViews indexOfObject:tableView] == 0){
        
        AddressItem * item = self.dataSouce[indexPath.row][@"addressItem"];
        cell.item = item;
        
     //市级别
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        
        if (self.dataSouce1.count == 0) {
            AddressItem * item = self.dataSouce1[indexPath.row];
            cell.item = item;
        
        }else{
            AddressItem * item = self.dataSouce1[indexPath.row][@"addressItem"];
            cell.item = item;
        }
    //区级别
    }else if ([self.tableViews indexOfObject:tableView] == 2){

        AddressItem * item = [self.dataSouce2[indexPath.row] objectForKey:@"addressItem"];
        cell.item = item;
    }
    
    //用户默认收货地址显示
    if (tableView == addressTableView) {
        cell.item = [self.dataSouce3[indexPath.row] objectForKey:@"addressItem"];
        
        if (cell.item.isSelected) {
            
            self.address = cell.item.name;
            
            NSDictionary *dic = self.dataSouce3[indexPath.row];
            for (NSString *str in [dic allKeys]) {
                if (![str isEqualToString:@"addressItem"]) {
                    self.provience_id = str;
                }
            }
            
        }
        
        
    }
    return cell;
}

#pragma mark - TableViewDelegate
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.tableViews indexOfObject:tableView] == 0){
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        NSDictionary *regionDic = [self.dataSouce objectAtIndex:indexPath.row];
        NSArray *arr = [regionDic allKeys];
        NSString *regionStr;
        for (NSString *str in arr) {
            if (![str isEqualToString:@"addressItem"]) {
                regionStr = str;
                self.provience_id = str;
            }
        }
        //第二级数据源
        if (_dataSouce1.count == 0) {
            [self addressDictToDataSouce:regionStr];
        }
//        if (_dataSouce1.count == 1) { //此时为直辖市，第二级的地名都是区级别
//            NSMutableArray * mArray = [NSMutableArray array];
//            for (NSString * name in _dataSouce1) {
//                AddressItem * item = [AddressItem initWithName:name isSelected:NO];
//                [mArray addObject:item];
//            }
//            _dataSouce1 = mArray;
//        }
        //之前有选中省，重新选择省,切换省.
        if (indexPath0) {
            for (int i = 0; i < self.tableViews.count; i++) {
                [self removeLastItem];
            }
            [self addTopBarItem];
            [self addTableView];
            AddressItem * item = self.dataSouce[indexPath.row][@"addressItem"];
            [self scrollToNextItem:item.name ];
            return indexPath;
        }
        //之前未选中省，第一次选择省
        [self addTopBarItem];
        [self addTableView];
        AddressItem * item = self.dataSouce[indexPath.row][@"addressItem"];
        self.provience = item.name;
        [self scrollToNextItem:item.name ];
        
    }else if ([self.tableViews indexOfObject:tableView] == 1){
        
        NSIndexPath * indexPath0 = [tableView indexPathForSelectedRow];
        //重新选择市,切换市.
        if (indexPath0) {
        
            //如果发现省级别字典里sub关联的数组只有一个元素,说明是直辖市,这时2级界面为区级别
            if ([self.dataSouce1[indexPath.row] isKindOfClass:[AddressItem class]]){
                AddressItem * item = self.dataSouce1[indexPath.row];
                [self setUpAddress:item.name];
                return indexPath;
            }
            
            NSMutableArray * mArray = [NSMutableArray array];
            
            NSDictionary *regionDic = [_dataSouce1 objectAtIndex:indexPath.row];
            NSArray *arr = [regionDic allKeys];
            NSString *regionStr;
            for (NSString *str in arr) {
                if (![str isEqualToString:@"addressItem"]) {
                    regionStr = (NSString *)str;
                }
            }
            if (_dataSouce2.count == 0) {
                [self addressDictToDataSouce2:regionStr];
            }
            //            NSArray * tempArray = _dataSouce1[indexPath.row][@"sub"];
            for (NSString * name in _dataSouce2) {
                AddressItem * item = [AddressItem initWithName:name isSelected:NO];
                [mArray addObject:item];
            }
            
            [self removeLastItem];
            [self addTopBarItem];
            [self addTableView];
            AddressItem * item = self.dataSouce1[indexPath.row][@"addressItem"];
            [self scrollToNextItem:item.name];
            
            return indexPath;
        }
        
        
        //之前未选中市,第一次选择
        if ([self.dataSouce1[indexPath.row] isKindOfClass:[AddressItem class]]){//只有两级,此时self.dataSouce1装的是直辖市下面区的数组
            
            AddressItem * item = self.dataSouce1[indexPath.row];
            [self setUpAddress:item.name];
            
        }else{
    
            NSMutableArray * mArray = [NSMutableArray array];
            
            NSDictionary *regionDic = [_dataSouce1 objectAtIndex:indexPath.row];
            NSArray *arr = [regionDic allKeys];
            NSString *regionStr;
            for (NSString *str in arr) {
                if (![str isEqualToString:@"addressItem"]) {
                    regionStr = [NSString stringWithFormat:@"%@",str];
//                    NSLog(@"%@",regionStr);
                    self.city_id = regionStr;
                }
            }
            if (_dataSouce2.count == 0) {
                [self addressDictToDataSouce2:regionStr];
            }

            for (NSString * name in _dataSouce2) {
                AddressItem * item = [AddressItem initWithName:name isSelected:NO];
                [mArray addObject:item];
            }
    
            [self addTopBarItem];
            [self addTableView];
             AddressItem * item = self.dataSouce1[indexPath.row][@"addressItem"];
            self.city = item.name;
            [self scrollToNextItem:item.name];
        }
       
    }else if ([self.tableViews indexOfObject:tableView] == 2){
        
        NSDictionary *regionDic = [self.dataSouce2 objectAtIndex:indexPath.row];
        NSArray *arr = [regionDic allKeys];
        NSString *regionStr;
        for (NSString *str in arr) {
            if (![str isEqualToString:@"addressItem"]) {
                regionStr = [NSString stringWithFormat:@"%@",str];
//                NSLog(@"%@",regionStr);
                self.district_id = regionStr;
            }
        }
        AddressItem * item = [self.dataSouce2[indexPath.row] objectForKey:@"addressItem"];
        self.district = item.name;
        [self setUpAddress:item.name];
    }
    //选择默认配送地址
    if (tableView == addressTableView) {
        AddressItem * item = [self.dataSouce3[indexPath.row] objectForKey:@"addressItem"];
        [self setUpSelectedAddress:item.name];
        
        NSDictionary *regionDic = [self.dataSouce3 objectAtIndex:indexPath.row];
        NSArray *arr = [regionDic allKeys];
        for (NSString *str in arr) {
            if (![str isEqualToString:@"addressItem"]) {
                self.provience_id = str;
            }
        }

    }
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == addressTableView) {
        AddressTableViewCell * cell0 = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        AddressItem * item0 = cell0.item;
        item0.isSelected = NO;
        cell0.item = item0;
    }
    
    AddressTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    AddressItem * item = cell.item;
    item.isSelected = YES;
    cell.item = item;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddressTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    AddressItem * item = cell.item;
    item.isSelected = NO;
    cell.item = item;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == _contentView) {
        NSInteger index = _contentView.contentOffset.x / HYScreenW;
        [UIView animateWithDuration:0.25 animations:^{
            [self changeUnderLineFrame:self.topTabbarItems[index]];
        }];
    }
}

#pragma mark - private 
//点击按钮,滚动到对应位置
- (void)topBarItemClick:(UIButton *)btn{
    
    NSInteger index = [self.topTabbarItems indexOfObject:btn];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.contentOffset = CGPointMake(index * HYScreenW, 0);
        [self changeUnderLineFrame:btn];
    }];
}

//调整指示条位置
- (void)changeUnderLineFrame:(UIButton *)btn{
    
    _underLine.left = btn.left;
    _underLine.width = btn.width;
}

//完成地址选择,执行chooseFinish代码块
- (void)setUpAddress:(NSString *)address{

    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:address forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [self changeUnderLineFrame:btn];
    NSMutableString * addressStr = [[NSMutableString alloc] init];
    for (UIButton * btn  in self.topTabbarItems) {
        
        [addressStr appendString:btn.currentTitle];
        [addressStr appendString:@" "];
    }
    self.address = addressStr;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
        
        if ([_delegate respondsToSelector:@selector(chooseLocationViewDidFinishSelected:)]) {
            
            NSDictionary *addressInfo = @{@"province":self.provience,@"city":self.city,@"district":self.district,@"province_id":self.provience_id,@"district_id":self.district_id,@"city_id":self.city_id};
            [_delegate chooseLocationViewDidFinishSelected:[[NSDictionary alloc] initWithDictionary:addressInfo]];
        }
    });
}

- (void)setUpSelectedAddress:(NSString *)address {

    self.address = address;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.hidden = YES;
        if (self.chooseFinish) {
            self.chooseFinish();
        }
    });
}


//当重新选择省或者市的时候，需要将下级视图移除。
- (void)removeLastItem{

    [self.tableViews.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.tableViews removeLastObject];
    
    [self.topTabbarItems.lastObject performSelector:@selector(removeFromSuperview) withObject:nil withObject:nil];
    [self.topTabbarItems removeLastObject];
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle{
    
    NSInteger index = self.contentView.contentOffset.x / HYScreenW;
    UIButton * btn = self.topTabbarItems[index];
    [btn setTitle:preTitle forState:UIControlStateNormal];
    [btn sizeToFit];
    [_topTabbar layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        CGSize  size = self.contentView.contentSize;
        self.contentView.contentSize = CGSizeMake(size.width + HYScreenW, 0);
        CGPoint offset = self.contentView.contentOffset;
        self.contentView.contentOffset = CGPointMake(offset.x + HYScreenW, offset.y);
        [self changeUnderLineFrame: [self.topTabbar.subviews lastObject]];
    }];
}


#pragma mark - 请求数据接口
//请求数据接口
//regionId 国家id
- (NSArray *)loadDataWithRegionId:(NSString *)regionId {
    __weak typeof(self) weakSelf = self;
    NSMutableArray * mArray = [NSMutableArray array];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/get_next_region") parameters:@{@"region_id":regionId} success:^(id responseObject) {
        
        if([[responseObject objectForKey:@"status"]integerValue] == 1) {
            
            NSArray * arr = [responseObject objectForKey:@"result"];
            for (NSDictionary * dict0 in arr) {
                NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                [mDict setValue:dict0[@"region_name"] forKey:dict0[@"region_id"]];
                AddressItem * item = [AddressItem initWithName:dict0[@"region_name"] isSelected:NO];
                [mDict setValue:item forKey:@"addressItem"];
                [mArray addObject:mDict];
            }
            
            weakSelf.dataSouce = mArray;
            
            UITableView *tableView = [weakSelf.tableViews lastObject];
            [tableView reloadData];
            
        }
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    }];

    return mArray;
}

- (void)addressDictToDataSouce:(NSString *)region {
    __weak typeof(self) weakSelf = self;
    NSMutableArray * mArray = [NSMutableArray array];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/get_next_region") parameters:@{@"region_id":region.description} success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"]integerValue] == 1) {
            
            NSArray * arr = [responseObject objectForKey:@"result"];
            for (NSDictionary * dict0 in arr) {
                NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                [mDict setValue:dict0[@"region_name"] forKey:dict0[@"region_id"]];
                AddressItem * item = [AddressItem initWithName:dict0[@"region_name"] isSelected:NO];
                [mDict setValue:item forKey:@"addressItem"];
                [mArray addObject:mDict];
            }
            _dataSouce1 = mArray;
        }
        UITableView *tableView = [weakSelf.tableViews lastObject];
        [tableView reloadData];

        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    }];
}

- (void)addressDictToDataSouce2:(NSString *)region {
    __weak typeof(self) weakSelf = self;
    NSMutableArray * mArray = [NSMutableArray array];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [HttpTool POST:URLDependByBaseURL(@"/Api/User/get_next_region") parameters:@{@"region_id":region.description} success:^(id responseObject) {
        if([[responseObject objectForKey:@"status"]integerValue] == 1) {
            
            NSArray * arr = [responseObject objectForKey:@"result"];
            for (NSDictionary * dict0 in arr) {
                NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
                [mDict setValue:dict0[@"region_name"] forKey:dict0[@"region_id"]];
                AddressItem * item = [AddressItem initWithName:dict0[@"region_name"] isSelected:NO];
                [mDict setValue:item forKey:@"addressItem"];
                [mArray addObject:mDict];
            }
            _dataSouce2 = mArray;
        }
        UITableView *tableView = [weakSelf.tableViews lastObject];
        [tableView reloadData];
        
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
    }];
}
#pragma mark - getter 方法
//分割线
- (UIView *)separateLine{
    UIView *separate = [[UIView alloc]initWithFrame:CGRectMake(0, kHYTopViewHeight-1, self.frame.size.width, 0.5)];
    separate.backgroundColor = [UIColor lightGrayColor];
    return separate;
}

- (NSMutableArray *)tableViews{
    
    if (_tableViews == nil) {
        _tableViews = [NSMutableArray array];
    }
    return _tableViews;
}

- (NSMutableArray *)topTabbarItems{
    if (_topTabbarItems == nil) {
        _topTabbarItems = [NSMutableArray array];
    }
    return _topTabbarItems;
}
//市级别数据源
- (NSArray *)dataSouce1{
    
    if (_dataSouce1 == nil) {
  
        _dataSouce1 = [NSArray array];
    }
    return _dataSouce1;
}

//区级别数据源
- (NSArray *)dataSouce2{
    
    if (_dataSouce2 == nil) {
     
        _dataSouce2 = [NSArray array];
    }
    return _dataSouce2;
}

@end
