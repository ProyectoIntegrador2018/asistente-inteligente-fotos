//
//  OpenCVWrapper.h
//  AIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString *)openCVVersionString;
+ (UIImage *)convertToGrayscale:(UIImage *)image;
+ (UIImage *)detectEdgesInRGBImage:(UIImage *)image;
+ (BOOL)isBlurry:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
