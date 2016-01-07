//
//  SelectPhotoViewController.m
//  VSProject
//
//  Created by 姚君 on 15/11/3.
//  Copyright © 2015年 user. All rights reserved.
//

#import "SelectPhotoViewController.h"
#import "VPImageCropperViewController.h"

@interface SelectPhotoViewController () {

    ALAssetsLibrary *assetsLibrary;
    NSMutableArray *photoArray;
    UICollectionView *photoCollection;
}

@property(nonatomic,strong)ALAssetsGroup *myGroup;

@end

@implementation SelectPhotoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"选择图片";
    [self enumerateGroups];
    
    float cell_width = (WIDTH_SCREEN-CELL_MARGIN*4-20)/3;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.sectionInset = UIEdgeInsetsMake(CELL_MARGIN, CELL_MARGIN, CELL_MARGIN, CELL_MARGIN);
    flowLayout.itemSize = CGSizeMake(cell_width, cell_width);
    flowLayout.minimumInteritemSpacing = 0;
    
    photoCollection = [[UICollectionView alloc]initWithFrame:CGRectMake(10, 7, WIDTH_SCREEN-20, HEIGHT_SCREEN-7) collectionViewLayout:flowLayout];
    photoCollection.backgroundColor = [UIColor whiteColor];
    photoCollection.delegate = (id<UICollectionViewDelegate>)self;
    photoCollection.dataSource = (id<UICollectionViewDataSource>)self;
    [photoCollection registerClass:[PhotoCollectionViewCell class] forCellWithReuseIdentifier:@"photoCell"];
    [self.view addSubview:photoCollection];
    
}

- (void)enumerateGroups {
    
    
    assetsLibrary = [[ALAssetsLibrary alloc]init];
    __weak typeof(self) weakself = self;
    void (^enumerateGroupsBlock)(ALAssetsGroup *group, BOOL *stop) = ^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            _myGroup = group;
            [weakself enumeratePhotoss];
        }
    };
    void (^enumerateFailedBlock)(NSError *error) = ^(NSError *error) {
        NSLog(@"error=%@",error);
    };
//    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream usingBlock:enumerateGroupsBlock failureBlock:enumerateFailedBlock];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:enumerateGroupsBlock failureBlock:enumerateFailedBlock];
//    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupLibrary usingBlock:enumerateGroupsBlock failureBlock:enumerateFailedBlock];
//    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:enumerateGroupsBlock failureBlock:enumerateFailedBlock];
    
}

- (void)enumeratePhotoss {
    
    photoArray = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"usercenter_choosepic"]];
    dispatch_queue_t queue = dispatch_queue_create("SelectPhotosViewController.enumeratePhotoss", DISPATCH_QUEUE_SERIAL);
    
    [_myGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        dispatch_sync(queue, ^{
            if (result) {
                [photoArray addObject:result];
            }
        });
        dispatch_sync(queue, ^{
            [photoCollection reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)actionBack {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)actionPhotos{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.delegate = (id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>)self;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image =[info objectForKey:@"UIImagePickerControllerEditedImage"];
    [picker dismissViewControllerAnimated:YES completion:nil];
    _getPhotosBlock(image);
    [self actionBack];

}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return photoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoCollectionViewCell *cell = (PhotoCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.photoImageView.image = [photoArray objectAtIndex:0];
    }else {
        ALAsset *indexAsset = [photoArray objectAtIndex:indexPath.row];
        UIImage *image = [UIImage imageWithCGImage:[indexAsset aspectRatioThumbnail]];

        cell.photoImageView.image = image;
    }
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        [self actionPhotos];
    }else {
        ALAsset *indexAsset = [photoArray objectAtIndex:indexPath.row];
        ALAssetRepresentation *asp = [indexAsset defaultRepresentation];
        UIImage *image = [UIImage imageWithCGImage:[asp fullScreenImage] scale:[asp scale] orientation:UIImageOrientationUp];
        
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, self.view.frame.size.height/2-self.view.frame.size.width/2, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = (id<VPImageCropperDelegate>)self;
        [self.navigationController pushViewController:imgEditorVC animated:YES];
    }
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    
    _getPhotosBlock(editedImage);
    
    NSArray *vcs = self.navigationController.viewControllers;
    [self.navigationController popToViewController:[vcs objectAtIndex:vcs.count-2] animated:YES];

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
