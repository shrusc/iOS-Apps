//
//  SHRAddItemViewController.m
//  SharedGroceryList
//
//  Created by Shruti Chandrakantha on 11/26/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRAddItemViewController.h"
#import <Parse/Parse.h>

@interface SHRAddItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *itemTextField;
@property (weak, nonatomic) IBOutlet UITextField *quantityTextField;
@property (weak, nonatomic) IBOutlet UIStepper *quantityStepper;
@property (weak, nonatomic) IBOutlet UILabel *quantityLabel;
@property (weak, nonatomic) IBOutlet UILabel *quantityWeightLabel;
@property BOOL showTextField;
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
    self.navigationController.toolbarHidden = YES;
    self.title= [NSString stringWithFormat:@"Add to %@",self.listName];
    self.showTextField = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self view] endEditing:YES];
}

- (IBAction)savePressed:(id)sender
{
    PFObject *list = [PFObject objectWithClassName:@"singleList"];
    list[@"listName"] = self.listName;
    list[@"itemName"] = self.itemTextField.text;
    if(!self.showTextField)
        list[@"quantity"] = self.quantityLabel.text;
    else if(self.showTextField)
        list[@"quantity"] = [self.quantityTextField.text stringByAppendingString:self.quantityLabel.text];
    list[@"user"] = [PFUser currentUser].username;
    if(self.listShared)
        list[@"shared"] = @"YES";
    else
        list[@"shared"] = @"NO";
    [list saveInBackground];
    [[self navigationController] popViewControllerAnimated:YES];
}

- (IBAction)buttonPressed:(id)sender
{
    if (!self.showTextField)
    {
        [sender setTitle:@"Use quantity" forState:UIControlStateNormal];
        self.quantityTextField.frame = self.quantityStepper.frame;
        self.quantityStepper.hidden = YES;
        self.quantityTextField.hidden = NO;
        self.quantityLabel.text = @" lb";
        self.showTextField = YES;
        self.quantityWeightLabel.text = @"Weight";
    }
    else if (self.showTextField)
    {
        [sender setTitle:@"Use weight" forState:UIControlStateNormal];
        self.quantityStepper.hidden = NO;
        self.quantityTextField.hidden = YES;
        self.quantityLabel.text = @"1";
        self.showTextField = NO;
        self.quantityWeightLabel.text = @"Quantity";
    }
    
}
- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    NSUInteger value = sender.value;
    [self.quantityLabel setText:[NSString stringWithFormat:@"%d", (int)value]];
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
