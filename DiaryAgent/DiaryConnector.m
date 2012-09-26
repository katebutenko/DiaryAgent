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
@interface DiaryConnector()
@property (nonatomic, copy) NSMutableData *data;
@property (nonatomic, weak) UIView *loadingView;
@property (nonatomic, weak) id viewController;
-(void)handledata;
@end
@implementation DiaryConnector
@synthesize data;
@synthesize loadingView = _loadingView;
@synthesize viewController = _viewController;

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
    NSString *savedCredentials = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"loginData"];
    
    [request addValue:savedCredentials forHTTPHeaderField:@"Cookie"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response bytes] length:[response length] encoding:NSWindowsCP1251StringEncoding];
    
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
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:add(diaryName,@".diary.ru/?favorite")] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    
    [request setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];

    NSString *savedCredentials = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"loginData"];
    
    [request addValue:savedCredentials forHTTPHeaderField:@"Cookie"];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response bytes] length:[response length] encoding:NSWindowsCP1251StringEncoding];
    NSLog(@"html: %@", html);
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
        //short description
        
        NSString *postDescription = [[singlePost findChildOfClass:@"paragraph"] allContents] ;
        NSLog(@"Text: %@",postDescription);
        NSString *trimmedString = [postDescription stringByTrimmingCharactersInSet:
                                   [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSLog(@"Text: %@",trimmedString);
       
        if ([trimmedString length]>350){
            trimmedString = [trimmedString substringToIndex:350];
        }
        
        DiaryPost *diaryPost = [[DiaryPost alloc] initWithName:postTitle username:userName shortDescription:trimmedString avatar:avatar userLink:userLink postLink:postLink];
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
    NSString *savedCredentials = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"loginData"];
    
    [request addValue:savedCredentials forHTTPHeaderField:@"Cookie"];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    NSString *html = [[NSString alloc] initWithBytes: [response bytes] length:[response length] encoding:NSWindowsCP1251StringEncoding];
    
    
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

-(NSString *)getEncodedDataForLogin:(NSString *)username password:(NSString *)password{
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.diary.ru/login.php"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *credentials = (NSMutableString *)@"user_login=";
    credentials = (NSMutableString *)add(credentials,username);
    credentials = (NSMutableString *)add(credentials,@"&user_pass=");
    credentials = (NSMutableString *)add(credentials,password);
    
    NSData *data = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&requestError];
    
NSDictionary* headers = [(NSHTTPURLResponse *)urlResponse allHeaderFields];
    
    NSString *specificCookie = [headers objectForKey:@"Set-Cookie"];
    
    NSRegularExpression* regexToUse = [[NSRegularExpression alloc]
                                       initWithPattern:@"user_[^\\s]+;"
                                       options:NSRegularExpressionCaseInsensitive
                                       error:nil];
    NSArray* foundInText = [regexToUse matchesInString:specificCookie options:0 range:NSMakeRange(0, [specificCookie length])];
    
    NSMutableString* encryptedLoginData = (NSMutableString *)@"";
    
    for (NSTextCheckingResult* searchResult in foundInText)
    {
        NSString* textResult = [specificCookie substringWithRange:searchResult.range];
        NSLog(@"Result: %@", textResult);
        encryptedLoginData = (NSMutableString *)add(encryptedLoginData,@" ");
        encryptedLoginData = (NSMutableString *)add(encryptedLoginData,textResult);
        NSLog(@"EncryptedLoginData: %@", encryptedLoginData);
        
    }
    NSLog(@"EncryptedLoginData: %@", encryptedLoginData);
    return encryptedLoginData;
    
  
}

-(id)initWithLoadingView:(UIView *)loadingView viewController:(id)viewController{
    self = [super init];
    
    if (self) {
        _loadingView = loadingView;
        _viewController = viewController;
        return self;
    }
    return nil;
}

-(void)asyncTest{
     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://khkh.diary.ru"]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request  delegate:self startImmediately:YES]; // release later

}
- (void)asyncGetPostFromURL:(NSString *)URL{
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSString *savedCredentials = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"loginData"];
    
    [request addValue:savedCredentials forHTTPHeaderField:@"Cookie"];
    
     NSURLConnection* connection = [[NSURLConnection alloc] initWithRequest:request  delegate:self startImmediately:YES];    
    
}


-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    data = [[NSMutableData alloc] init]; // _data being an ivar
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)receiveddata
{
    [data appendData:receiveddata];
     //NSString *html = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSWindowsCP1251StringEncoding];
    //NSLog(@"data %@",html);
}
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    // Handle the error properly
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [self handledata]; // Deal with the data
}
-(void)handledata{

    NSString *html = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSWindowsCP1251StringEncoding];
    
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    HTMLNode *bodyNode = [parser body];
    HTMLNode *postNode = [bodyNode findChildWithAttribute:@"class" matchingName:@"singlePost  count" allowPartial:TRUE];
    
    HTMLNode *postContentNode = [postNode findChildOfClass:@"paragraph"];
    
    [self.viewController setText:[postContentNode rawContents] ];

    [self.loadingView
     performSelector:@selector(removeView)
     withObject:nil];
}

@end
