//
//  PhoneNumber.m
//  Assignment2
//
//  Created by Shruti Chandrakantha on 8/30/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "PhoneNumber.h"
#import "NSString+PhoneNumberMethods.h"

static NSString *const typeMobile = @"mobile";
static NSString *const typeHome = @"home";
static NSString *const typeWork = @"work";
static NSString *const typeMain = @"main";
static NSString *const typeHomeFax = @"homefax";
static NSString *const typeWorkFax = @"workfax";
static NSString *const typeOther = @"other";


@implementation PhoneNumber

// Super override
- (id)init{
    return [self initType:nil initNumber:nil];
}


// Designated Initializer
- (id)initType: (NSString *) phoneType initNumber:(NSString *) number{
    self = [super init];
    if (self)
    {
        self.phType = phoneType;
        //if the phonetype is not one of the acceptable types return a nil
        if ((![phoneType isEqualToString: typeMobile])|| (![phoneType isEqualToString: typeHome]) ||
            (![phoneType isEqualToString: typeWork]) || (![phoneType isEqualToString: typeMain])||
            (![phoneType isEqualToString: typeHomeFax]) || (![phoneType isEqualToString: typeWorkFax]) ||
            (![phoneType isEqualToString: typeOther])) {
            return nil;
        }
        self.phNumber = number;
    }
    return self;
}


// Class secondary initializer
+ (id) type: (NSString *) phoneType number: (NSString *) number{
    //if the phonetype is not one of the acceptable types return a nil
    if ((![phoneType isEqualToString: typeMobile])|| (![phoneType isEqualToString: typeHome]) ||
        (![phoneType isEqualToString: typeWork]) || (![phoneType isEqualToString: typeMain])||
        (![phoneType isEqualToString: typeHomeFax]) || (![phoneType isEqualToString: typeWorkFax]) ||
        (![phoneType isEqualToString: typeOther])) {
        return nil;
    }
    NSString* formattedString = number.phoneFormat;
    return [[self alloc] initType:phoneType initNumber:formattedString];
}



- (NSString *) number{
    //Call the phoneFormat in the NSString category created
    return [self.number phoneFormat];
}



- (BOOL) isMobile{
    BOOL compare = NO;
    if ([self.phType caseInsensitiveCompare:typeMobile] == NSOrderedSame)
    {
        compare = YES;
    }
    return compare;
}



- (BOOL) isLocal{
    NSString *firstThreeLetters = [self.phNumber substringToIndex:3];
    return([firstThreeLetters isEqualToString:@"619"] || [firstThreeLetters isEqualToString:@"858"]);
}



- (NSString *) description{
    NSMutableString *concatenatedString = [NSMutableString stringWithString:self.phType];
    [concatenatedString appendString:@":"];
    [concatenatedString appendString:[self.phNumber phoneFormat]];
    return concatenatedString;
}



@end
