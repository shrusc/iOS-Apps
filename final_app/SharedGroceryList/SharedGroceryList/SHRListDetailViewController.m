//
//  SHRListDetailViewController.m
//  SharedGroceryList
//
//  Created by Shruti Chandrakantha on 11/26/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRListDetailViewController.h"
#import <Parse/Parse.h>
#import "SHRAddItemViewController.h"
#import "SHRShareListViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SHRListDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* listDetails;
@property NSString* groupName;
@end

@implementation SHRListDetailViewController

BOOL exists = NO;

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
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationController.toolbarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self showListDetails];
    self.title=self.listName;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showListDetails
{
    PFQuery *query = [PFQuery queryWithClassName:@"singleList"];
    [query whereKey:@"listName" equalTo:self.listName];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        self.listDetails = (NSMutableArray*)results;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"listDetailCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    PFObject *object = [self.listDetails objectAtIndex:indexPath.row];
    [cell.textLabel setText: [object objectForKey:@"itemName"]];
    [cell.detailTextLabel setText: [object objectForKey:@"quantity"]];
    cell.imageView.image = [UIImage imageNamed:@"list item"];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self.listDetails objectAtIndex:indexPath.row];
    PFQuery *query = [PFQuery queryWithClassName:@"singleList"];
    [query whereKey:@"itemName" equalTo:[object objectForKey:@"itemName"]];
    [query whereKey:@"listName" equalTo:[object objectForKey:@"listName"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Delete the found objects
            for (PFObject *object in objects) {
                [object deleteInBackground];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    [self.listDetails removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];

}

- (IBAction)shareListPressed {
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter Group Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [dialog show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        self.groupName = [[alertView textFieldAtIndex:0]text];
        /*if ([self groupNameExists])
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Group already exists" message:@"Type in another name for the group." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
        }
        else*/
            [self performSegueWithIdentifier:@"gotoAddMembers" sender:self];
    }
}

/*- (BOOL)groupNameExists
{
    PFQuery *query = [PFQuery queryWithClassName:@"sharedList"];
    [query whereKey:@"groupName" equalTo:self.groupName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                return NO;
            });
        }
        else
        {
            // The find succeeded.
            dispatch_async(dispatch_get_main_queue(), ^{
                return YES;
            });
        }
        
    }];
    return exists;

}*/

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"gotoAddItem"])
    {
        SHRAddItemViewController *destViewController = segue.destinationViewController;
        destViewController.listName = self.listName;
        destViewController.listShared = NO;
                
    }
    if ([segue.identifier isEqualToString:@"gotoAddMembers"])
    {
        SHRShareListViewController *destViewController = segue.destinationViewController;
        destViewController.groupName = self.groupName;
        destViewController.listName = self.listName;
        
    }
}


@end
