//
//  FlickrViewController.h
//  SocialSharing
//
//  Created by User on 1/23/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlickrViewController : UIViewController <NSURLConnectionDelegate,UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end
