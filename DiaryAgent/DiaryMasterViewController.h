//
//  DiaryMasterViewController.h
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "PullToRefresh/PullRefreshTableViewController.h"
#import "DiaryPostDataController.h"

@interface DiaryMasterViewController : PullRefreshTableViewController <DiaryPostDataControllerDelegate>

@property (strong, nonatomic) DiaryPostDataController *dataController;
@property (weak, nonatomic) LoadingView *loadingView;

- (IBAction)changeUser:(id)sender;
- (IBAction)changeDiary:(id)sender;

@end