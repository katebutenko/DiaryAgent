//
//  DiaryPostDataController.h
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"

@class DiaryPost;

@interface DiaryPostDataController : NSObject

@property (nonatomic, copy) NSMutableArray *diaryPostList;
@property (nonatomic, weak) UITableViewController *table;

- (NSUInteger)countOfList;
- (DiaryPost *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addPostWithTitle:(NSString *)title username:(NSString *)username shortDescription:(NSString *)shortDescription 
avatar:(NSString *)avatar userLink:(NSString *)userLink;
- (id)initWithTable:(UITableViewController *)table;
-(void)setWebData:(HTMLNode *)data;
@end
