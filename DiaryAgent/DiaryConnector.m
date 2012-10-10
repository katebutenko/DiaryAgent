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
#import "DiaryImageCache.h"

#define add(A,B) [(A) stringByAppendingString:(B)]

@interface DiaryConnector(){
    NSURLConnection* _connection;
}
    @property (nonatomic, copy) NSMutableData *data;
    -(void)handledata;
@end

@implementation DiaryConnector
@synthesize data;

-(NSString *)getEncodedDataForLogin:(NSString *)username password:(NSString *)password {
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.diary.ru/login.php"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"POST"];
    
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSMutableString *credentials = (NSMutableString *)@"user_login=";
    credentials = (NSMutableString *)add(credentials,username);
    credentials = (NSMutableString *)add(credentials,@"&user_pass=");
    credentials = (NSMutableString *)add(credentials,password);
    
    NSData *dataSet = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:dataSet];
    
    
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

- (void)asyncGetHTMLFromURL:(NSString *)URL {
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:URL]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [request setHTTPMethod: @"GET"];
    NSString *savedCredentials = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"loginData"];
    
    [request addValue:savedCredentials forHTTPHeaderField:@"Cookie"];
    
    _connection = [[NSURLConnection alloc] initWithRequest:request  delegate:self startImmediately:YES];
    
}

-(void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    data = [[NSMutableData alloc] init]; // _data being an ivar
}
-(void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)receivedData {
    [data appendData:receivedData];
}
-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error {
    // Handle the error properly
}
-(void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSString *html = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSWindowsCP1251StringEncoding];
    //[self writeToTextFile:html]; //do not use it now, but possibly later it will be needed
    [self.delegate dataReceived:html];
}

+ (UIImage *)loadImageForPath:(NSString *)imagePath{
    //look in the file for stored image, if not found load from web
    UIImage *image = [[DiaryImageCache sharedImageCache] getImageDataForPath:imagePath];
    if (!image){
        NSURL *imageURL = [NSURL URLWithString:imagePath];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        image = [UIImage imageWithData:imageData];
        [[DiaryImageCache sharedImageCache] saveImage:image forPath:imagePath];
    }
    return image;
}

//currently not used
-(void) writeToTextFile:(NSString *)html{
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/favoritesFile1.txt",
                          documentsDirectory];
    NSLog(@"Filename: %@", fileName);
    //save content to the documents directory
    [html writeToFile:fileName atomically:NO encoding:NSWindowsCP1251StringEncoding error:nil];
    
}



@end
