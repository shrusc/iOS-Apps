//
//  NSString+PhoneNumberMethods.m
//  Assignment2
//
//  Created by Shruti Chandrakantha on 9/10/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import "NSString+PhoneNumberMethods.h"

@implementation NSString (PhoneNumberMethods)

- (NSString *)phoneFormat {
    NSMutableString* formattedString = [NSMutableString string];
    int count=0;
    for (int i = 0; i < [self length]; i++){
        unichar ch = [self characterAtIndex:i];
        if((ch == ' ') || (ch == '-')) continue;
        if((count==3) || (count==7)){
            [formattedString appendFormat:@"-"];
            count=count+1;
        }
        if((ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')){
            [formattedString appendFormat:@"%c", ch];
            count=count+1;
        }
        
    }
    return formattedString;
}



- (PhoneNumber*) asPhoneNumber {
    NSString* colon= @":";
    NSRange range = [self rangeOfString:colon];
    if (range.location == NSNotFound){
       [NSException raise:@"Invalid format" format:@"phonenumber %@ is invalid", self];
    }
    NSInteger idx = range.location + range.length;
    
    //split the string into type and number and check if both are valid
    NSString* subString2 = [self substringFromIndex:idx];
    NSString* subString1 = [self substringToIndex:(idx-1)];
    
    //Check if the type in the string is a vaild type present in the typeArray
    NSArray* typeArray = [NSArray arrayWithObjects: @"mobile", @"home", @"work", @"main", @"homefax", @"workfax", @"other", nil];
    NSString* lowerCase = [subString1 lowercaseString];
    PhoneNumber* sortedNumber = [[PhoneNumber alloc] init];
    if ( ! [typeArray containsObject: lowerCase] ) {
        [NSException raise:@"Invalid format" format:@"phonenumber %@ is invalid", self];
    }
    else {
        sortedNumber.phType = lowerCase;
    }
    
    //check if the number is starting with a space like @"work: 619-594-6191"
    unichar ch = [subString2 characterAtIndex:0];
    if(ch == ' ')   subString2 = [subString2 substringFromIndex:1];
    
    //check the format of the number and pass it to sortedNumber
    NSString* line= @"-";
    NSRange range2 = [subString2 rangeOfString:line];
    if (range2.location == NSNotFound){
        [NSException raise:@"Invalid format" format:@"phonenumber %@ is invalid", self];
    }
    //check the length of the phnumber including the white space in the beginning
    if ([subString2 length] !=12 ) {
        [NSException raise:@"Invalid format" format:@"phonenumber %@ is invalid", self];
    }
    for (int i = 0; i < [subString2 length]; i++){
        unichar ch = [subString2 characterAtIndex:i];
        if((ch == '-') && (i !=3) && (i!=7)){
          [NSException raise:@"Invalid format" format:@"phonenumber %@ is invalid", self];
        }
    }
    [subString2 phoneFormat];
    sortedNumber.phNumber=subString2;

    return sortedNumber;
}


@end
