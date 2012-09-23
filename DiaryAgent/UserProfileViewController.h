//
//  UserProfileViewController.h
//  DiaryAgent
//
//  Created by sitecore on 22.09.12.
//
//

#import <UIKit/UIKit.h>
#import "UserProfile.h"

@protocol UserProfileViewControllerDelegate;

@interface UserProfileViewController : UIViewController
@property (weak, nonatomic) id <UserProfileViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) UserProfile *userProfile;
@property (weak, nonatomic) IBOutlet UIWebView *userProfileWebView;

- (IBAction)done:(id)sender;

@end

@protocol UserProfileViewControllerDelegate <NSObject>
- (void)UserProfileViewControllerDidFinish:(UserProfileViewController *)controller;

@end