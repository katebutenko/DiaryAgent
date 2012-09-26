//
//  DiaryDetailViewController.h
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiaryPost;

@interface DiaryDetailViewController :  UIViewController

@property (strong, nonatomic) DiaryPost *diaryPost;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;

@property (weak, nonatomic) IBOutlet UIWebView *diaryPostWebView;
-(void)setText:(NSString *)text;
@end
