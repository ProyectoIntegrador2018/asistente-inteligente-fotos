//
//  OpenCVWrapper.h
//  AIT
//
//  Created by Kevin Radtke on 18/11/20.
//

//#import <opencv2/opencv.hpp>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import <opencv2/imgcodecs/ios.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVWrapper : NSObject

+ (NSString *)openCVVersionString;
+ (UIImage *)convertToGrayscale:(UIImage *)image;
+ (UIImage *)detectEdgesInRGBImage:(UIImage *)image;
+ (double)calcSharpness:(UIImage *)image;
//- (cv::Mat)convertUIImageToCVMat:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
