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
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}


- (void)viewWillAppear:(BOOL)animated {
    self.allLecturerData  = [[NSMutableArray alloc] init];
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://bismarck.sdsu.edu/rateme/list"] completionHandler:^(NSData *data,NSURLResponse *response,NSError *error){
        
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
                        [self.allLecturerData addObject:item];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
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
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    NSDictionary* lecturer = [self.allLecturerData objectAtIndex:indexPath.row];
    NSString* firstName = [lecturer valueForKey:@"firstName"];
    NSString* lastName = [lecturer valueForKey:@"lastName"];
    cell.textLabel.text = [[firstName stringByAppendingString:@" "]stringByAppendingString:lastName];
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
    if ([segue.identifier isEqualToString:@"showLecturerDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        SHRDetailViewController *destViewController = segue.destinationViewController;
        destViewController.lecturerId = [[self.allLecturerData objectAtIndex:indexPath.row] valueForKey:@"id"];

    }
}


@end
