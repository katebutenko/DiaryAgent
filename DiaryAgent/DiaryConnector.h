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

- (id)initWithLoadingView:(UIView *)loadingView viewController:(id)viewController;
- (HTMLNode *)getRawDataFromURL:(NSString *)URL selectorClass:(NSString *)selectorClass;
- (NSString *)getRawDataFromURL:(NSString *)URL selectorId:(NSString *)selectorId;
- (NSMutableArray *)getFavorites:(NSString *)diaryName;
- (NSString *)getPostFromURL:(NSString *)URL;
- (void)asyncGetPostFromURL:(NSString *)URL;
- (NSString *)getEncodedDataForLogin:(NSString *)username password:(NSString *)password;
-(void)asyncTest;

@end
