//
//  Header.h
//  Assignment2
//
//  Created by Shruti Chandrakantha on 9/1/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#ifndef Assignment2_Header_h
#define Assignment2_Header_h

#import <Foundation/Foundation.h>
#import "Name.h"
#import "PhoneNumber.h"

@interface Person : NSObject

@property Name* myName;
@property NSMutableArray* myPhoneNumbers;

- (id)init;

- (id)initFirstName: (NSString *) firstName initLastName:(NSString *) lastName;

+ (id) firstName: (NSString *) firstName lastName: (NSString *) lastName;

- (void) setPhoneNumber: (PhoneNumber *) number;

- (NSString*) description;

- (NSString *) phoneNumber: (NSString *) phoneType;

- (BOOL) hasNumber: (NSString *) phoneNumber;

@end
#endif
