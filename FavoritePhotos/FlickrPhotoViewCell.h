//
//  FlickrPhotoViewCell.h
//  FavoritePhotos
//
//  Created by Dan Szeezil on 3/31/14.
//  Copyright (c) 2014 Dan Szeezil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrPhotoViewCell : UICollectionViewCell

@property (strong, nonatomic) UICollectionViewCell *photo;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

//  this is needed to stored data instead of URL and be able to access pictures off-line
@property NSData *imageData;


@end
