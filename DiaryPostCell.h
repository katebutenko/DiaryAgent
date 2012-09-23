//
//  DiaryPostCell.h
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import <UIKit/UIKit.h>

@interface DiaryPostCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;


@end
