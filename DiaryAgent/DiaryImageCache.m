//
//  DiaryImageCache.m
//  DiaryAgent
//
//  Created by Midori on 10/10/12.
//
//

#import "DiaryImageCache.h"
@interface DiaryImageCache(){
    NSMutableDictionary *_imageDictionary;
    NSString *_cacheDictionaryFilePath;
    NSString *_cacheFolderPath;
}

@end

@implementation DiaryImageCache
static DiaryImageCache *sharedImageCache;

+ (DiaryImageCache*)sharedImageCache
{
    if (sharedImageCache == nil) {
        sharedImageCache = [[DiaryImageCache alloc] initWithFile];
    }
    return sharedImageCache;
}

-(id)initWithFile{
    if (self == [super init]){
        [self readHashTableOfStoredImagesFromFile];
    }
    return self;
}

-(void)readHashTableOfStoredImagesFromFile{
    
    //get the documents directory:
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _cacheFolderPath = [NSString stringWithFormat:@"%@/ImageCache",
                                  documentsDirectory];
    
    NSFileManager *fileManager= [NSFileManager defaultManager];
    BOOL isDir;
    if(![fileManager fileExistsAtPath:_cacheFolderPath isDirectory:&isDir]){
        if(![fileManager createDirectoryAtPath:_cacheFolderPath withIntermediateDirectories:YES attributes:nil error:NULL]){
            NSLog(@"Error: Create folder failed %@", _cacheFolderPath);
        }
    }
    
    //make a file name to write the data to using the documents directory:
    _cacheDictionaryFilePath = [NSString stringWithFormat:@"%@/imageCache.plist",_cacheFolderPath];
    _imageDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:_cacheDictionaryFilePath];
    if (!_imageDictionary){
        _imageDictionary = [[NSMutableDictionary alloc] init];
    }
     
}
-(NSString *)createGuid{
        // create a new UUID which you own
        CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
        // create a new CFStringRef (toll-free bridged to NSString)
        // that you own
        NSString *uuidString = (__bridge NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
        
        // release the UUID
        CFRelease(uuid);
        
        return uuidString;
    
}
- (UIImage *)getImageDataForPath:(NSString *)path{
    //return nil;
    NSString *guid = [_imageDictionary objectForKey:path];
    if (guid){
        //make a file name to write the data to using the documents directory:
        NSString *fileName = [NSString stringWithFormat:@"%@/%@",_cacheFolderPath, guid];
        NSLog(@"%@",fileName);
        UIImage *image = [UIImage imageWithContentsOfFile:fileName];
        return image;
    }
    return nil;
}
- (void)saveImage:(UIImage *)image forPath:(NSString *)path{
    NSString *futureImageFileName = [self createGuid];
    [_imageDictionary setObject:futureImageFileName forKey:path];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/%@",_cacheFolderPath, futureImageFileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:fileName atomically:YES];
    
    NSLog(@"%@",_cacheDictionaryFilePath);
    [_imageDictionary writeToFile:_cacheDictionaryFilePath atomically:YES];
}
@end
