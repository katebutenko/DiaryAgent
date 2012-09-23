//
//  DiaryMasterViewController.m
//  DiaryAgent
//
//  Created by Lion User on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DiaryMasterViewController.h"

#import "DiaryDetailViewController.h"

#import "DiaryPostDataController.h"

#import "DiaryPost.h"
#import "DiaryFavPostCell.h"
#import "NewTableCell.h"

@implementation DiaryMasterViewController



@synthesize dataController = _dataController;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataController countOfList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"NewPostCell";
    
    NewTableCell *postCell = (NewTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (postCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"NewCell" owner:self options:nil];
        postCell = [nib objectAtIndex:0];
    }
    DiaryPost *postAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    
    postCell.userNameLabel.text = postAtIndex.username;
    /*
    DiaryFavPostCell *postCell = (DiaryFavPostCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (postCell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DiaryFavoritePostCell" owner:self options:nil];
        postCell = [nib objectAtIndex:0];
    }
    DiaryPost *postAtIndex = [self.dataController objectInListAtIndex:indexPath.row];
    postCell.label.text = postAtIndex.username;*/
    
    postCell.postTitleLabel.text = postAtIndex.title;

    postCell.avatarImageView.frame = CGRectMake(0,0,70,70);
    [postCell.avatarImageView setImage:postAtIndex.avatarImage];

    postCell.textView.text = postAtIndex.shortDescription;
    return postCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDiaryPostDetails"]) {
        DiaryDetailViewController *detailViewController = [segue destinationViewController];
        
        detailViewController.diaryPost = [self.dataController objectInListAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 350;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDiaryPostDetails" sender:self];
}
@end
