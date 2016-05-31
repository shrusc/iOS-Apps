//
//  SHRSharedListDetailViewController.m
//  SharedGroceryList
//
//  Created by Shruti Chandrakantha on 11/30/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRSharedListDetailViewController.h"
#import <Parse/Parse.h>
#import "SHRAddItemViewController.h"
#import "SHRShareListViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

#define kItemsSegment 0
#define kMembersSegment 1

@interface SHRSharedListDetailViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *listInfoSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray* members;
@property NSMutableArray* listItems;
@end

@implementation SHRSharedListDetailViewController

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
    self.navigationController.toolbarHidden = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    self.listInfoSegmentedControl.selectedSegmentIndex = 0;
    [self showSharedListMembers];
    [self showSharedListItems];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showSharedListItems
{
    UIImage *addButtonImage = [UIImage imageNamed:@"New List"];
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithImage:addButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonPressed:)];
    // the bar button item is actually set on the navigation item, not the navigation bar itself.
    self.navigationItem.rightBarButtonItem = addBarButtonItem;

    PFQuery *listQuery = [PFQuery queryWithClassName:@"singleList"];
    [listQuery whereKey:@"listName" equalTo:self.sharedListName];
    [listQuery findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
        self.listItems= (NSMutableArray*)results;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

- (void)showSharedListMembers
{
    UIImage *addButtonImage = [UIImage imageNamed:@"add member"];
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithImage:addButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(addBarButtonPressed:)];
    // the bar button item is actually set on the navigation item, not the navigation bar itself.
    self.navigationItem.rightBarButtonItem = addBarButtonItem;

    PFQuery *listQuery = [PFQuery queryWithClassName:@"sharedList"];
    [listQuery whereKey:@"sharedListName" equalTo:self.sharedListName];
    [listQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!object) {
            NSLog(@"The getFirstObject request failed.");
        } else {
            // The find succeeded.
            self.members =  [object objectForKey:@"memberList"];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.title=[object objectForKey:@"groupName"];
                [self.tableView reloadData];
                
            });
        }
    }];
}

- (IBAction)segmentChanged:(id)sender {
    switch ([sender selectedSegmentIndex])
    {
        case kItemsSegment:
            self.listInfoSegmentedControl.selectedSegmentIndex = kItemsSegment;
            [self showSharedListItems];
            break;
            
        case kMembersSegment:
            self.listInfoSegmentedControl.selectedSegmentIndex = kMembersSegment;
            [self showSharedListMembers];
            break;
            
        default:
            break;
    }
}

- (void)addBarButtonPressed:(id)sender {
    if(self.listInfoSegmentedControl.selectedSegmentIndex == kItemsSegment)
        [self performSegueWithIdentifier:@"gotoSharedListAddItem" sender:self];
    else
        [self performSegueWithIdentifier:@"gotoSharedListAddMember" sender:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.listInfoSegmentedControl.selectedSegmentIndex == kItemsSegment)
        return [self.listItems count];
    else
        return [self.members count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"sharedListDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    if(self.listInfoSegmentedControl.selectedSegmentIndex == kItemsSegment)
    {
        PFObject *object = [self.listItems objectAtIndex:indexPath.row];
        [cell.textLabel setText: [object objectForKey:@"itemName"]];
        [cell.detailTextLabel setText: [object objectForKey:@"quantity"]];
        cell.imageView.image = [UIImage imageNamed:@"list item"];
    }
    
    if(self.listInfoSegmentedControl.selectedSegmentIndex == kMembersSegment)
    {
        if([[self.members objectAtIndex:indexPath.row] isEqualToString:[PFUser currentUser].username])
            cell.textLabel.text =@"You";
        else
            cell.textLabel.text = [self getContactNameFromNumber:[self.members objectAtIndex:indexPath.row]];
        [cell.detailTextLabel setText: [self.members objectAtIndex:indexPath.row]];
        cell.imageView.image = [UIImage imageNamed:@"member"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.listInfoSegmentedControl.selectedSegmentIndex == kItemsSegment)
    {
        PFObject *object = [self.listItems objectAtIndex:indexPath.row];
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
        [self.listItems removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
        
    if(self.listInfoSegmentedControl.selectedSegmentIndex == kMembersSegment)
    {
        [self.members removeObjectAtIndex:indexPath.row];
        PFQuery *query = [PFQuery queryWithClassName:@"sharedList"];
        [query whereKey:@"groupName" equalTo:self.title];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                // Delete the found object
                [object setObject:self.members forKey:@"memberList"];
                [object saveInBackground];
            }
            else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];
        [self.tableView reloadData];
    }
    
}

- (NSString*) getContactNameFromNumber:(NSString*) phoneNumber
{
    CFErrorRef error = NULL;
    NSString *fullName;
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, &error);
    NSArray *allContacts = (__bridge_transfer NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        
    NSUInteger i = 0;
    for (i = 0; i < [allContacts count]; i++)
    {
        ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
        // Get the phone numbers as a multi-value property.
        ABMultiValueRef phonesRef = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
        for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
            CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
            CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
            
            if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo)
            {
                NSData *asciiNumber = [(__bridge NSString *)currentPhoneValue dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
                if([phoneNumber isEqualToString:[[NSString alloc] initWithData:asciiNumber encoding:NSASCIIStringEncoding]])
                {
                    NSString *firstName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson,kABPersonFirstNameProperty);
                    if(!firstName)
                        firstName = @"";
                    NSString *lastName = (__bridge_transfer NSString *)ABRecordCopyValue(contactPerson, kABPersonLastNameProperty);
                    if(!lastName)
                        lastName = @"";
                    fullName = [NSString stringWithFormat:@"%@ %@", firstName, lastName];

                }
            }
            
            CFRelease(currentPhoneLabel);
            CFRelease(currentPhoneValue);
        }
        CFRelease(phonesRef);
    }
    CFRelease(addressBook);
    return fullName;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gotoSharedListAddItem"])
    {
        SHRAddItemViewController *destViewController = segue.destinationViewController;
        destViewController.listName = self.sharedListName;
        destViewController.listShared = YES;
    }
    
    if ([segue.identifier isEqualToString:@"gotoSharedListAddMember"])
    {
        SHRShareListViewController *destViewController = segue.destinationViewController;
        destViewController.groupName = self.title;
        destViewController.listName = self.sharedListName;
        
    }

}


@end
