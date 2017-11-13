//
//  UIImage+Extra.h
//  Restaurant
//
//  Created by TNM_ios2 on 12/11/13.
//  Copyright (c) 2013 TNM_ios2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (Extended)
- (NSString *)base64String;
- (CGRect)convertCropRect:(CGRect)cropRect;
- (UIImage *)croppedImage:(CGRect)cropRect;
- (UIImage *)resizedImage:(CGSize)size imageOrientation:(UIImageOrientation)imageOrientation;
- (UIImage*)imageWithHeight: (float) i_height;
- (UIImage*)imageWithWidth: (float) i_width;
- (UIImage *)scaleAndRotateWithResolution:(CGFloat)kMaxResolution;
- (UIImage *)scaleAndRotate;
- (UIImage *)RotateFrontWithPicker:(UIImagePickerController *)picker;
- (UIImage *)rotatedImageWithtransform:(CGAffineTransform)rotation
                         croppedToRect:(CGRect)rect;
- (UIImage *)rotatedImageWithtransform:(CGAffineTransform)transform;
+ (UIImage *)imageNamedH568:(NSString *)imageName;
-(UIImage *)cropTransparencyFromImage:(UIImage *)img;
+ (UIImage *)fixrotation:(UIImage *)image;
- (UIImage *)drawImage:(UIImage *)inputImage inRect:(CGRect)frame;

- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
+ (UIImage *)imageWithColor:(UIColor *)color;

@end
