//
//  SelectPhotoViewController.h
//  VSProject
//
//  Created by 姚君 on 15/11/3.
//  Copyright © 2015年 user. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>
#import "PhotoCollectionViewCell.h"

typedef void(^CompletedSelection)(UIImage *image);

@interface SelectPhotoViewController : UIViewController

@property(nonatomic,strong)CompletedSelection getPhotosBlock;

@end
