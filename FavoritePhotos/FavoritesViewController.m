//
//  FavoritesViewController.m
//  FavoritePhotos
//
//  Created by Dan Szeezil on 4/1/14.
//  Copyright (c) 2014 Dan Szeezil. All rights reserved.
//

#import "FavoritesViewController.h"
#import "SearchViewController.h"
#import "FlickrPhotoViewCell.h"
#import "DetailPhotoViewController.h"

@interface FavoritesViewController () <UICollectionViewDataSource, UICollectionViewDelegate>


@property (weak, nonatomic) IBOutlet UICollectionView *detailCollectionView;

@property NSMutableArray *favoritePhotos;



@end

@implementation FavoritesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self load];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [self load];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.favoritePhotos.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FlickrPhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"newFavCell" forIndexPath:indexPath];
    
    cell.imageView.image = [UIImage imageWithData:self.favoritePhotos[indexPath.row]];
    
    return cell;
}

-(NSURL *)documentsDirectory{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *directories = [filemanager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return directories.firstObject;
    
}


-(void)load {
    
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    self.favoritePhotos = [NSMutableArray arrayWithContentsOfURL:plist];
    
    
    if (!self.favoritePhotos) {
        self.favoritePhotos = [NSMutableArray new];
    }
    
    [self.detailCollectionView reloadData];
}



@end







