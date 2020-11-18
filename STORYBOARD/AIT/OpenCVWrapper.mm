//
//  OpenCVWrapper.m
//  AIT
//
//  Created by Kevin Radtke on 18/11/20.
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapper.h"
#import <opencv2/imgcodecs/ios.h>
#import <UIKit/UIKit.h>

@implementation OpenCVWrapper

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

+ (UIImage *)convertToGrayscale:(UIImage *)image {
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat gray;
    cv::cvtColor(mat, gray, CV_RGB2GRAY);
    UIImage *grayscale = MatToUIImage(gray);
    return grayscale;
}

+ (UIImage *)detectEdgesInRGBImage:(UIImage *)image {
    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat gray;
    cv::cvtColor(mat, gray, CV_RGB2GRAY);
//    cv::Laplacian(gray, gray, gray.depth());
    cv::Sobel(gray, gray, gray.depth(), 1, 0);
    UIImage *grayscale = MatToUIImage(gray);
    return grayscale;
}

+ (BOOL)isBlurry:(UIImage *)image {

    cv::Mat mat;
    UIImageToMat(image, mat);
    cv::Mat gray;
    cv::cvtColor(mat, gray, CV_RGB2GRAY);
    
    cv::Mat dst2;
    UIImageToMat(image, dst2);
    cv::Mat laplacianImage;
    dst2.convertTo(laplacianImage, CV_8UC1);

    // applying Laplacian operator to the image
    cv::Laplacian(gray, laplacianImage, CV_8U);
    cv::Mat laplacianImage8bit;
    laplacianImage.convertTo(laplacianImage8bit, CV_8UC1);

    unsigned char *pixels = laplacianImage8bit.data;

    // 16777216 = 256*256*256
    int maxLap = -16777216;
    for (int i = 0; i < ( laplacianImage8bit.elemSize()*laplacianImage8bit.total()); i++) {
        if (pixels[i] > maxLap) {
            maxLap = pixels[i];
        }
    }
    
    std::cout << "sharpness: " << maxLap << std::endl;
    
    return (maxLap < 140);
}

@end
