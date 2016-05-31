//
//  PhoneNumber.h
//  Assignment2
//
//  Created by Shruti Chandrakantha on 8/29/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#ifndef Assignment2_PhoneNumber_h
#define Assignment2_PhoneNumber_h

#import <Foundation/Foundation.h>

@interface PhoneNumber : NSObject

@property NSString *phNumber;
@property NSString *phType;

- (id)init;

- (id)initType: (NSString *) phoneType initNumber:(NSString *) number;

+ (id) type: (NSString *) phoneType number: (NSString *) number;

- (NSString *) number;

- (BOOL) isMobile;

- (BOOL) isLocal;

- (NSString *) description;


@end

#endif
