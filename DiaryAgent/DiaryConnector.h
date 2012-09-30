//
//  DiaryConnector.h
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"
#import "DiaryPost.h"

@protocol DiaryConnectorDelegate;

@interface DiaryConnector : NSObject

@property (weak, nonatomic) id <DiaryConnectorDelegate> delegate;

- (void)asyncGetHTMLFromURL:(NSString *)URL;
- (NSString *)getEncodedDataForLogin:(NSString *)username password:(NSString *)password;


@end

@protocol DiaryConnectorDelegate <NSObject>
- (void)dataReceived:(NSString *)html;

@end
