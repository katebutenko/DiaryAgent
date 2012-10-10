//
//  DiaryPost.m
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiaryPost.h"

@implementation DiaryPost

@synthesize title = _title, username = _username, shortDescription = _shortDescription, avatar = _avatar, avatarImage = _avatarImage, userLink = _userLink, postLink=_postLink;

-(id)initWithName:(NSString *)title username:(NSString *)username
                    shortDescription:(NSString *)shortDescription avatar:(NSString *)avatar
                    userLink:(NSString *)userLink postLink:(NSString *)postLink{
    
    self = [super init];
    
    if (self) {
        _title = title;
        _username = username;
        _shortDescription = shortDescription;
        _avatar = avatar;
        _userLink = userLink;
        _postLink = postLink;
        //assign and store an avatarImage

        _avatarImage = [DiaryConnector loadImageForPath:avatar];
        
        return self;
    }
    
    return nil;
}

@end
