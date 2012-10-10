//
//  DiaryImageCache.h
//  DiaryAgent
//
//  Created by Midori on 10/10/12.
//
//

#import <Foundation/Foundation.h>

@interface DiaryImageCache : NSObject

+ (DiaryImageCache *)sharedImageCache;
- (UIImage *)getImageDataForPath:(NSString *)path;
- (void)saveImage:(UIImage *)image forPath:(NSString *)path;
@end
