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
#import "HTMLparser.h"
#define add(A,B) [(A) stringByAppendingString:(B)]

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
    DiaryConnector *diaryConnector = [[DiaryConnector alloc] init];
    diaryConnector.delegate = self;
    //[diaryConnector asyncTest];
    NSString *diaryName = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"diaryName"];
    if ([diaryName length]==0){
        diaryName = @"khkh";
    }
    NSString *savedData;
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/favoritesFile2.txt",
                          documentsDirectory];
    NSLog(@"Error2: %@", fileName);
    savedData = [[NSString alloc] initWithContentsOfFile:fileName
                                                encoding:NSWindowsCP1251StringEncoding error:nil];
    if ([savedData length]==0){
        diaryName = add(@"http://",diaryName);
        [diaryConnector asyncGetHTMLFromURL:add(diaryName,@".diary.ru/?favorite")];
    
    }
    else{
        
        [self dataReceived:savedData];
    }

    
}

- (NSUInteger)countOfList {
return [self.diaryPostList count];
}

- (DiaryPost *)objectInListAtIndex:(NSUInteger)theIndex {
return [self.diaryPostList objectAtIndex:theIndex];
}
- (void) addPostWithTitle:(NSString *)title username:(NSString *)username shortDescription:(NSString *)shortDescription   avatar:(NSString *)avatar userLink:(NSString *)userLink{
    //DiaryPost *post = [[DiaryPost alloc] initWithName:title username:username shortDescription:shortDescription avatar:avatar userLink:userLink];
    //[self.diaryPostList addObject:post];
}

-(void)dataReceived:(NSString *)html{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    NSArray *postsArray = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"singlePost  count" allowPartial:TRUE];
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
        
        NSString *trimmedString = [postDescription stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
       
        if ([trimmedString length]>350){
            trimmedString = [trimmedString substringToIndex:350];
        }
        
        //Delete tags, as they ruined the height of the tableview cells
        NSRange rangeOfTags = [trimmedString rangeOfString:@"@темы"];
        if (rangeOfTags.length > 0){
            trimmedString = [trimmedString stringByPaddingToLength:rangeOfTags.location-2 withString:@"." startingAtIndex:0];
            trimmedString = [trimmedString stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        }
        

        DiaryPost *diaryPost = [[DiaryPost alloc] initWithName:postTitle username:userName shortDescription:trimmedString avatar:avatar userLink:userLink postLink:postLink];
        [diaryPostsArray addObject:diaryPost];
    }
    
    self.diaryPostList = diaryPostsArray;
    [self.delegate reload];
    
}

@end
