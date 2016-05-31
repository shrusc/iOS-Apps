//
//  SHRShareListViewController.h
//  SharedGroceryList
//
//  Created by Shruti Chandrakantha on 11/27/14.
//  Copyright (c) 2014 Shruti Saligrama Chandrakantha LNU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface SHRShareListViewController : UIViewController <ABPeoplePickerNavigationControllerDelegate,UITableViewDelegate, UITableViewDataSource>
@property NSString* groupName;
@property NSString* listName;
@end
