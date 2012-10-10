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

@synthesize diaryPost=_diaryPost,
            titleLabel = _titleLabel,
            usernameLabel = _usernameLabel,
            data = _data,
            loadingView=_loadingView,
            diaryPostWebView = _diaryPostWebView,
            avatar = _avatar;

- (void)UserProfileViewControllerDidFinish:(UserProfileViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)setDiaryPostWebView:(UIWebView *)diaryPostWebView
{
    if (_diaryPostWebView != diaryPostWebView){
        _diaryPostWebView = diaryPostWebView;
    }
    _diaryPostWebView.delegate = self;
}
#pragma mark - Managing the detail item

- (void)setDiaryPost:(id)newDiaryPost
{
    if (_diaryPost != newDiaryPost){
        _diaryPost = newDiaryPost;
    }        
    [self configureView];
}

- (void)configureView
{
    DiaryPost *post = self.diaryPost;
    LoadingView *loadingView = [LoadingView loadingViewInView:self.view];
    self.loadingView = loadingView;
    if (post) {
        self.titleLabel.text = post.title;
        
        [self.avatar setImage:post.avatarImage];
        
         DiaryConnector *diaryConnector = [[DiaryConnector alloc] init];
         diaryConnector.delegate = self;
        [diaryConnector asyncGetHTMLFromURL:post.postLink];
        
        self.usernameLabel.text = post.username;
    }
}

-(void)dataReceived:(NSString *)html{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    self.data = bodyNode;
    HTMLNode *postNode = [self.data findChildWithAttribute:@"class" matchingName:@"singlePost  count" allowPartial:TRUE];
    
    HTMLNode *postContentNode = [postNode findChildOfClass:@"paragraph"];
    NSString *text = [postContentNode rawContents];
    [self.diaryPostWebView loadHTMLString:text baseURL:nil];
  
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setDiaryPost:nil];
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
    UserProfileViewController *userProfileViewController = (UserProfileViewController *)[[[segue destinationViewController] viewControllers] objectAtIndex:0];
    
    LoadingView *loadingView = [LoadingView loadingViewInView:userProfileViewController.view];
    userProfileViewController.loadingView = loadingView;
    
    UserProfile *userProfile = [[UserProfile alloc] initWithID:self.diaryPost.userLink];
    userProfileViewController.userProfile = userProfile;
    userProfileViewController.delegate = self;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.loadingView
     performSelector:@selector(removeView)
     withObject:nil];
}
@end
