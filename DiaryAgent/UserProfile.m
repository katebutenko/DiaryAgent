//
//  UserProfile.m
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import "UserProfile.h"
#import "DiaryConnector.h"
#import "HTMLNode.h"

#define add(A,B) [(A) stringByAppendingString:(B)]

@implementation UserProfile

@synthesize username = _username, avatarImage = _avatarImage, rawProfileData = _rawProfileData;

-(id)initWithID:(NSString *)userLink{
    self = [super init];
    
    if (self) {
        DiaryConnector *diaryConnector = [[DiaryConnector alloc] init];
        NSString *text = [diaryConnector getRawDataFromURL:userLink selectorId:@"contant"];

        _rawProfileData = text;
        _username = nil;
        
        //assign and store an avatarImage
       // NSURL *imageURL = [NSURL URLWithString:avatarURL];
        //NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        //_avatarImage = [UIImage imageWithData:imageData];
        _avatarImage = nil;
        
        return self;
    }
    
    return nil;

}


@end
