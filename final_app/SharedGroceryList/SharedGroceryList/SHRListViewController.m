//
//  SHRListViewController.m
//  SharedGroceryList
//
//  Created by Shruti Chandrakantha on 11/26/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRListViewController.h"
#import <Parse/Parse.h>
#import "SHRListDetailViewController.h"
#import "SHRAddItemViewController.h"
#import "SHRSharedListDetailViewController.h"

#define kMyListsSegment 0
#define kSharedListsSegment 1

@interface SHRListViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *listTypeSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* lists;
@property NSString* selectedListName;
@property NSMutableArray* sharedLists;
@property NSString* selectedSharedListName;
@property NSString* listName;
@end

@implementation SHRListViewController

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
    self.navigationItem.hidesBackButton = YES;
    self.listTypeSegmentedControl.selectedSegmentIndex = 0;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationController.toolbarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    [self showUserLists];
    [self showUserSharedLists];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showUserLists
{
    self.lists = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"singleList"];
    [query whereKey:@"user" equalTo:[PFUser currentUser].username];
    [query findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        if (!error)
        {
            BOOL copy;
            for (id item in results) {
                PFObject *object = item;
                copy = YES;
                if([[object objectForKey:@"shared"] isEqualToString:@"YES"]) continue;
                if([self.lists count] == 0){
                    [self.lists addObject:item];
                    continue;
                }
                for(id listItem in self.lists){
                    PFObject *listObject = listItem;
                    if([[object objectForKey:@"listName"] isEqualToString:[listObject objectForKey:@"listName"]])
                       copy = NO;
                }
                if(copy)
                  [self.lists addObject:item];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }
        else
        {
         //error
        }
        
    }];
}

- (void)showUserSharedLists
{
    self.sharedLists = [[NSMutableArray alloc] init];
    PFQuery *listQuery = [PFQuery queryWithClassName:@"sharedList"];
    [listQuery whereKey:@"memberList" equalTo:[PFUser currentUser].username];
    [listQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.sharedLists = (NSMutableArray*)objects;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    }];
    

}

- (IBAction)addNewList {
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter list Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [dialog show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        self.listName = [[alertView textFieldAtIndex:0]text];
        if([self listExistsInSingleList] || [self listExistsInSharedList])
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"List already exists" message:@"Type in another name for the list." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
             [errorAlertView show];
        }
        else
            [self performSegueWithIdentifier:@"gotoAdd" sender:self];

    }
}

- (BOOL)listExistsInSingleList
{
    for(id object in self.lists)
    {
        if([self.listName isEqualToString:[object objectForKey:@"listName"]])
            return YES;
    }
    return NO;

}

- (BOOL)listExistsInSharedList
{
    for(id object in self.sharedLists)
    {
        if([self.listName isEqualToString:[object objectForKey:@"sharedListName"]])
            return YES;
    }
    return NO;
}


- (IBAction)listTypeChanged:(id)sender {
    switch ([sender selectedSegmentIndex])
    {
        case kMyListsSegment:
            self.listTypeSegmentedControl.selectedSegmentIndex = kMyListsSegment;
            [self showUserLists];
            break;
            
        case kSharedListsSegment:
            self.listTypeSegmentedControl.selectedSegmentIndex = kSharedListsSegment;
            [self showUserSharedLists];
            break;
            
        default:
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(self.listTypeSegmentedControl.selectedSegmentIndex == kMyListsSegment)
        return @"My Lists";
    else
        return @"Shared Lists";
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.listTypeSegmentedControl.selectedSegmentIndex == kMyListsSegment)
        return [self.lists count];
    else
        return [self.sharedLists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"listCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(self.listTypeSegmentedControl.selectedSegmentIndex == kMyListsSegment)
    {
        PFObject *object = [self.lists objectAtIndex:indexPath.row];
        [cell.textLabel setText: [object objectForKey:@"listName"]];
        cell.imageView.image = [UIImage imageNamed:@"list"];
    }
    if(self.listTypeSegmentedControl.selectedSegmentIndex == kSharedListsSegment)
    {
        PFObject *object = [self.sharedLists objectAtIndex:indexPath.row];
        [cell.textLabel setText: [object objectForKey:@"sharedListName"]];
         cell.imageView.image = [UIImage imageNamed:@"list"];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listTypeSegmentedControl.selectedSegmentIndex == kMyListsSegment){
        [self performSegueWithIdentifier:@"gotoListDetail" sender:self];
    }
    if(self.listTypeSegmentedControl.selectedSegmentIndex == kSharedListsSegment){
        PFObject *object = [self.sharedLists objectAtIndex:indexPath.row];
        self.selectedSharedListName = [object objectForKey:@"sharedListName"];
        [self performSegueWithIdentifier:@"gotoSharedListDetails" sender:self];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listTypeSegmentedControl.selectedSegmentIndex == kMyListsSegment){
        PFObject *object = [self.lists objectAtIndex:indexPath.row];
        PFQuery *query = [PFQuery queryWithClassName:@"singleList"];
        [query whereKey:@"user" equalTo:[PFUser currentUser].username];
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
        [self.lists removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
 
    }
    else{
        PFObject *object = [self.sharedLists objectAtIndex:indexPath.row];
        PFQuery *sharedListQuery = [PFQuery queryWithClassName:@"sharedList"];
        [sharedListQuery whereKey:@"memberList" equalTo:[PFUser currentUser].username];
        [sharedListQuery whereKey:@"sharedListName" equalTo:[object objectForKey:@"sharedListName"]];
        [sharedListQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            if (!error) {
                // Delete the found objects
                for (PFObject *object in results) {
                    [object deleteInBackground];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        PFQuery *singleListQuery = [PFQuery queryWithClassName:@"singleList"];
        [singleListQuery whereKey:@"listName" equalTo:[object objectForKey:@"sharedListName"]];
        [singleListQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
            if (!error) {
                // Delete the found objects
                for (PFObject *object in results) {
                    [object deleteInBackground];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];


        [self.sharedLists removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
        
    }
    
}

- (IBAction)logoutPressed:(id)sender {
    [PFUser logOut];
    [[self navigationController] popViewControllerAnimated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gotoListDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PFObject *object = [self.lists objectAtIndex:indexPath.row];
        self.selectedListName = [object objectForKey:@"listName"];
        SHRListDetailViewController *destViewController = segue.destinationViewController;
        destViewController.listName = self.selectedListName;
        
    }
    if ([segue.identifier isEqualToString:@"gotoSharedListDetails"])
    {
        SHRSharedListDetailViewController *destViewController = segue.destinationViewController;
        destViewController.sharedListName = self.selectedSharedListName;
        
    }
    
    if ([segue.identifier isEqualToString:@"gotoAdd"])
    {
        SHRAddItemViewController *destViewController = segue.destinationViewController;
        destViewController.listName = self.listName;
        destViewController.listShared = NO;
        
    }
}


@end
