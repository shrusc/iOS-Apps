//
//  SHRListDetailViewController.m
//  SharedList
//
//  Created by Shruti Chandrakantha on 11/26/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRListDetailViewController.h"
#import "SHRAddMembersViewController.h"
#import "SHRTypeSelectionViewController.h"

@interface SHRListDetailViewController ()
@property NSString* groupName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SHRListDetailViewController

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
- (IBAction)shareListPressed {
    UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Enter Group Name" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    [dialog setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [dialog show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        // NSLog(@"%@",[[alertView textFieldAtIndex:0]text]);
        self.groupName = [[alertView textFieldAtIndex:0]text];
        [self performSegueWithIdentifier:@"gotoAddMembers" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"gotoAddMembers"])
    {
        SHRAddMembersViewController *destViewController = segue.destinationViewController;
        destViewController.groupName = self.groupName;
        destViewController.listName = self.listName;
        
    }
    if([segue.identifier isEqualToString:@"gotoAddItem"])
    {
        SHRTypeSelectionViewController *destViewController = segue.destinationViewController;
        destViewController.listName = self.listName;
        
    }
    
}


@end
