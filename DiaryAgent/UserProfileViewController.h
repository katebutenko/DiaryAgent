//
//  UserProfileViewController.h
//  DiaryAgent
//
//  Created by sitecore on 22.09.12.
//
//

#import <UIKit/UIKit.h>

@class UserProfile;
@protocol UserProfileViewControllerDelegate;
@protocol UserProfileDelegate;

@interface UserProfileViewController : UIViewController <UserProfileDelegate, UIWebViewDelegate>

@property (weak, nonatomic) id <UserProfileViewControllerDelegate> delegate;

@property (strong, nonatomic) UserProfile *userProfile;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIWebView *userProfileWebView;
@property (strong, nonatomic) UIView *loadingView;

- (IBAction)done:(id)sender;

@end

@protocol UserProfileViewControllerDelegate <NSObject>
- (void)UserProfileViewControllerDidFinish:(UserProfileViewController *)controller;
@end