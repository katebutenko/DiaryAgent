//
//  DiaryPostDataController.h
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"
#import "DiaryConnector.h"
#import "DiaryPost.h"
#import "DiaryMasterViewController.h"

@protocol DiaryPostDataControllerDelegate <NSObject>
- (void)reload;
@end

@interface DiaryPostDataController : NSObject <DiaryConnectorDelegate>

@property (nonatomic, copy) NSMutableArray *diaryPostList;
@property (nonatomic, weak) UITableViewController *table;
@property (weak, nonatomic) id <DiaryPostDataControllerDelegate> delegate;

- (NSUInteger)countOfList;
- (DiaryPost *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addPostWithTitle:(NSString *)title username:(NSString *)username shortDescription:(NSString *)shortDescription avatar:(NSString *)avatar userLink:(NSString *)userLink;

@end