//
//  ViewController.h
//  SocialSharing
//
//  Created by User on 1/16/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong) NSMutableArray *returnedDict;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

