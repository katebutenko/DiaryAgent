//
//  DiaryPostDataController.h
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DiaryPost;

@interface DiaryPostDataController : NSObject

@property (nonatomic, copy) NSMutableArray *diaryPostList;

- (NSUInteger)countOfList;
- (DiaryPost *)objectInListAtIndex:(NSUInteger)theIndex;
- (void)addPostWithTitle:(NSString *)title username:(NSString *)username shortDescription:(NSString *)shortDescription 
avatar:(NSString *)avatar userID:(NSString *)userID;
@end
