//
//  DSViewController.m
//  FavoritePhotos
//
//  Created by Dan Szeezil on 3/31/14.
//  Copyright (c) 2014 Dan Szeezil. All rights reserved.
//

#import "SearchViewController.h"
#import "FlickrPhotoViewCell.h"
#import "DetailPhotoViewController.h"
#import "FavoritesViewController.h"


@interface SearchViewController () <UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>



@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@property (weak, nonatomic) IBOutlet UICollectionView *searchCollectionView;


@property (strong, nonatomic) NSMutableDictionary *searchResults;
@property (strong, nonatomic) NSMutableArray *searches;
@property (strong, nonatomic) NSString *textSearch;
@property NSMutableArray *favoritePhotos;


@end


@implementation SearchViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.searches = [NSMutableArray new];
    
//    self.searches = [[NSMutableArray alloc]initWithCapacity:10];
//    self.favoritePhotos = [[NSMutableArray alloc]initWithCapacity:10];
    
//    [self load];
    
}



-(void)searchFlickrPhotos:(NSString *)text
{
    NSString *FlickrAPIKey = @"d5b7e67f5abf24695097b62bfb31259e";
    
    // Build the string to call the Flickr API
    NSString *urlString = [NSString stringWithFormat:@"http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&text%@&extras=geo&per_page=10&format=json&nojsoncallback=1", FlickrAPIKey, text, text];
    
    // Create NSURL string from formatted string
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Setup and start async download
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSError *error;
        
        NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        // set meetings array to data
        self.searchResults = jsonData[@"photos"];
        NSArray *gettingPhotos = self.searchResults[@"photo"];
        
//        NSLog(@"%@", self.searches);
        [self.searches removeAllObjects];
        
        
        for (NSDictionary *items in gettingPhotos) {
            
            NSString *photoURL = [NSString stringWithFormat:@"http://farm%@.staticflickr.com/%@/%@_%@.jpg", items[@"farm"], items[@"server"], items[@"id"], items[@"secret"]];
            
//       alt method of pic storage using NSData instead of URLs so pix can be accessed off-line
            NSURL *url = [NSURL URLWithString:photoURL];
            NSData *storedData = [NSData dataWithContentsOfURL:url];
            
            [self.searches addObject:storedData];
            
        }
        
        [self.searchCollectionView reloadData];
        
    }];
    
}


#pragma mark UICollectionView Datasource methods


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.searches.count;
    
}


//-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//    
//}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FlickrPhotoViewCell *cell = [self.searchCollectionView dequeueReusableCellWithReuseIdentifier:@"newCellID" forIndexPath:indexPath];

    cell.imageData = self.searches[indexPath.row];
    
    cell.imageView.image = [UIImage imageWithData:self.searches[indexPath.row]];
    
    return cell;
    
    
}


//- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
//{
//    if (viewController.tabBarItem.tag == 1) {
//        [self searchFlickrPhotos:@"shark"];
//        
//    } else if (viewController.tabBarItem.tag == 2) {
//        [self searchFlickrPhotos:@"dolphins"];
//        
//    } else if (viewController.tabBarItem.tag == 3) {
//        [self searchFlickrPhotos:@"whales"];
//        
//    }
//}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {

    NSString *concatText = [self.myTextField.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    [self searchFlickrPhotos:concatText];

    [textField resignFirstResponder];
    return YES;
}



-(IBAction)unwindFromDetailVC:(UIStoryboardSegue *)segue {
    
    DetailPhotoViewController *detailVC = segue.sourceViewController;
    
    [self.favoritePhotos addObject:detailVC.imageData];
    
    [self.searchCollectionView reloadData];
    
    [self save];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(FlickrPhotoViewCell *)sender {
    
    
    DetailPhotoViewController *detailVC = segue.destinationViewController;
    detailVC.imageData = sender.imageData;

}


-(NSURL *)documentsDirectory{
    NSFileManager *filemanager = [NSFileManager defaultManager];
    NSArray *directories = [filemanager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    return directories.firstObject;
    
}

-(void)save {
    
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    [self.favoritePhotos writeToURL:plist atomically:YES];

//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setObject:[NSDate date] forKey:@"last saved"];
//    
//    [userDefaults synchronize];
//    
}

-(void)load {
    
    NSURL *plist = [[self documentsDirectory] URLByAppendingPathComponent:@"favorites.plist"];
    self.favoritePhotos = [NSMutableArray arrayWithContentsOfURL:plist];
    
    
    if (!self.favoritePhotos) {
        self.favoritePhotos = [NSMutableArray new];
    }
    
    [self.searchCollectionView reloadData];
    
}




@end









