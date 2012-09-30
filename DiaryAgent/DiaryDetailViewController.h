//
//  DiaryDetailViewController.h
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLNode.h"
#import "DiaryConnector.h"
#import "DiaryMasterViewController.h"

@class DiaryPost;

@interface DiaryDetailViewController :  UIViewController <DiaryConnectorDelegate, UIWebViewDelegate>

@property (strong, nonatomic) DiaryPost *diaryPost;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UIWebView *diaryPostWebView;

@end
