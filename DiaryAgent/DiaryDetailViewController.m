//
//  DiaryDetailViewController.m
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiaryDetailViewController.h"
#import "DiaryPost.h"
#import "DiaryConnector.h"
#import "LoadingView.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

@interface DiaryDetailViewController ()
@property (strong, nonatomic) HTMLNode *data;
@property (weak, nonatomic) LoadingView *loadingView;
- (void)configureView;
@end

#import "UserProfileViewController.h"

@interface DiaryDetailViewController () <UserProfileViewControllerDelegate>
@end

@implementation DiaryDetailViewController
@synthesize avatar = _avatar;
@synthesize diaryPostWebView = _diaryPostWebView;
@synthesize diaryPost=_diaryPost, titleLabel = _titleLabel, usernameLabel = _usernameLabel, data = _data, loadingView=_loadingView;

- (void)UserProfileViewControllerDidFinish:(UserProfileViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Managing the detail item

- (void)setDiaryPost:(id)newDiaryPost
{
    if (_diaryPost != newDiaryPost){
        _diaryPost = newDiaryPost;
    }        
        // Update the view.
        [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.
    DiaryPost *post = self.diaryPost;
    LoadingView *loadingView =
    [LoadingView loadingViewInView:self.view];
    self.loadingView = loadingView;
    if (post) {
        self.titleLabel.text = post.title;
        
        [self.avatar setImage:post.avatarImage];
        DiaryConnector *diaryConnector = [[DiaryConnector alloc] initWithViewController:self];
        [diaryConnector asyncGetPostFromURL:post.postLink];
        
        self.usernameLabel.text = post.username;
    }
}
-(void)setWebData:(HTMLNode *)data{
    self.data = data;
    HTMLNode *postNode = [self.data findChildWithAttribute:@"class" matchingName:@"singlePost  count" allowPartial:TRUE];
    
    HTMLNode *postContentNode = [postNode findChildOfClass:@"paragraph"];
    NSString *text = [postContentNode rawContents];
    [self.diaryPostWebView loadHTMLString:text baseURL:nil];
    
    [self.loadingView
     performSelector:@selector(removeView)
     withObject:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    self.diaryPost = nil;
    [self setAvatar:nil];
    [self setDiaryPostWebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UserProfileViewController *userProfileController = (UserProfileViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
    UserProfile *userProfile = [[UserProfile alloc] initWithID:self.diaryPost.userLink];
    userProfileController.userProfile = userProfile;
    userProfileController.delegate = self;
}

@end
