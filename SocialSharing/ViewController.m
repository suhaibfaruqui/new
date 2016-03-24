//
//  ViewController.m
//  SocialSharing
//
//  Created by User on 1/16/16.
//  Copyright © 2016 Appcoda. All rights reserved.
//

#import "ViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "TableViewCell.h"


@interface ViewController ()

- (void) fetchTweets;

@end

@implementation ViewController
@synthesize returnedDict;
@synthesize table;
CGFloat height=0;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fetchTweets];
    table.delegate = self;
    table.dataSource = self;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) fetchTweets {
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                  ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType options:nil
                                  completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 
                 NSURL *requestURL = [NSURL
                                      URLWithString:@"https://api.twitter.com/1.1/search/tweets.json?q=%40google&count=25"];
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:nil];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest
                  performRequestWithHandler:^(NSData *responseData,
                                              NSHTTPURLResponse *urlResponse, NSError *error)
                  
                  {
                      NSMutableDictionary *returnedDict1 = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
                      returnedDict = returnedDict1[@"statuses"];
                      dispatch_async(dispatch_get_main_queue(), ^{
                          [table reloadData];
                      });

                      
                  }];
             }
         }
     }];
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat test = height + 47;
    if (test>105)
        return test;
    else
        return 105;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [cell setBackgroundColor:[UIColor colorWithRed:.7 green:.84 blue:92 alpha:1]];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *simpleTableIdentifier = @"cell1";
    
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    
    cell.textView.text = [[returnedDict objectAtIndex:indexPath.row] objectForKey:@"text"];
    CGRect frame = cell.textView.frame;
    CGSize textViewSize = [cell.textView sizeThatFits:CGSizeMake(cell.textView.frame.size.width, FLT_MAX)];
    frame.size.height = textViewSize.height;
    height = frame.size.height;
    cell.textView.frame = frame;
    cell.username.text = [[[returnedDict objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"screen_name"];
    cell.username.textColor = [UIColor orangeColor];
    NSString *path = [[[returnedDict objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"profile_image_url"];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    cell.cellImage.image = img;
    cell.textView.editable = NO;
    cell.textView.dataDetectorTypes = UIDataDetectorTypeAll;
    cell.textView.textColor = [UIColor purpleColor];
    cell.textView.backgroundColor = [UIColor colorWithRed:.7 green:.84 blue:92 alpha:1];
    cell.textView.scrollEnabled = NO;
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%lu", (unsigned long)[returnedDict count]);
   return [returnedDict count];
}


@end
