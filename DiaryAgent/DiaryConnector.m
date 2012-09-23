//
//  DiaryConnector.m
//  DiaryAgent
//
//  Created by sitecore on 23.09.12.
//
//

#import "DiaryConnector.h"
#import "HTMLParser.h"
#import "HTMLNode.h"
#import "DiaryPost.h"

#define add(A,B) [(A) stringByAppendingString:(B)]

@implementation DiaryConnector

-(HTMLNode *) getRawDataFromURL:(NSString *)URL selectorClass:(NSString *)selectorClass{
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response bytes] length:[response length] encoding:NSWindowsCP1251StringEncoding];
    
    //find a title
    
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
        
    return [bodyNode findChildOfClass:selectorClass];
}

-(NSString *) getRawDataFromURL:(NSString *)URL selectorId:(NSString *)selectorId{
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response bytes] length:[response length] encoding:NSWindowsCP1251StringEncoding];
    
    //find a title
    
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *mynode = [bodyNode findChildWithAttribute:@"id" matchingName:selectorId allowPartial:FALSE];
    
    
    return [mynode rawContents];
}

-(NSMutableArray *) getFavorites:(NSString *)diaryName{
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:add(diaryName,@".diary.ru/?favorite")]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response bytes] length:[response length] encoding:NSWindowsCP1251StringEncoding];
    
    //find a title
    
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
   NSArray *postsArray = [bodyNode findChildrenWithAttribute:@"class" matchingName:@"singlePost  count" allowPartial:TRUE];
    NSMutableArray *diaryPostsArray = [[NSMutableArray alloc] init];
    
    for (HTMLNode *singlePost in postsArray){
        //find name of the posts's author
        HTMLNode *userNameNode = [singlePost findChildOfClass:@"authorName"];
        NSString *userName = [userNameNode allContents];
        NSString *userLink = [[userNameNode findChildTag:@"a"] getAttributeNamed:@"href"];
        
        //find title of the post
        NSString *postTitle = [[[singlePost findChildWithAttribute:@"class" matchingName:@"postTitle" allowPartial:TRUE] findChildTag:@"h2"] allContents];
        //avatar
        NSString *avatar = [[[singlePost findChildOfClass:@"avatar"] findChildTag:@"img"] getAttributeNamed:@"src"];
        
        //link to the post
        NSString *postLink = [[[singlePost findChildOfClass:@"postLinksBackg"] findChildTag:@"a"] getAttributeNamed:@"href"];
        
        DiaryPost *diaryPost = [[DiaryPost alloc] initWithName:postTitle username:userName shortDescription:@"testdescr" avatar:avatar userLink:userLink postLink:postLink];
        [diaryPostsArray addObject:diaryPost];
    }
    
    return diaryPostsArray;

}

- (NSString *)getPostFromURL:(NSString *)URL{
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response bytes] length:[response length] encoding:NSWindowsCP1251StringEncoding];
    
    //find a title
    
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *postNode = [bodyNode findChildWithAttribute:@"class" matchingName:@"singlePost  count" allowPartial:TRUE];
    
    HTMLNode *postContentNode = [postNode findChildOfClass:@"paragraph"];
            
    
    return [postContentNode rawContents];
}

@end
