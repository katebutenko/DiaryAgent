//
//  NewTableCell.m
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import "NewTableCell.h"

@implementation NewTableCell

@synthesize userNameLabel = _userNameLabel;
@synthesize postTitleLabel = _postTitleLabel;
@synthesize avatarImageView = _avatarImageView;
@synthesize descriptionLabel = _descriptionLabel, label=_label, textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
