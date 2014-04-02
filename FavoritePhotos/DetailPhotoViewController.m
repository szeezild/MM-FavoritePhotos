//
//  DetailPhotoViewController.m
//  FavoritePhotos
//
//  Created by Dan Szeezil on 4/1/14.
//  Copyright (c) 2014 Dan Szeezil. All rights reserved.
//

#import "DetailPhotoViewController.h"

@interface DetailPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *detailImageView;



@end

@implementation DetailPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailImageView.image = [UIImage imageWithData:self.imageData];
    // Do any additional setup after loading the view.
}


@end
