//
//  SHRListsViewController.m
//  SharedList
//
//  Created by Shruti Chandrakantha on 11/24/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRListsViewController.h"
#import "SHRTypeSelectionViewController.h"
#import "SHRListDetailViewController.h"
#import <Parse/Parse.h>

@interface SHRListsViewController ()
@property NSArray* lists;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString* selectedListName;
@end

@implementation SHRListsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.navigationItem.hidesBackButton = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    PFQuery *query = [PFQuery queryWithClassName:@"singleList"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        // results contains all the places liked by Bob.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lists = results;
            [self.tableView reloadData];
            
        });
    }];

    
}

- (void)viewWillAppear
{
    PFQuery *query = [PFQuery queryWithClassName:@"singleList"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        // results contains all the places liked by Bob.
        dispatch_async(dispatch_get_main_queue(), ^{
            self.lists = results;
            NSLog(@"%@",results);// Store results
            //[self.tableView reloadData];

        });
    }];
}
- (IBAction)addNewList {
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [dialog show];
    //[dialog release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
       // NSLog(@"%@",[[alertView textFieldAtIndex:0]text]);
        self.listName = [[alertView textFieldAtIndex:0]text];
        [self performSegueWithIdentifier:@"gotoListTypeSelection" sender:self];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"listData";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    PFObject *post = [self.lists objectAtIndex:indexPath.row];
    [cell.textLabel setText: [post objectForKey:@"listName"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"gotoListDetail" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gotoListTypeSelection"])
    {
        SHRTypeSelectionViewController *destViewController = segue.destinationViewController;
        destViewController.listName = self.listName;
        
    }
    
    if ([segue.identifier isEqualToString:@"gotoListDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *post = [self.lists objectAtIndex:indexPath.row];
        SHRListDetailViewController *destViewController = segue.destinationViewController;
        destViewController.listName = [post objectForKey:@"listName"];
        
    }

}


@end
