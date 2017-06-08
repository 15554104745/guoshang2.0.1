//
//  SearchResoultViewController.m
//  guoshang
//
//  Created by JinLian on 16/9/29.
//  Copyright © 2016年 hi. All rights reserved.
//

#import "SearchResoultViewController.h"
#import "SearchTitleView.h"
#import "GSSearchTableViewCell.h"
#import "SearchResultModel.h"

@interface SearchResoultViewController ()<UITableViewDelegate,UITableViewDataSource> {
    BOOL is_showTtileView;
    CGFloat tableViewContentOfSet_Y;
    NSInteger page;
    NSDictionary *paramsDic;
}

@property (nonatomic, strong)SearchTitleView *searchTitleView;
@property (nonatomic, strong)UITableView *searchTableView;
@property (nonatomic, strong)UIView *titleBackView;
@property (nonatomic, strong)NSString *sort;
@property (nonatomic, strong)NSString *order;
@property (nonatomic, strong)NSArray *goodsDataArr;
@end

@implementation SearchResoultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    is_showTtileView = YES;
    page = 0;
    
    [self loadData];
    self.navigationController.navigationBarHidden = YES;
    
    [self registerTableViewCell];
    
}

- (void)loadData {
    page ++;
    NSDictionary *params = @{
                            @"order":paramsDic[@"order"] ? paramsDic[@"order"]: @"",
                            @"sort":paramsDic[@"sort"] ? paramsDic[@"sort"] : @"",
                            @"page":[NSString stringWithFormat:@"%ld",(long)page],
                            @"keywords":self.keyWords
                                };
    __weak typeof(self) weakSelf = self;
    [HttpTool POST:URLDependByBaseURL(@"?m=Api&c=Category&a=category") parameters:params success:^(id responseObject) {
//        if ([[responseObject objectForKey:@"status"] integerValue] == 3) {
        
            _goodsDataArr = responseObject[@"result"][@"goods"];
        [weakSelf.searchTableView.mj_footer endRefreshing];
//        }
        [weakSelf.searchTableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.searchTableView.mj_footer endRefreshing];

    }];
    
}


- (void)registerTableViewCell {
    [self.searchTableView registerNib:[UINib nibWithNibName:@"GSSearchTableViewCell" bundle:nil] forCellReuseIdentifier:@"searchTableViewCell"];
}

#pragma mark - UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _goodsDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GSSearchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchTableViewCell"];
    SearchResultModel *model = [SearchResultModel mj_objectWithKeyValues:_goodsDataArr[indexPath.row]];
    cell.model = model;
    return cell;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.bounds.size.height) {
        return;
    }
    
    if (scrollView.contentOffset.y>0 && scrollView.contentOffset.y > tableViewContentOfSet_Y  && is_showTtileView ) {
        [self titleViewHiden];
        
    }
    if (scrollView.contentOffset.y>0 && scrollView.contentOffset.y < tableViewContentOfSet_Y && !is_showTtileView) {
        [self titleViewShow];
    }
    tableViewContentOfSet_Y = scrollView.contentOffset.y;
}

- (void)titleViewHiden {
    is_showTtileView = NO;
    [UIView animateWithDuration:0.25 animations:^{
        CGAffineTransform transform = self.searchTitleView.transform;
        self.searchTitleView.transform = CGAffineTransformTranslate(transform, 0, -81);
        CGAffineTransform transform2 = self.searchTableView.transform;
        self.searchTableView.transform = CGAffineTransformTranslate(transform2, 0, -81);
    } completion:^(BOOL finished) {
        [self.view addSubview:self.titleBackView];
    }];
}
- (void)titleViewShow {
    is_showTtileView = YES;
    [self.titleBackView removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        self.searchTableView.transform = CGAffineTransformIdentity;
        self.searchTitleView.transform = CGAffineTransformIdentity;
    }];
}

- (UITableView *)searchTableView {
    if (!_searchTableView) {
        
        _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchTitleView.frame.origin.y+145, Width, Height-64) style:UITableViewStylePlain];
        [self.view addSubview:_searchTableView];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.rowHeight = 116;
        __weak typeof(self) weakSelf = self;
        _searchTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
    }
    return _searchTableView;
}

- (SearchTitleView *)searchTitleView {
    if (!_searchTitleView) {
        _searchTitleView = [[SearchTitleView alloc]initWithFrame:CGRectMake(0, 0, Width, 145)];
        [self.view addSubview:_searchTitleView];
        __weak typeof(self) weakSelf = self;
        _searchTitleView.block = ^(NSDictionary *params){
            paramsDic = [NSDictionary dictionaryWithDictionary:params];
            page = 0;
            [weakSelf loadData];
        };
    }
    return _searchTitleView;
}

- (UIView *)titleBackView {
    if (!_titleBackView) {
        _titleBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Width, 25)];
        _titleBackView.backgroundColor = MyColor;
    }
    return _titleBackView;
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
