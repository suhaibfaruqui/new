//
//  DetailsViewController.h
//  SocialSharing
//
//  Created by User on 1/24/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSURL *url;
- (IBAction)save:(id)sender;
@end
