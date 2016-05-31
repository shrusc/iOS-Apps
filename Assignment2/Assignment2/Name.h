//
//  Name.h
//  Assignment2
//
//  Created by Shruti Chandrakantha on 9/1/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#ifndef Assignment2_Name_h
#define Assignment2_Name_h


#import <Foundation/Foundation.h>

@interface Name : NSObject

@property NSString* firstName;
@property NSString* lastName;

- (id) init;

- (id)initFirstName: (NSString *) firstName initLastName:(NSString *) lastName;

+ (id) firstName: (NSString *) firstName lastName: (NSString *) lastName;

- (NSString*) description;

- (NSComparisonResult)compare:(Name *) aName;

@end

#endif
