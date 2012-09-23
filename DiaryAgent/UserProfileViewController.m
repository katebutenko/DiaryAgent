//
//  UserProfileViewController.m
//  DiaryAgent
//
//  Created by sitecore on 22.09.12.
//
//

#import "UserProfileViewController.h"
#import "UserProfile.h"

@interface UserProfileViewController ()

- (void)configureView;

@end

@implementation UserProfileViewController

@synthesize username;
@synthesize avatar;
@synthesize delegate = _delegate;
@synthesize userProfile = _userProfile;
@synthesize userProfileWebView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self configureView];
}

- (void)viewDidUnload
{
    [self setUsername:nil];
    [self setAvatar:nil];
    self.userProfile = nil;
    [self setUserProfileWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)done:(id)sender {
    [[self delegate] UserProfileViewControllerDidFinish:self];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    UserProfile *profile = self.userProfile;
    if (profile) {
        [self.userProfileWebView loadHTMLString:[self.userProfile rawProfileData] baseURL:nil];
        }
}

@end
