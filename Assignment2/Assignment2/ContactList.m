//
//  ContactList.m
//  Assignment2
//
//  Created by Shruti Chandrakantha on 9/3/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "ContactList.h"

@implementation ContactList : NSObject


- (id)init {
    if (self = [super init]) {
        self.allContacts = [[NSMutableArray alloc] init];
    }
    return self;
}



- (void) addPerson: (Person *) newContact{
    [self.allContacts addObject:newContact];
}



- (NSArray *) orderedByName{
    NSSortDescriptor *aSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"lastName" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:aSortDescriptor];
    NSArray *sortedArray;
    sortedArray = [self.allContacts sortedArrayUsingDescriptors:sortDescriptors];
    return sortedArray;
}



- (NSArray *) phoneNumberFor: (NSString *) lastName{
    NSUInteger i, count = [self.allContacts count];
    for (i=0; i<count; i++){
        Person* person=[self.allContacts objectAtIndex:i];
        if([person.myName.lastName isEqualToString:lastName]){
            return person.myPhoneNumbers;
        }
    }
    return nil;
}



- (NSString *) nameForNumber: (NSString *) phoneNumber{
    NSUInteger i, j, count = [self.allContacts count];
    Person* person;
    PhoneNumber* number;
    NSMutableString *fullName;
    for (i=0; i<count; i++){
        person=[self.allContacts objectAtIndex:i];
        //for each person in the contactlist loop through all his/her ph.nos. to see if the no. is present
        for(j=0; j<[person.myPhoneNumbers count]; j++){
            number=[person.myPhoneNumbers objectAtIndex:j];
            if([number.phNumber isEqualToString:phoneNumber]){
                fullName= [NSMutableString stringWithString:person.myName.firstName];
                [fullName appendString:@" "];
                [fullName appendString:person.myName.lastName];
                return fullName;
            }
        }
    }
    return nil;
}


@end
