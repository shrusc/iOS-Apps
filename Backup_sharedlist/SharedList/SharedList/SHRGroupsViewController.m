//
//  SHRGroupsViewController.m
//  SharedList
//
//  Created by Shruti Chandrakantha on 11/24/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRGroupsViewController.h"
#import <Parse/Parse.h>

@interface SHRGroupsViewController ()
@property NSArray* sharedLists;
@property NSString* selectedSharedListName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SHRGroupsViewController

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
    PFQuery *listQuery = [PFQuery queryWithClassName:@"sharedList"];
    [listQuery whereKey:@"memberList" equalTo:[PFUser currentUser].username];
    [listQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.sharedLists = objects;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            
        });
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sharedLists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"groupListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    PFObject *post = [self.sharedLists objectAtIndex:indexPath.row];
    self.selectedSharedListName = [post objectForKey:@"sharedListName"];
    [cell.textLabel setText: self.selectedSharedListName];
    return cell;
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
