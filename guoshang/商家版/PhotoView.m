//
//  PhotoView.m
//  PhotoView
//
//  Created by 赵彦飞 on 16/3/8.
//  Copyright © 2016年 WXG. All rights reserved.
//

#import "PhotoView.h"
#import "PhotoItem.h"
#import "ELCImagePicker/ELCImagePickerHeader.h"
#import "STPhotoActionSheet.h"
#import "STDefine.h"

@interface PhotoView ()

@property (nonatomic, strong) NSArray<STSelectPhotoModel *> *lastSelectMoldels;

@end

@implementation PhotoView
{
    
    UIButton *_addButton;//添加按钮
    __block NSMutableArray *mArray;
}

// 刷新视图的位置
- (void)refrashView {
    
    // 刷新item的位置
    [UIView animateWithDuration:.5 animations:^{
        
        NSInteger index = 0;
        for (PhotoItem *item in _itemList) {
            
            item.frame = [self getItemFrameWith:index];
            item.index = index;//刷新item的位置属性
            
            index ++;
        }
        
    }];
    // 1. 动画改变addbutton的位置
    [UIView animateWithDuration:.5 animations:^{
        
        _addButton.frame = [self getItemFrameWith:_photoList.count];
    }];
    
}

- (CGRect)getItemFrameWith:(NSInteger)index {
    
    //    CGFloat x = index *kSpace + (index-1) *kItemW;
    CGFloat x = index * (kSpace + kItemW);
    CGRect rect = CGRectMake(x, 0, kItemW, kItemH);
    
    return rect;
    
}

- (void)creatPhotoItem {
    
    if (_itemList.count > 0) {
        
        for (PhotoItem *item in _itemList) {
            
            [item removeFromSuperview];
        }
        
        [_itemList removeAllObjects];
    }
    
    
    if (!_itemList) {
        _itemList = [[NSMutableArray alloc] init];
    }
    
    NSInteger index = 0;
    for (UIImage *image in _photoList) {
        
        PhotoItem *item = [[PhotoItem alloc] initWithFrame:[self getItemFrameWith:index]];
        item.image = image;
        item.index = index;
        [self addSubview:item];
        
        // 给删除按钮添加方法
        [item.deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [_itemList addObject:item];
        
        index ++;
    }
    
    // 刷新视图的位置
    [self refrashView];
}

- (void)deleteButtonAction:(UIButton *)sender {
    
    // 获取删除按钮所在item的位置属性
    NSInteger index = sender.tag -800;
    // 1. 获取删除按钮所在的item
    PhotoItem *item = _itemList[index];
    // 将item从父视图上移除
    [item removeFromSuperview];
    
    // 2.删除数据
    // 将item从原来的数组中移除  基于item在数组中的位置对item的frame做刷新
    [_itemList removeObjectAtIndex:index];
    [_photoList removeObjectAtIndex:index];
    [_indexList removeObjectAtIndex:index];

    if (mArray) {
        [mArray removeObjectAtIndex:index];
    }else {
        
    }
    [self refrashView];
}


- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {

    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (mArray) {
        
    }else {
        mArray = [NSMutableArray arrayWithCapacity:0];

    }
    [info enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [mArray addObject:obj[@"UIImagePickerControllerOriginalImage"]];
    }];
    _photoList = [[NSMutableArray alloc] initWithArray:mArray];
    _block([[NSArray alloc] initWithArray:mArray]);


    [self creatPhotoItem];
}


- (void)photoViewController:(NSArray *)selectList with:(NSArray *)indexList {
    
    // 保存传入的数据
    _photoList = [[NSMutableArray alloc] initWithArray:selectList];
    _indexList = [[NSMutableArray alloc] initWithArray:indexList];
    
    _block(selectList);
    
    //创建item
    [self creatPhotoItem];
}

- (void)returnValueWithBlock:(passValueBlock)block {
    _block = block;
}

// 点击添加按钮后的任务
- (void)addPhotoAction {
    
    /*
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 5; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    [self.viewController presentViewController:elcPicker animated:YES completion:nil];
    */
    
    STPhotoActionSheet *actionSheet = [[STPhotoActionSheet alloc] init];
    actionSheet.maxSelectCount = 5;
    weakify(self);
    [actionSheet showPhotoLibraryWithSender:self.viewController lastSelectPhotoModels:self.lastSelectMoldels completion:^(NSArray<UIImage *> * _Nonnull selectPhotos, NSArray<STSelectPhotoModel *> * _Nonnull selectPhotoModels) {
        strongify(weakSelf);
        _photoList = [[NSMutableArray alloc] initWithArray:selectPhotos];
        _block([[NSArray alloc] initWithArray:selectPhotos]);
        strongSelf.lastSelectMoldels = selectPhotoModels;
        [weakSelf creatPhotoItem];
//        NSLog(@"%@", selectPhotos);
    }];
    
    
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)creatAddButton {
    
    _addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kItemW, kItemH)];
    
    [_addButton setImage:[UIImage imageNamed:@"btn_add_photo_n"] forState:UIControlStateNormal];
    [_addButton addTarget:self action:@selector(addPhotoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_addButton];
    
}

- (id)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 1. 调整自身的frame
        self.frame = CGRectMake(frame.origin.x, frame.origin.y, kItemW *5 +kSpace *4, kItemH ); //*3 +kSpace *2
        self.clipsToBounds = YES;//超出部分不予显示
        // 2. 初始化添加按钮
        [self creatAddButton];
        
    }
    
    return self;
    
}








@end

@implementation UIView (UIViewController)

- (UIViewController *)viewController {
    
    //通过响应者链，取得此视图所在的视图控制器
    UIResponder *next = self.nextResponder;
    do {
        
        //判断响应者对象是否是视图控制器类型
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = next.nextResponder;
        
    }while(next != nil);
    
    return nil;
}

@end
