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

@interface DiaryConnector : NSObject

- (id)initWithViewController:(id)viewController;
- (HTMLNode *)getRawDataFromURL:(NSString *)URL selectorClass:(NSString *)selectorClass;
- (NSString *)getRawDataFromURL:(NSString *)URL selectorId:(NSString *)selectorId;
- (NSMutableArray *)getFavorites:(NSString *)diaryName;
- (void)asyncGetFavorites:(NSString *)diaryName;
- (void)asyncGetPostFromURL:(NSString *)URL;
- (NSString *)getEncodedDataForLogin:(NSString *)username password:(NSString *)password;

@end
