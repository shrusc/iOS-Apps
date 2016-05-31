//
//  SHRLoginViewController.m
//  SharedList
//
//  Created by Shruti Chandrakantha on 11/24/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRLoginViewController.h"

#import <Parse/Parse.h>

@interface SHRLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SHRLoginViewController

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
    self.userTextField.delegate = self;
    self.navigationController.toolbarHidden = YES; 
}

- (void)viewWillAppear:(BOOL)animated {
    if ([PFUser currentUser]) // Check if user is cached
        [self performSegueWithIdentifier:@"gotoLists" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}

- (IBAction)loginPressed
{
    if ((self.userTextField.text.length != 0) && (self.passwordTextField.text.length != 0))
	{
        [PFUser logInWithUsernameInBackground:self.userTextField.text password:self.passwordTextField.text block:^(PFUser *user, NSError *error) {
            if (user) {
                [self performSegueWithIdentifier:@"gotoLists" sender:self];
            }
            else {
                //Something bad has ocurred
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [errorAlertView show];
            }
        }];
    }
    else
    {
        if ((self.userTextField.text.length == 0))
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"User Name" message:@"Enter your phone number as username" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            
        }
        if ((self.passwordTextField.text.length == 0))
        {
            UIAlertView *errorAlertView = [[UIAlertView alloc] initWithTitle:@"Password" message:@"Enter your password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [errorAlertView show];
            
        }

        
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int length = (int)[[self formatNumber:[textField text]] length];
    
    if (length == 10) {
        if(range.length == 0) {
            return NO;
        }
    }
    
    if (length == 3) {
        NSString *num = [self formatNumber:[textField text]];
        textField.text = [NSString stringWithFormat:@"(%@) ",num];
        if (range.length > 0) {
            [textField setText:[NSString stringWithFormat:@"%@",[num substringToIndex:3]]];
        }
    }
    else if (length == 6) {
        NSString *num = [self formatNumber:[textField text]];
        [textField setText:[NSString stringWithFormat:@"(%@) %@-",[num  substringToIndex:3],[num substringFromIndex:3]]];
        if (range.length > 0) {
            [textField setText:[NSString stringWithFormat:@"(%@) %@",[num substringToIndex:3],[num substringFromIndex:3]]];
        }
    }
    
    return YES;
}

- (NSString*)formatNumber:(NSString*)mobileNumber
{
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    mobileNumber = [mobileNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    int length = (int)[mobileNumber length];
    
    if (length > 10) {
        mobileNumber = [mobileNumber substringFromIndex: length-10];
    }
    
    return mobileNumber;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.userTextField.text = @"";
    self.passwordTextField.text = @"";
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
