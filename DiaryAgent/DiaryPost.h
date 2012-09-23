//
//  DiaryPost.h
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserProfile.h"

@interface DiaryPost : NSObject


@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *shortDescription;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) UIImage *avatarImage;

-(id)initWithName:(NSString *)title username:(NSString *)username shortDescription:(NSString *)shortDescription 
avatar:(NSString *)avatar userID:(NSString *)userID;
@end
