//
//  DiaryPost.m
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiaryPost.h"

@implementation DiaryPost

@synthesize title = _title, username = _username, shortDescription = _shortDescription, avatar = _avatar, avatarImage = _avatarImage, userID = _userID;

-(id)initWithName:(NSString *)title username:(NSString *)username shortDescription:(NSString *)shortDescription avatar:(NSString *)avatar userID:(NSString *)userID{
    
    self = [super init];
    
    if (self) {
        _title = title;
        _username = username;
        _shortDescription = shortDescription;
        _avatar = avatar;
        _userID = userID;
        //assign and store an avatarImage
        NSURL *imageURL = [NSURL URLWithString:avatar];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        _avatarImage = [UIImage imageWithData:imageData];
        
        return self;
    }
    
    return nil;
}

@end
