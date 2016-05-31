//
//  NSString+PhoneNumberMethods.h
//  Assignment2
//
//  Created by Shruti Chandrakantha on 9/10/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PhoneNumber.h"

@interface NSString (PhoneNumberMethods)

- (NSString *)phoneFormat;
- (PhoneNumber*) asPhoneNumber;//: (NSString *) number;

@end
