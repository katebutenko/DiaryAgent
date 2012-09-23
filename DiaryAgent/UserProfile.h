//
//  UserProfile.h
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import <Foundation/Foundation.h>

@interface UserProfile : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) UIImage *avatarImage;
@property (nonatomic, copy) NSString *rawProfileData;

-(id)initWithID:(NSString *)userLink;

@end
