//
//  SHRDetailViewController.m
//  Assignment 5
//
//  Created by Shruti Chandrakantha on 11/5/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRDetailViewController.h"
#import "SHRPostDataViewController.h"

#define kInfoSection 0
#define kRatingSection 1
#define kCommentSection  2

@interface SHRDetailViewController ()
@property NSMutableDictionary* lecturerInfo;
@property NSMutableDictionary* allRating;
@property NSArray* infoKeys;
@property NSArray* ratingKeys;
@property NSMutableArray* allComments;
@end

@implementation SHRDetailViewController

BOOL ratingAndInfoLoaded;
BOOL commentsLoaded;

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
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.lecturerInfo = [[NSMutableDictionary alloc] init];
    self.allRating = [[NSMutableDictionary alloc] init];
    self.allComments = [[NSMutableArray alloc] init];
    ratingAndInfoLoaded = NO;
    commentsLoaded = NO;
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bismarck.sdsu.edu/rateme/instructor/%@",self.lecturerId]]completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
        if (error == nil)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200)
            {
                NSDictionary* allInfo = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (!allInfo)
                {
                    NSLog(@"Error parsing JSON:");
                }
                else
                {
                    NSString* firstName = [allInfo valueForKey:@"firstName"];
                    NSString* lastName = [allInfo valueForKey:@"lastName"];
                    NSString* fullName = [[firstName stringByAppendingString:@" "]stringByAppendingString:lastName];
                    [self.lecturerInfo setObject:fullName forKey:@"Name"];
                    
                    //Store all the information
                    for(id key in allInfo)
                    {
                        id value = [allInfo objectForKey:key];
                        if([key isEqualToString:@"lastName"] || [key isEqualToString:@"firstName"])
                            continue;
                        if ([key isEqualToString:@"rating"])
                        {
                            //Store all the rating info
                            NSMutableDictionary* rating = value;
                            for(id key in rating)
                            {
                                id value = [rating objectForKey:key];
                                if([value isKindOfClass:[NSNumber class]])
                                    [self.allRating setObject:[value stringValue] forKey:key];
                            }
                            
                        }
                        //Store the NSNumbers present as Strings
                        if([value isKindOfClass:[NSString class]])
                            [self.lecturerInfo setObject:value forKey:key];
                        if([value isKindOfClass:[NSNumber class]])
                            [self.lecturerInfo setObject:[value stringValue] forKey:key];
                    }
                    
                }
                //Store the keys of the info
                self.infoKeys = [[self.lecturerInfo allKeys] sortedArrayUsingSelector: @selector(compare:)];
                self.ratingKeys = [[self.allRating allKeys] sortedArrayUsingSelector: @selector(compare:)];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    ratingAndInfoLoaded = YES;
                    if(commentsLoaded && ratingAndInfoLoaded)
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                });
                
            }
            else {
                NSLog(@"Bad status code (%ld) for size task at URL: %@", (long)[httpResponse statusCode], [[response URL] absoluteString]);
            }
        }
        else
        {
            NSLog(@"Size task finished with error: %@", error.localizedDescription);
        }
        
    }] resume];
    
    
    [[session dataTaskWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://bismarck.sdsu.edu/rateme/comments/%@",self.lecturerId]]completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        if (error == nil)
        {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if ([httpResponse statusCode] == 200)
            {
                NSMutableArray* array = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                if (!array)
                    NSLog(@"Error parsing JSON:");
                else
                {
                    for(NSDictionary *item in array)
                        [self.allComments addObject:item];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                    commentsLoaded = YES;
                    if(commentsLoaded && ratingAndInfoLoaded)
                        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                });
                
            }
            else
            {
                NSLog(@"Bad status code (%ld) for size task at URL: %@", (long)[httpResponse statusCode], [[response URL] absoluteString]);
            }
        }
        else
        {
            NSLog(@"Size task finished with error: %@", error.localizedDescription);
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
    return 3;

}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    if(section == kInfoSection){
        return @"Info";
    }
    if (section == kRatingSection) {
        return @"Rating";
    } else {
        return @"Comments";
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == kInfoSection)
        return [self.lecturerInfo count];
    if(section == kRatingSection)
        return [self.allRating count];
    else
        return [self.allComments count];
        
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if(indexPath.section == kInfoSection){
        cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell" forIndexPath: indexPath];
        NSString * key = self.infoKeys[indexPath.row];
        NSString * value = self.lecturerInfo[key];
        cell.textLabel.text = key;
        cell.detailTextLabel.text = value;
        
    }
    if(indexPath.section == kRatingSection){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ratingCell" forIndexPath: indexPath];
        NSString * key = self.ratingKeys[indexPath.row];
        NSString * value = self.allRating[key];
        cell.textLabel.text = key;
        cell.detailTextLabel.text = value;
    }
    if(indexPath.section == kCommentSection){
        cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell" forIndexPath: indexPath];
        NSDictionary* comment = [self.allComments objectAtIndex:indexPath.row];
        cell.textLabel.text = [comment valueForKey:@"text"];
        cell.detailTextLabel.text = [comment valueForKey:@"date"];
        
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gotoRatingAndComments"]) {
        SHRPostDataViewController *destViewController = segue.destinationViewController;
        destViewController.lecturerId = self.lecturerId;
        
    }
}


@end
