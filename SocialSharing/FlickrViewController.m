//
//  FlickrViewController.m
//  SocialSharing
//
//  Created by User on 1/23/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "FlickrViewController.h"
#import "DetailsViewController.h"

@interface FlickrViewController ()
- (void) fetchPhotos;

@end

@implementation FlickrViewController
@synthesize collection;
NSString *const FlickrAPIKey = @"23c32e3bb021ad4de280fa28baf58ff5";
NSMutableArray *photolinks;
NSMutableArray *photolinkslarge;
- (void)viewDidLoad {
    [super viewDidLoad];
    photolinks = [[NSMutableArray alloc] init];
    photolinkslarge = [[NSMutableArray alloc] init];
    collection.dataSource = self;
    collection.delegate = self;
    [self fetchPhotos];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchPhotos {
    NSString *text = @"sunrise";
    NSString *urlString =
    [NSString stringWithFormat:
     @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&per_page=27&format=json&nojsoncallback=1",
     FlickrAPIKey, text];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
   
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:kNilOptions
                                                           error:nil];

    NSArray *photos = [[json objectForKey:@"photos"] objectForKey:@"photo"];
    for (NSDictionary *photo in photos)
    {
        NSString *photoURLString =
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_s.jpg",
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"],
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        
        
        [photolinks addObject:photoURLString];
        
         NSString *photoURLStringlarge =
        [NSString stringWithFormat:@"http://farm%@.static.flickr.com/%@/%@_%@_m.jpg",
         [photo objectForKey:@"farm"], [photo objectForKey:@"server"],
         [photo objectForKey:@"id"], [photo objectForKey:@"secret"]];
        [photolinkslarge addObject:photoURLStringlarge];
         }
[collection reloadData];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [photolinks count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell2";
    
   UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSURL *url = [NSURL URLWithString:[photolinks objectAtIndex:indexPath.row]];
    NSData *data = [NSData dataWithContentsOfURL:url];

    UIImage *img = [[UIImage alloc] initWithData:data];
       dispatch_async(dispatch_get_main_queue(), ^{
            UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
            recipeImageView.image = img;
        
    });

    return cell;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"detail" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detail"]) {
        NSArray *indexPaths = [self.collection indexPathsForSelectedItems];
        DetailsViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0];
        NSURL *url = [NSURL URLWithString:[photolinkslarge objectAtIndex:indexPath.row]];
        destViewController.url = url;
        [self.collection deselectItemAtIndexPath:indexPath animated:NO];
    }
}
@end
