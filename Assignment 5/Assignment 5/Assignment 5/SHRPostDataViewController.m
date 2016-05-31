//
//  SHRPostDataViewController.m
//  Assignment 5
//
//  Created by Shruti Chandrakantha on 11/5/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "SHRPostDataViewController.h"

@interface SHRPostDataViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *ratingSegment;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@end

@implementation SHRPostDataViewController

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
    UITapGestureRecognizer* tapBackground = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    [tapBackground setNumberOfTapsRequired:1];
    [self.view addGestureRecognizer:tapBackground];
    self.ratingSegment.selectedSegmentIndex = -1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dismissKeyboard:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)sendData {
    [self.commentsTextView resignFirstResponder];
    //POST the rating
    if(!(self.ratingSegment.selectedSegmentIndex == -1))
        [self postRating];
    //POST the comments
    if(![self.commentsTextView.text isEqualToString:@""])
        [self postComment];
    [[self navigationController] popViewControllerAnimated:YES];

}
 - (void)postRating
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    int rating = [self.ratingSegment selectedSegmentIndex]+1;
    NSString* ratingURLString = [NSString stringWithFormat:@"http://bismarck.sdsu.edu/rateme/rating/%@/%d",self.lecturerId      ,rating];
    NSURL *ratingURL = [NSURL URLWithString:ratingURLString];

    NSMutableURLRequest *ratingRequest = [NSMutableURLRequest requestWithURL:ratingURL
                                                                     cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                 timeoutInterval:60.0];
    [ratingRequest setHTTPMethod:@"POST"];
        
    NSURLSessionDataTask *postRatingDataTask = [session dataTaskWithRequest:ratingRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error != nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"POST rating error"
                                                                message:[NSString stringWithFormat:@"Task finished with error: %@",error.localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
        }
            
    }];
    [postRatingDataTask resume];
}

- (void)postComment
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    NSString* commentsURLString = [NSString stringWithFormat:@"http://bismarck.sdsu.edu/rateme/comment/%@",self.lecturerId];
    NSURL *commentsURL = [NSURL URLWithString:commentsURLString];
    NSMutableURLRequest *commentsRequest = [NSMutableURLRequest requestWithURL:commentsURL
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                   timeoutInterval:60.0];
    [commentsRequest setHTTPMethod:@"POST"];
    [commentsRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
    [commentsRequest setHTTPBody:[self.commentsTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLSessionDataTask *postCommentsDataTask = [session dataTaskWithRequest:commentsRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error != nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"POST comments Error"
                                                                message:[NSString stringWithFormat:@"Task finished with error: %@",error.localizedDescription]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
        }
            
    }];
    [postCommentsDataTask resume];

}

@end
