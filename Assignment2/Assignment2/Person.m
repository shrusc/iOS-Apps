//
//  Person.m
//  Assignment2
//
//  Created by Shruti Chandrakantha on 9/1/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "Person.h"

@implementation Person : NSObject

// Super override initializer
- (id)init{
    return [self initFirstName:nil initLastName:nil];
}


// Designated Initializer
- (id)initFirstName: (NSString *) firstName initLastName:(NSString *) lastName{
    self = [super init];
    if (self)
    {
        self.myName.firstName = firstName;
        self.myName.lastName = lastName;
        self.myPhoneNumbers = [[NSMutableArray alloc]init];
    }
    return self;
}


// Class secondary initializer
+ (id) firstName: (NSString *) firstName lastName: (NSString *) lastName{
    return [[self alloc] initFirstName:firstName initLastName:lastName];
}



- (void) setPhoneNumber : (PhoneNumber*) number{
    [self.myPhoneNumbers addObject:number];
}



- (NSString*) description{
    NSString *fullName = [self.myName.firstName stringByAppendingString:self.myName.lastName];
    return fullName;
}



- (NSString *) phoneNumber: (NSString *) phoneType{
    NSUInteger i, count = [self.myPhoneNumbers count];
    //Convert the phoneType to a lowercase string to compare
    NSString *string2 = [phoneType lowercaseString];
    for (i=0; i<count; i++){
        PhoneNumber* number=[self.myPhoneNumbers objectAtIndex:i];
        if([number.phType isEqualToString:string2]){
            return number.number;
        }
    }
    return nil;
}



- (BOOL) hasNumber: (NSString *) phoneNumber{
    NSUInteger i, count = [self.myPhoneNumbers count];
    for (i=0; i<count; i++){
        PhoneNumber* number=[self.myPhoneNumbers objectAtIndex:i];
        if([number.phNumber isEqualToString:phoneNumber]){
            return YES;
        }
    }
    return NO;
}

@end
