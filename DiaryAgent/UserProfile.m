//
//  UserProfile.m
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import "UserProfile.h"
#import "DiaryConnector.h"
#import "HTMLNode.h"

#define add(A,B) [(A) stringByAppendingString:(B)]

@implementation UserProfile

@synthesize username = _username, avatarImage = _avatarImage, rawProfileData = _rawProfileData;

-(id)initWithID:(NSString *)userLink{
    self = [super init];
    
    if (self) {
        DiaryConnector *diaryConnector = [[DiaryConnector alloc] init];
        diaryConnector.delegate = self;
        [diaryConnector asyncGetHTMLFromURL:userLink];

        _rawProfileData = @"test";
        _username = nil;
        
        //assign and store an avatarImage
       // NSURL *imageURL = [NSURL URLWithString:avatarURL];
        //NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        //_avatarImage = [UIImage imageWithData:imageData];
        _avatarImage = nil;
        
        return self;
    }
    
    return nil;

}

-(void)dataReceived:(NSString *)html{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *mynode = [bodyNode findChildWithAttribute:@"id" matchingName:@"contant" allowPartial:FALSE];
    NSString *rawContents = [[mynode rawContents] copy];
    NSLog(@"text %@",rawContents);
    
    self.rawProfileData = rawContents;
    [self.delegate userProfileDidFinishLoad];
}


@end
