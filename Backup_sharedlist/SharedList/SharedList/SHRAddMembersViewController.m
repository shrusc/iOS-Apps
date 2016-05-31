//
//  SHRAddMembersViewController.m
//  SharedList
//
//  Created by Shruti Chandrakantha on 11/26/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRAddMembersViewController.h"
#import <Parse/Parse.h>

@interface SHRAddMembersViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstMember;
@property (weak, nonatomic) IBOutlet UITextField *secondMember;
@property (weak, nonatomic) IBOutlet UITextField *thirdMember;

@end
NSMutableArray* members;
@implementation SHRAddMembersViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addPressed {
    PFQuery *query = [PFQuery queryWithClassName:@"sharedList"];
    [query whereKey:@"memberList" equalTo:[PFUser currentUser].username];
    [query whereKey:@"groupName" equalTo:self.groupName];
    [query whereKey:@"sharedListName" equalTo:self.listName];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User Exists"
                                                            message:@"This user is already added to this list"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else{
            PFObject *list = [PFObject objectWithClassName:@"sharedList"];
            list[@"groupName"] = self.groupName;
            list[@"sharedListName"] = self.listName;
            members = [[NSMutableArray alloc] init];
            [members addObject:self.firstMember.text];
            [members addObject:self.secondMember.text];
            [list setObject:members forKey:@"memberList"];
            [list saveInBackground];
        }
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
