//
//  Name.m
//  Assignment2
//
//  Created by Shruti Chandrakantha on 9/1/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "Name.h"

@implementation Name : NSObject

// Super override initializer
- (id)init{
    return [self initFirstName:nil initLastName:nil];
}


// Designated Initializer
- (id)initFirstName: (NSString *) firstName initLastName:(NSString *) lastName{
    self = [super init];
    if (self)
    {
        self.firstName = firstName;
        self.lastName = lastName;
    }
    return self;
}


// Class secondary initializer
+ (id) firstName: (NSString *) firstName lastName: (NSString *) lastName{
    return [[self alloc] initFirstName:firstName initLastName:lastName];
}



- (NSString*) description{
    NSMutableString *fullName = [NSMutableString stringWithString:self.firstName];
    [fullName appendString:@" "];
    [fullName appendString:self.lastName];
    return fullName;
}



- (NSComparisonResult)compare:(Name *) aName{
//Use the description method to get the fullname of both the strings to compare
    NSString* origName = self.description;
    NSString* nameToCompare = aName.description;
    return ([origName compare:nameToCompare options:NSCaseInsensitiveSearch]);
}

@end
