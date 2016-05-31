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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    //POST the rating 
    int rating = [self.ratingSegment selectedSegmentIndex]+1;
    NSString* ratingURLString = [NSString stringWithFormat:@"http://bismarck.sdsu.edu/rateme/rating/%@/%d",self.lecturerId,rating];
    NSURL *ratingURL = [NSURL URLWithString:ratingURLString];
    
    NSMutableURLRequest *ratingRequest = [NSMutableURLRequest requestWithURL:ratingURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [ratingRequest setHTTPMethod:@"POST"];
    
    NSURLSessionDataTask *postRatingDataTask = [session dataTaskWithRequest:ratingRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
    }];
    [postRatingDataTask resume];
    
    //POST the comments
    NSLog(@"comments text %@",self.commentsTextView.text);
    if(![self.commentsTextView.text isEqualToString:@"Please type your comments here"]){
        NSString* commentsURLString = [NSString stringWithFormat:@"http://bismarck.sdsu.edu/rateme/comment/%@",self.lecturerId];
        NSLog(@"url %@",commentsURLString);
        NSURL *commentsURL = [NSURL URLWithString:commentsURLString];
    
        NSMutableURLRequest *commentsRequest = [NSMutableURLRequest requestWithURL:commentsURL
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
        [commentsRequest setHTTPMethod:@"POST"];
        [commentsRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-Type"];
        [commentsRequest setHTTPBody:[self.commentsTextView.text dataUsingEncoding:NSUTF8StringEncoding]];
    
        NSURLSessionDataTask *postCommentsDataTask = [session dataTaskWithRequest:commentsRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        }];
        [postCommentsDataTask resume];
    }

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
