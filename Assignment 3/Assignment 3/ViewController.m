//
//  ViewController.m
//  Assignment 3
//
//  Created by Shruti Chandrakantha on 10/7/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputText;
@property (weak, nonatomic) IBOutlet UITextField *xPosition;
@property (weak, nonatomic) IBOutlet UITextField *yPosition;
@property (weak, nonatomic) IBOutlet UILabel *movingLabel;
- (IBAction)buttonPressed;

@property (assign) CGFloat xVal;
@property (assign) CGFloat yVal;
@end

NSString * const xValue = @"xValue";
NSString * const yValue = @"yValue";
NSString * const displayText = @"displayText";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:xValue])
    {
        self.xVal = [(NSNumber *)[[NSUserDefaults standardUserDefaults]
                                  objectForKey:xValue] floatValue];
        NSString *msg;
        msg = [NSString stringWithFormat:
               @"%d",[(NSNumber *)[[NSUserDefaults standardUserDefaults]
                                   objectForKey:xValue] intValue]];
        self.xPosition.text  =  msg;
        
        self.yVal = [(NSNumber *)[[NSUserDefaults standardUserDefaults]
                                  objectForKey:yValue] floatValue];
        msg = [NSString stringWithFormat:
               @"%d",[(NSNumber *)[[NSUserDefaults standardUserDefaults]
                                   objectForKey:yValue] intValue]];
        self.yPosition.text = msg;
        
        msg = [[NSUserDefaults standardUserDefaults]
                 stringForKey:displayText];
        self.inputText.text = msg;
        self.movingLabel.center = CGPointMake(_xVal,_yVal);
        self.movingLabel.text = self.inputText.text;
        self.movingLabel.hidden = NO;
        [self.movingLabel sizeToFit];
    }
    else
    {
        self.xVal = 0;
        self.yVal = 0;
    }
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidEnterBackground:)
     name:UIApplicationDidEnterBackgroundNotification
     object:app];

}

- (void)applicationDidEnterBackground:(NSNotification *)notification
{
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSNumber numberWithFloat:self.xVal] forKey:xValue];
    
    [[NSUserDefaults standardUserDefaults]
     setObject:[NSNumber numberWithFloat:self.yVal] forKey:yValue];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.inputText.text forKey:displayText];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)buttonPressed {
    NSString *msg;
    if ([self.inputText.text length] > 0) {
        msg = [NSString stringWithFormat:
               @"%@",self.inputText.text];
    }
    else {
        msg = @"";
    }
    if ([self.xPosition.text length] > 0 || [self.yPosition.text length] > 0)
    {
        self.movingLabel.text = msg;
        self.xVal = [[self.xPosition text] floatValue];
        self.yVal = [[self.yPosition text] floatValue];
        self.movingLabel.center = CGPointMake(_xVal,_yVal);
    }
    self.movingLabel.hidden = NO;
    [self.movingLabel sizeToFit];
    [self.inputText resignFirstResponder];
    [self.xPosition resignFirstResponder];
    [self.yPosition resignFirstResponder];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    self.xVal = currentPoint.x;
    self.yVal = currentPoint.y;
    self.movingLabel.center = currentPoint;
    NSString *msg;
    msg = [NSString stringWithFormat:
            @"%d",[[NSNumber numberWithFloat:currentPoint.x] intValue]];
    self.xPosition.text  =  msg;
    msg = [NSString stringWithFormat:
            @"%d",[[NSNumber numberWithFloat:currentPoint.y] intValue]];
    self.yPosition.text  =  msg;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    NSArray *subviews = [self.view subviews];
    for (id objects in subviews) {
        if ([objects isKindOfClass:[UITextField class]]) {
            UITextField *theTextField = objects;
            if ([objects isFirstResponder]) {
                [theTextField resignFirstResponder];
            }
        }
    }
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    self.xVal = currentPoint.x;
    self.yVal = currentPoint.y;
    self.movingLabel.center = currentPoint;
    NSString *msg;
    msg = [NSString stringWithFormat:
            @"%d",[[NSNumber numberWithFloat:currentPoint.x] intValue]];
    self.xPosition.text  =  msg;
    msg = [NSString stringWithFormat:
            @"%d",[[NSNumber numberWithFloat:currentPoint.y] intValue]];
    self.yPosition.text  =  msg;
}
@end
