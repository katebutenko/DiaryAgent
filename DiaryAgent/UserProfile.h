//
//  UserProfile.h
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import <Foundation/Foundation.h>
#import "DiaryConnector.h"

@protocol UserProfileDelegate <NSObject>
- (void)userProfileDidFinishLoad;
@end

@interface UserProfile : NSObject <DiaryConnectorDelegate>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) UIImage *avatarImage;
@property (nonatomic, copy) NSString *rawProfileData;
@property (weak, nonatomic) id <UserProfileDelegate> delegate;

-(id)initWithID:(NSString *)userLink;

@end
