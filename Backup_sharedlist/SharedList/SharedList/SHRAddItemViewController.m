//
//  SHRAddItemViewController.m
//  SharedList
//
//  Created by Shruti Chandrakantha on 11/24/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRAddItemViewController.h"
#import <Parse/Parse.h>

@interface SHRAddItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;

@end

@implementation SHRAddItemViewController

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
- (IBAction)enterPressed:(id)sender {
    PFObject *list = [PFObject objectWithClassName:@"singleList"];
    list[@"listName"] = self.listName;
    list[@"category"] = self.category;
    list[@"itemName"] = self.itemTextField.text;
    list[@"quantity"] = self.quantityTextField.text;
    list[@"user"] = [PFUser currentUser];
    [list saveInBackground];
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
