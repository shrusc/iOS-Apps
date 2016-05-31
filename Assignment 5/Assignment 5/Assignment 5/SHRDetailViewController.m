//
//  SHRDetailViewController.m
//  Assignment 5
//
//  Created by Shruti Chandrakantha on 11/5/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRDetailViewController.h"
#import "SHRPostDataViewController.h"

#define kDetailsSegment 0
#define kRatingSegment 1
#define kCommentSegment  2

@interface SHRDetailViewController ()
@property NSMutableDictionary* lecturerInfo;
@property NSMutableDictionary* allRating;
@property NSArray* infoKeys;
@property NSArray* ratingKeys;
@property NSMutableArray* allComments;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SHRDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.lecturerInfo = [[NSMutableDictionary alloc] init];
    self.allRating = [[NSMutableDictionary alloc] init];
    self.allComments = [[NSMutableArray alloc] init];
    self.segmentControl.selectedSegmentIndex = 0;
    //call getDetailsandRating now, call getComments when the user has clicked on the comments segment
    [self getDetailsandRating];
}

- (void)getDetailsandRating
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bismarck.sdsu.edu/rateme/instructor/%@",self.lecturerId]]completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
        if (error == nil)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200)
            {
                NSMutableDictionary* allInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (!allInfo)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Error"
                                                                    message:@"Error parsing JSON"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                }
                else
                {
                    //Store all the information
                    for(id key in allInfo)
                    {
                        id value = [allInfo objectForKey:key];
                        if([key isEqualToString:@"firstName"])
                            [self.lecturerInfo setObject:value forKey:@"First Name"];
                        if([key isEqualToString:@"lastName"])
                            [self.lecturerInfo setObject:value forKey:@"Last Name"];
                        if([key isEqualToString:@"office"])
                            [self.lecturerInfo setObject:value forKey:@"Office"];
                        if([key isEqualToString:@"phone"])
                            [self.lecturerInfo setObject:value forKey:@"Phone"];
                        if([key isEqualToString:@"email"])
                            [self.lecturerInfo setObject:value forKey:@"Email"];
                        
                        //Store all the rating info
                        if([key isEqualToString:@"rating"])
                        {
                            NSMutableDictionary* rating = value;
                            for(id key in rating)
                            {
                                id value = [rating objectForKey:key];
                                if([key isEqualToString:@"average"])
                                    [self.allRating setObject:[value stringValue] forKey:@"Avg. Rating"];
                                if([key isEqualToString:@"totalRatings"])
                                    [self.allRating setObject:[value stringValue] forKey:@"Total Ratings"];
                            }
                        }
                    }
                    //Store the keys in the order that should be displayed
                    self.infoKeys = [NSArray arrayWithObjects: @"First Name", @"Last Name", @"Office", @"Phone",
                                     @"Email",nil];
                    self.ratingKeys = [self.allRating allKeys];
                    
                    //show the table in the main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                        [self.tableView reloadData];
                    });
                }
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HTTP Response Error"
                                                                message:[NSString stringWithFormat:@"Bad status code (%ld)at URL: %@",(long)[httpResponse statusCode], [[response URL] absoluteString]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HTTPSession Error"
                                                            message:[NSString stringWithFormat:@"Task finished with error: %@",error.localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }] resume];

}

- (void)getComments
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bismarck.sdsu.edu/rateme/comments/%@",self.lecturerId]]completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        if (error == nil)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200)
            {
                NSMutableArray* comments = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (!comments)
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Data Error"
                                                                    message:@"Error parsing JSON"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
                
                else
                {
                    for(NSDictionary *item in comments)
                        [self.allComments addObject:item];
                }
                //show the table in the main thread
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    [self.tableView reloadData];
                });

                
            }
            else
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HTTP Response Error"
                                                                message:[NSString stringWithFormat:@"Bad status code (%ld)at URL: %@",(long)[httpResponse statusCode], [[response URL] absoluteString]]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HTTPSession Error"
                                                            message:[NSString stringWithFormat:@"Task finished with error: %@",error.localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }] resume];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(self.segmentControl.selectedSegmentIndex == kDetailsSegment)
        return @"Details";
    if (self.segmentControl.selectedSegmentIndex == kRatingSegment)
        return @"Rating";
    else
        return @"Comments";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(self.segmentControl.selectedSegmentIndex == kDetailsSegment)
        return [self.lecturerInfo count];
    if(self.segmentControl.selectedSegmentIndex == kRatingSegment)
        return [self.allRating count];
    else
        return [self.allComments count];
        
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(self.segmentControl.selectedSegmentIndex == kDetailsSegment)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath: indexPath];
        NSString * key = self.infoKeys[indexPath.row];
        NSString * value = self.lecturerInfo[key];
        cell.textLabel.text = key;
        cell.detailTextLabel.text = value;
        
    }
    if(self.segmentControl.selectedSegmentIndex == kRatingSegment)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ratingCell" forIndexPath: indexPath];
        NSString * key = self.ratingKeys[indexPath.row];
        NSString * value = self.allRating[key];
        cell.textLabel.text = key;
        cell.detailTextLabel.text = value;
    }
    if(self.segmentControl.selectedSegmentIndex == kCommentSegment)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath: indexPath];
        NSDictionary* comment = [self.allComments objectAtIndex:indexPath.row];
        cell.textLabel.text = [comment valueForKey:@"text"];
        cell.detailTextLabel.text = [comment valueForKey:@"date"];
        
    }
    return cell;
}


- (IBAction)segmentChanged:(id)sender {
    
    switch ([sender selectedSegmentIndex])
    {
        case kDetailsSegment:
            [self showDetails];
            break;
            
        case kRatingSegment:
            [self showRating];
            break;
            
        case kCommentSegment:
            [self showComments];
            break;
            
        default:
            break;
            
    }

}

- (void) showDetails
{
    self.segmentControl.selectedSegmentIndex = kDetailsSegment;
    [self.tableView reloadData];
}

- (void) showRating
{
    self.segmentControl.selectedSegmentIndex = kRatingSegment;
    [self.tableView reloadData];
}

- (void) showComments
{
    self.segmentControl.selectedSegmentIndex = kCommentSegment;
    //User has clicked comments so call getComments and reload table view in getcomments.
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self getComments];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gotoRatingAndComments"])
    {
        SHRPostDataViewController *destViewController = segue.destinationViewController;
        destViewController.lecturerId = self.lecturerId;
        
    }
}


@end
