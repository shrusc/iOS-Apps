//
//  SHRShareListViewController.m
//  SharedGroceryList
//
//  Created by Shruti Chandrakantha on 11/27/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRShareListViewController.h"
#import <Parse/Parse.h>

@interface SHRShareListViewController ()
@property (nonatomic, strong) NSMutableArray *arrContactsData;
@property (nonatomic, strong) ABPeoplePickerNavigationController *addressBookController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray* members;
@end

@implementation SHRShareListViewController

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
    self.navigationItem.hidesBackButton = YES;
    self.members = [[NSMutableArray alloc] init];
    [self.members addObject: [PFUser currentUser].username];
    self.navigationController.toolbarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = [NSString stringWithFormat:@"%@",self.groupName];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted)
            {
                self.addressBookController = [[ABPeoplePickerNavigationController alloc] init];
                [self.addressBookController setPeoplePickerDelegate:self];
                [self presentViewController:self.addressBookController animated:YES completion:nil];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Access Contacts"
                                                                message:@"Grant permission to access contacts"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        self.addressBookController = [[ABPeoplePickerNavigationController alloc] init];
        [self.addressBookController setPeoplePickerDelegate:self];
        [self presentViewController:self.addressBookController animated:YES completion:nil];
        
    }

}


-(void)cancelAction:(UIBarButtonItem *)sender{
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showAddressBook:(id)sender
{
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined || ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted)
            {
                self.addressBookController = [[ABPeoplePickerNavigationController alloc] init];
                [self.addressBookController setPeoplePickerDelegate:self];
                [self presentViewController:self.addressBookController animated:YES completion:nil];

            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Access Contacts"
                                                                message:@"Grant permission to access contacts"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized)
    {
        self.addressBookController = [[ABPeoplePickerNavigationController alloc] init];
        [self.addressBookController setPeoplePickerDelegate:self];
        [self presentViewController:self.addressBookController animated:YES completion:nil];

    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.arrContactsData) {
        return self.arrContactsData.count;
    }
    else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    NSDictionary *contactInfoDict = [_arrContactsData objectAtIndex:indexPath.row];
    if (self.members == nil) {
        self.members = [[NSMutableArray alloc] init];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [contactInfoDict objectForKey:@"firstName"], [contactInfoDict objectForKey:@"lastName"]];
    cell.detailTextLabel.text =[NSString stringWithFormat:@"%@", [contactInfoDict objectForKey:@"mobileNumber"]];
    cell.imageView.image = [UIImage imageNamed:@"contact"];
    return cell;
}


#pragma mark - ABPeoplePickerNavigationController Delegate method implementation

-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
    
    // Initialize a mutable dictionary and give it initial values.
   NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"",@"", @""]
                                            forKeys:@[@"firstName",@"lastName", @"mobileNumber"]];
    
    // Use a general Core Foundation object.
    CFTypeRef generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // Get the first name.
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    // Get the last name.
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    // Get the phone numbers as a multi-value property.
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }

        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    // Initialize the array if it's not yet initialized.
    if (self.arrContactsData == nil) {
        self.arrContactsData = [[NSMutableArray alloc] init];
    }
    
    if([[contactInfoDict objectForKey:@"mobileNumber"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact cannot be added to the group"
                                                        message:@"The contact does not have a mobile number"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        // converts to ascii from unicode
        NSData *asciiNumber = [[contactInfoDict objectForKey:@"mobileNumber"] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *newNumber = [[NSString alloc] initWithData:asciiNumber encoding:NSASCIIStringEncoding];
        //if not already added
        if(![self.members containsObject:newNumber])
        {
            // Add the dictionary to the array.
            [self.arrContactsData addObject:contactInfoDict];
            [self.members addObject:newNumber];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                
        });
    }
    // Dismiss the address book view controller.
    [self.addressBookController dismissViewControllerAnimated:YES completion:nil];

    return;
}

//To Keep compatibility with ios 7
-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    
    // Initialize a mutable dictionary and give it initial values.
    NSMutableDictionary *contactInfoDict = [[NSMutableDictionary alloc]
                                            initWithObjects:@[@"",@"", @""]
                                            forKeys:@[@"firstName",@"lastName", @"mobileNumber"]];
    
    // Use a general Core Foundation object.
    CFTypeRef generalCFObject = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    
    // Get the first name.
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"firstName"];
        CFRelease(generalCFObject);
    }
    
    // Get the last name.
    generalCFObject = ABRecordCopyValue(person, kABPersonLastNameProperty);
    if (generalCFObject) {
        [contactInfoDict setObject:(__bridge NSString *)generalCFObject forKey:@"lastName"];
        CFRelease(generalCFObject);
    }
    
    // Get the phone numbers as a multi-value property.
    ABMultiValueRef phonesRef = ABRecordCopyValue(person, kABPersonPhoneProperty);
    for (int i=0; i<ABMultiValueGetCount(phonesRef); i++) {
        CFStringRef currentPhoneLabel = ABMultiValueCopyLabelAtIndex(phonesRef, i);
        CFStringRef currentPhoneValue = ABMultiValueCopyValueAtIndex(phonesRef, i);
        
        if (CFStringCompare(currentPhoneLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo) {
            [contactInfoDict setObject:(__bridge NSString *)currentPhoneValue forKey:@"mobileNumber"];
        }
        
        CFRelease(currentPhoneLabel);
        CFRelease(currentPhoneValue);
    }
    CFRelease(phonesRef);
    // Initialize the array if it's not yet initialized.
    if (self.arrContactsData == nil) {
        self.arrContactsData = [[NSMutableArray alloc] init];
    }
    
    if([[contactInfoDict objectForKey:@"mobileNumber"] isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Contact cannot be added to the group"
                                                        message:@"The contact does not have a mobile number"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        //convert to ascii from unicode
         NSData *asciiNumber = [[contactInfoDict objectForKey:@"mobileNumber"] dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
         NSString *newNumber = [[NSString alloc] initWithData:asciiNumber encoding:NSASCIIStringEncoding];
        if(![self.members containsObject:newNumber])
        {
            // Add the dictionary to the array.
            [self.arrContactsData addObject:contactInfoDict];
            [self.members addObject:newNumber];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    }
    // Dismiss the address book view controller.
    [self.addressBookController dismissViewControllerAnimated:YES completion:nil];
    
    return YES;
}




-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return YES;
}

//END Compatibility with ios 7

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self.addressBookController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)shareList:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"sharedList"];
    [query whereKey:@"groupName" equalTo:self.groupName];
    [query whereKey:@"sharedListName" equalTo:self.listName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object)
        {
            //user exists in the list remove user from self.members
            NSArray* sharedMembers = [object objectForKey:@"memberList"];
            for(id member in sharedMembers)
            {
                if([self.members containsObject:member])
                [self.members removeObject:member];
            }
            [self.members addObjectsFromArray:sharedMembers];
            [object setObject:self.members forKey:@"memberList"];
            [object saveInBackground];
            PFQuery *listQuery = [PFQuery queryWithClassName:@"singleList"];
            [listQuery whereKey:@"listName" equalTo:self.listName];
            [listQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *object in objects)
                {
                    [object setObject:@"YES" forKey:@"shared"];
                    [object saveInBackground];
                }
            }];
        }
        else
        {
            PFObject *list = [PFObject objectWithClassName:@"sharedList"];
            list[@"groupName"] = self.groupName;
            list[@"sharedListName"] = self.listName;
            [list setObject:self.members forKey:@"memberList"];
            [list saveInBackground];
            PFQuery *listQuery = [PFQuery queryWithClassName:@"singleList"];
            [listQuery whereKey:@"listName" equalTo:self.listName];
            [listQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                for (PFObject *object in objects)
                {
                    [object setObject:@"YES" forKey:@"shared"];
                    [object saveInBackground];
                }
            }];
                
        }
        [self performSegueWithIdentifier:@"gotoAllLists" sender:self];
        
    }];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
