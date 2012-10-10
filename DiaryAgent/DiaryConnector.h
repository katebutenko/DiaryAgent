//
//  DiaryConnector.h
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import <Foundation/Foundation.h>
#import "HTMLNode.h"

@protocol DiaryConnectorDelegate <NSObject>
- (void)dataReceived:(NSString *)html;

@end

@interface DiaryConnector : NSObject

@property (weak, nonatomic) id <DiaryConnectorDelegate> delegate;
- (void)asyncGetHTMLFromURL:(NSString *)URL;
- (NSString *)getEncodedDataForLogin:(NSString *)username password:(NSString *)password;
+ (UIImage *)loadImageForPath:(NSString *)imagePath;
@end


