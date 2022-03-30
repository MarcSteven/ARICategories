//  UIImage+Scale.h
#include <UIKit/UIKit.h>

@interface UIImage (scale)
#pragma mark - UIImage scale method to deal with the related image
- (UIImage*)scaleToSize:(CGSize)size;
- (UIImage*)cropToRect:(CGRect)rect;
- (UIImage *) resampleWidth:(CGFloat) w;
- (UIImage *) resampleHeight:(CGFloat) h;
- (UIImage *) resampleCropCenter:(CGSize ) size;

@end
