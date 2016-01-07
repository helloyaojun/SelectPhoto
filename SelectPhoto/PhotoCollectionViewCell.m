//
//  PhotoCollectionViewCell.m
//  MultiPhotosPicker
//
//  Created by yaojun on 15-7-10.
//  Copyright (c) 2015年 yaojun. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    if (self) {
        
        float cell_width = (WIDTH_SCREEN-CELL_MARGIN*4-20)/3;
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell_width, cell_width)];
        _photoImageView.layer.cornerRadius = 3.f;
        _photoImageView.clipsToBounds = YES;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_photoImageView];
        
        selectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, cell_width, cell_width)];
        [selectedImageView  clipsToBounds];
        selectedImageView.contentMode = UIViewContentModeScaleAspectFill;
        selectedImageView.image = [UIImage imageNamed:@"overlay"];
        selectedImageView.alpha = 0.6f;
        selectedImageView.hidden = YES;
        [self.contentView addSubview:selectedImageView];
    }
    return self;
}

- (void)setStateSelected:(BOOL)stateSelected {

    selectedImageView.hidden = !stateSelected;
}

- (BOOL)stateSelected {

    return !selectedImageView.hidden;
}

@end
