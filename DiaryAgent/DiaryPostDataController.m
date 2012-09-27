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
#define add(A,B) [(A) stringByAppendingString:(B)]

@interface DiaryPostDataController()

-(void)initPostList;

@end

@implementation DiaryPostDataController

@synthesize diaryPostList = _diaryPostList;
@synthesize table = _table;

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

- (id)initWithTable:(UITableViewController *)table {
    if (self = [super init]) {
        _table = table;
        [self initPostList];
        return self;
    }
    return nil;
}
-(void)initPostList{

    DiaryConnector *diaryConnector = [[DiaryConnector alloc] initWithViewController:self];
    //[diaryConnector asyncTest];
    NSString *diaryName = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"diaryName"];
    if ([diaryName length]==0){
        diaryName = @"khkh";
    }
    [diaryConnector asyncGetFavorites:add(@"http://",diaryName)];

    
}

- (NSUInteger)countOfList {
return [self.diaryPostList count];
}

- (DiaryPost *)objectInListAtIndex:(NSUInteger)theIndex {
return [self.diaryPostList objectAtIndex:theIndex];
}
-(void) addPostWithTitle:(NSString *)title username:(NSString *)username shortDescription:(NSString *)shortDescription   avatar:(NSString *)avatar userLink:(NSString *)userLink{
    //DiaryPost *post = [[DiaryPost alloc] initWithName:title username:username shortDescription:shortDescription avatar:avatar userLink:userLink];
    //[self.diaryPostList addObject:post];
}

-(void)setWebData:(HTMLNode *)data{
    NSArray *postsArray = [data findChildrenWithAttribute:@"class" matchingName:@"singlePost  count" allowPartial:TRUE];
    NSMutableArray *diaryPostsArray = [[NSMutableArray alloc] init];
    
    for (HTMLNode *singlePost in postsArray){
        //find name of the posts's author
        HTMLNode *userNameNode = [singlePost findChildOfClass:@"authorName"];
        NSString *userName = [userNameNode allContents];
        NSString *userLink = [[userNameNode findChildTag:@"a"] getAttributeNamed:@"href"];
        
        //find title of the post
        NSString *postTitle = [[[singlePost findChildWithAttribute:@"class" matchingName:@"postTitle" allowPartial:TRUE] findChildTag:@"h2"] allContents];
        //avatar
        NSString *avatar = [[[singlePost findChildOfClass:@"avatar"] findChildTag:@"img"] getAttributeNamed:@"src"];
        
        //link to the post
        NSString *postLink = [[[singlePost findChildOfClass:@"postLinksBackg"] findChildTag:@"a"] getAttributeNamed:@"href"];
        //short description
        
        NSString *postDescription = [[singlePost findChildOfClass:@"paragraph"] allContents] ;
        NSLog(@"Text: %@",postDescription);
        NSString *trimmedString = [postDescription stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Text: %@",trimmedString);
        
        if ([trimmedString length]>350){
            trimmedString = [trimmedString substringToIndex:350];
        }
        
        DiaryPost *diaryPost = [[DiaryPost alloc] initWithName:postTitle username:userName shortDescription:trimmedString avatar:avatar userLink:userLink postLink:postLink];
        [diaryPostsArray addObject:diaryPost];
    }
    
        self.diaryPostList = diaryPostsArray;
        [self.table performSelector:@selector(reloadData)];
    
}

@end
