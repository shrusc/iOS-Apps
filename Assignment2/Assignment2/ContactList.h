//
//  ContactList.h
//  Assignment2
//
//  Created by Shruti Chandrakantha on 9/3/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#ifndef Assignment2_ContactList_h
#define Assignment2_ContactList_h

#import <Foundation/Foundation.h>
#import "Person.h"

@interface ContactList : NSObject

@property NSMutableArray* allContacts;

- (id)init;

- (void) addPerson: (Person *) newContact;

- (NSArray *) orderedByName;

- (NSArray *) phoneNumberFor: (NSString *) lastName;

- (NSString *) nameForNumber: (NSString *) phoneNumber;

@end

#endif
