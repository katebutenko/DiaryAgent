//
//  DiaryMasterViewController.h
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiaryDetailViewController.h"
#import "LoadingView.h"

@class DiaryPostDataController;

@interface DiaryMasterViewController : UITableViewController

@property (strong, nonatomic) DiaryPostDataController *dataController;
@property (weak, nonatomic) LoadingView *loadingView;

- (IBAction)changeUser:(id)sender;
- (IBAction)changeDiary:(id)sender;
- (void)reloadData;
@end
