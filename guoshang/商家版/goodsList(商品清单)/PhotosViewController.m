//
//  PhotosViewController.m
//  PhotoView
//
//  Created by 赵彦飞 on 16/3/8.
//  Copyright © 2016年 WXG. All rights reserved.
//

#import "PhotosViewController.h"
#import <Photos/Photos.h>

@interface PhotosViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    
    UICollectionView *_collectionView;
    
}
@end

static NSString *identifier = @"identifier";
@implementation PhotosViewController

- (id)init {
    
    if (self = [super init]) {
        
        self.view.backgroundColor = [UIColor blackColor];
        
    }
    
    return self;
}

// 右侧item执行的方法
- (void)rightItemAction {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewController:with:)]) {
        
        [self.delegate photoViewController:_selectList with:_indexList];
    }
    // 返回主界面
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加商品    " style:UIBarButtonItemStyleDone target:self action:@selector(rightItemAction)];
    
    [self creatCollectionView];//初始化collectionView
    
    [self loadPhotos];
}

// 保存前一个界面传回的位置属性
- (void)setIndexList:(NSMutableArray *)indexList {
    _indexList = indexList;
}

- (void)loadPhotos {
    
    if (!_photoList) {
        _photoList = [[NSMutableArray alloc] init];
    }
    if (!_indexList) {
        _indexList = [[NSMutableArray alloc] init];
    }
    if (!_selectList) {
        _selectList = [[NSMutableArray alloc] init];
    }
    
    PHFetchResult *result = [PHAsset fetchAssetsWithOptions:nil];
    PHImageManager *manager = [PHImageManager defaultManager];
    
    // 获取媒体图片时传入的参数
    PHImageRequestOptions *op = [[PHImageRequestOptions alloc] init];
    op.synchronous = YES;// 同步加载
    op.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;//加载速度优化
    
    for (int i = 0; i < result.count; i ++) {
        
        PHAsset *asset = result[i];//取出每一个媒体对象
//        NSLog(@"%@",asset.creationDate);
        [manager requestImageForAsset:asset targetSize:PHImageManagerMaximumSize// 显示图片的最大像素
                          contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                              
                              [_photoList addObject:result];
                              [_collectionView reloadData];
                          }];
    }
    
}

- (void)creatCollectionView {
    
    // 1.创建collectionView的布局类
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置item的大小
    flowLayout.itemSize = CGSizeMake((self.view.frame.size.width -30)/4, (self.view.frame.size.width -30)/4);
    
    // 2. 初始化collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [self.view addSubview:_collectionView];
    
    // 3. 注册collectionView的单元格
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _photoList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (![cell.contentView viewWithTag:3001]) {
        
        // 初始化相册图片的显示控件
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.backgroundColor = [UIColor redColor];
        imageView.tag = 3001;
        [cell.contentView addSubview:imageView];
        
        // 初始化选中图片的标记图
        UIImageView *signImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageView.frame.size.width -36, 0, 36, 36)];
        signImageView.image = [UIImage imageNamed:@"checkmark"];
        signImageView.tag = 3002;
        signImageView.hidden = YES;//默认隐藏
        [cell.contentView addSubview:signImageView];
        
    }
    
    // 显示相册图片
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:3001];
    imageView.image = _photoList[indexPath.item];
    
#pragma mark - 注意编辑顺序
    UIImageView *signImageView = (UIImageView *)[cell.contentView viewWithTag:3002];
    // 判断数组中是否已经包含某一个元素
    signImageView.hidden = ![_indexList containsObject:indexPath];
    UIImage *image = _photoList[indexPath.item];
    if ([_indexList containsObject:indexPath]) {
        
        if (![_selectList containsObject:image]) {
            [_selectList addObject:image];
        }
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 获取点击的单元格的位置属性
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIImageView *signImageView = (UIImageView *)[cell.contentView viewWithTag:3002];
    
    if (_selectList.count >= 5 && signImageView.hidden == YES) {// 判断选中图片的个数
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片个数要求小于5张" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    
    // 获取点击的图片
    UIImage *image = _photoList[indexPath.item];
    
    signImageView.hidden = !signImageView.hidden;
    if (signImageView.hidden) {// 取消图片选中
        
        [_selectList removeObject:image];
        [_indexList removeObject:indexPath];
        
        return;
    }
    
    // 保存选中图片的位置属性和图片
    [_indexList addObject:indexPath];
    [_selectList addObject:image];
    
}


@end
