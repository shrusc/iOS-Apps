//
//  SHRRootViewController.m
//  Assignment 5
//
//  Created by Shruti Chandrakantha on 11/4/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRRootViewController.h"
#import "SHRDetailViewController.h"

@interface SHRRootViewController ()
@property  NSMutableArray *allLecturerData;

@end

@implementation SHRRootViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewWillAppear:(BOOL)animated
{
    self.allLecturerData  = [[NSMutableArray alloc] init];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self getLecturerInfo];
}

- (void)getLecturerInfo
{
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://bismarck.sdsu.edu/rateme/list"] completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
        if (error == nil)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200)
            {
                NSMutableArray* allData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (!allData)
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
                    for(NSDictionary *item in allData)
                        [self.allLecturerData addObject:item];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.allLecturerData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"LecturerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    NSDictionary* lecturer = [self.allLecturerData objectAtIndex:indexPath.row];
    NSString* firstName = [lecturer valueForKey:@"firstName"];
    NSString* lastName = [lecturer valueForKey:@"lastName"];
    cell.textLabel.text = [[firstName stringByAppendingString:@" "]stringByAppendingString:lastName];
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showLecturerDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SHRDetailViewController *destViewController = segue.destinationViewController;
        destViewController.lecturerId = [[self.allLecturerData objectAtIndex:indexPath.row] valueForKey:@"id"];

    }
}


@end
