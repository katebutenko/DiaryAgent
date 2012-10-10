//
//  UserProfileViewController.m
//  DiaryAgent
//
//  Created by sitecore on 22.09.12.
//
//

#import "UserProfileViewController.h"
#import "UserProfile.h"

@implementation UserProfileViewController

- (void)setUserProfile:(UserProfile *)userProfile
{
    if (_userProfile != userProfile){
        _userProfile = userProfile;
    }
    _userProfile.delegate = self;
}

- (void)setUserProfileWebView:(UIWebView *)userProfileWebView
{
    if (_userProfileWebView != userProfileWebView){
        _userProfileWebView = userProfileWebView;
    }
    _userProfileWebView.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setAvatar:nil];
    [self setUserProfile:nil];
    [self setUserProfileWebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender {
    [self.delegate UserProfileViewControllerDidFinish:self];
}

-(void)userProfileDidFinishLoad{
    [self.userProfileWebView loadHTMLString:[self.userProfile rawProfileData] baseURL:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingView
     performSelector:@selector(removeView)
     withObject:nil];
}

@end
