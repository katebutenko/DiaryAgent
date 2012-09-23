//
//  DiaryPostDataController.m
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiaryPostDataController.h"
#import "DiaryPost.h"
#import "DiaryConnector.h"

@interface DiaryPostDataController()

-(void)initPostList;

@end

@implementation DiaryPostDataController

@synthesize diaryPostList = _diaryPostList;

- (void)setDiaryPostList:(NSMutableArray *)newList {
    if (_diaryPostList != newList) {
        _diaryPostList = [newList mutableCopy];
    }
}

- (id)init {
    if (self = [super init]) {
        [self initPostList];
        return self;
    }
    return nil;
}

-(void)initPostList{
//create a connection
    DiaryConnector *diaryConnector = [[DiaryConnector alloc] init];
    NSMutableArray *postList = [diaryConnector getFavorites:@"http://khkh"];
    self.diaryPostList = postList;

}

- (NSUInteger)countOfList {
return [self.diaryPostList count];
}

- (DiaryPost *)objectInListAtIndex:(NSUInteger)theIndex {
return [self.diaryPostList objectAtIndex:theIndex];
}
-(void) addPostWithTitle:(NSString *)title username:(NSString *)username shortDescription:(NSString *)shortDescription   avatar:(NSString *)avatar userID:(NSString *)userID{
    DiaryPost *post = [[DiaryPost alloc] initWithName:title username:username shortDescription:shortDescription avatar:avatar userID:userID];
    [self.diaryPostList addObject:post];
}

@end
