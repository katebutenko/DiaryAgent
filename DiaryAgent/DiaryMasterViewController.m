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
#import "DiaryConnector.h"
#import "LoadingView.h"

@implementation DiaryMasterViewController

@synthesize dataController = _dataController, loadingView=_loadingView;

- (void)viewDidLoad{
    [super viewDidLoad];
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"loginData"];
    if ([savedValue length] == 0){
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login"
                                                      message:nil
                                                     delegate:self 
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    [message show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    NSString *alertTitle = alertView.title;
    if([alertTitle isEqualToString:@"Login"] && [title isEqualToString:@"OK"])
    {
        UITextField *username = [alertView textFieldAtIndex:0];
        UITextField *password = [alertView textFieldAtIndex:1];
        NSLog(@"Username: %@\nPassword: %@", username.text, password.text);
    
        DiaryConnector *diaryConnector = [[DiaryConnector alloc] init];
        
    NSString *valueToSave = [diaryConnector getEncodedDataForLogin:username.text password:password.text];
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"loginData"];
    

    }
    if([alertTitle isEqualToString:@"Diary"] && [title isEqualToString:@"OK"])
    {
        UITextField *diaryName = [alertView textFieldAtIndex:0];

        NSString *valueToSave = diaryName.text;
        NSLog(@"DiaryName %@",valueToSave);
        [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"diaryName"];
        
        
    }
}

-(IBAction)changeUser:(id)sender{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Login"
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:@"Cancel",nil];
    [message setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
    
    [message show];

    
}

-(IBAction)changeDiary:(id)sender{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Diary"
                                                      message:@"Выберите дневник"
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:@"Cancel",nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];
}

- (void)viewDidUnload{
    
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
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
    
    postCell.postTitleLabel.text = postAtIndex.title;

    postCell.avatarImageView.frame = CGRectMake(0,0,70,70);
    [postCell.avatarImageView setImage:postAtIndex.avatarImage];

    postCell.textView.text = postAtIndex.shortDescription;
    
    CGRect frame = postCell.textView.frame;
    frame.size.height = postCell.textView.contentSize.height;
    postCell.textView.frame = frame;
    //postCell.textView.backgroundColor = [UIColor redColor];

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
    DiaryPost *diaryPost = [self.dataController.diaryPostList objectAtIndex:[indexPath row]];
    NSString *text = diaryPost.shortDescription;
    CGSize constraint = CGSizeMake(320 - (15 * 2), 350);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat height = MAX(size.height, 20);
    
    return height + 130;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"showDiaryPostDetails" sender:self];
}

-(void)reload{
    [self.tableView reloadData];
    [self.loadingView
     performSelector:@selector(removeView)
     withObject:nil];

}
- (void)refresh {

    DiaryPostDataController *aDataController = [[DiaryPostDataController alloc] init];
    aDataController.delegate = self;
    self.dataController = aDataController;
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}
@end
