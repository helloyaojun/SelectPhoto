//
//  PhotoCollectionViewCell.h
//  MultiPhotosPicker
//
//  Created by yaojun on 15-7-10.
//  Copyright (c) 2015年 yaojun. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WIDTH_SCREEN        [[UIScreen mainScreen] bounds].size.width
#define HEIGHT_SCREEN       [[UIScreen mainScreen] bounds].size.height

#define CELL_MARGIN         6

@interface PhotoCollectionViewCell : UICollectionViewCell {

    UIImageView *selectedImageView;
}

@property (nonatomic,strong)UIImageView *photoImageView;
@property (nonatomic,assign)BOOL stateSelected;

@end
