//
//  STPhotoBrowser.m
//  STPhotoBrowserDemo
//
//  Created by 孙涛 on 16/10/4.
//  Copyright © 2016年 suntao. All rights reserved.
//

#import "STPhotoBrowser.h"
#import "STPhotoTool.h"
#import "STDefine.h"
#import "STPhotoBrowserCell.h"
#import "STThumbnailViewController.h"

@interface STPhotoBrowser () {

    NSMutableArray<STPhotoAblumList *> *_arrayDataSources;
}
@end

@implementation STPhotoBrowser

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeTop;
    
    self.title = @"照片";
    
    _arrayDataSources = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self initNavBtn];
    [self loadAblums];
    [self pushAllPhotoSoon];
}

- (void)initNavBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 40, 44);
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(navRightBtn_Click) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.hidesBackButton = YES;
}

- (void)loadAblums
{
    [_arrayDataSources addObjectsFromArray:[[STPhotoTool sharePhotoTool] getPhotoAblumList]];
}

#pragma mark - 直接push到所有照片界面
- (void)pushAllPhotoSoon
{
    NSInteger i = 0;
    for (STPhotoAblumList *ablum in _arrayDataSources) {
        if (ablum.assetCollection.assetCollectionSubtype == 209 || [ablum.title isEqualToString:@"所有照片"]) {
            i = [_arrayDataSources indexOfObject:ablum];
            break;
        }
    }
    [self pushThumbnailVCWithIndex:i animated:NO];
}

- (void)navRightBtn_Click
{
    if (self.CancelBlock) {
        self.CancelBlock();
    }
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrayDataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    STPhotoBrowserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"STPhotoBrowserCell"];
    
    if (!cell) {
        cell = [[kSTPhotoBrowserBundle loadNibNamed:@"STPhotoBrowserCell" owner:self options:nil] lastObject];
    }
    
    STPhotoAblumList *ablumList= _arrayDataSources[indexPath.row];
    
    [[STPhotoTool sharePhotoTool] requestImageForAsset:ablumList.headImageAsset size:CGSizeMake(65*3, 65*3) resizeMode:PHImageRequestOptionsResizeModeFast completion:^(UIImage *image, NSDictionary *info) {
        cell.headImageView.image = image;
    }];
    cell.labTitle.text = ablumList.title;
    cell.labCount.text = [NSString stringWithFormat:@"(%ld)", ablumList.count];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self pushThumbnailVCWithIndex:indexPath.row animated:YES];
}

- (void)pushThumbnailVCWithIndex:(NSInteger)index animated:(BOOL)animated
{
    if (_arrayDataSources.count > 0) {
        STPhotoAblumList *ablum = _arrayDataSources[index];
        
        STThumbnailViewController *tvc = [[STThumbnailViewController alloc] initWithNibName:@"STThumbnailViewController" bundle:kSTPhotoBrowserBundle];
        tvc.title = ablum.title;
        tvc.maxSelectCount = self.maxSelectCount;
        tvc.isSelectOriginalPhoto = self.isSelectOriginalPhoto;
        tvc.assetCollection = ablum.assetCollection;
        tvc.arraySelectPhotos = self.arraySelectPhotos.mutableCopy;
        tvc.sender = self;
        tvc.DoneBlock = self.DoneBlock;
        tvc.CancelBlock = self.CancelBlock;
        [self.navigationController pushViewController:tvc animated:animated];
        
    }
}

@end
