#import "UIImage+Scale.h"

@implementation UIImage (scale)

-(UIImage*)scaleToSize:(CGSize)size
{
	// Create a bitmap graphics context
	// This will also set it as the current context
	UIGraphicsBeginImageContext(size);
	
	// Draw the scaled image in the current context
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	
	// Create a new image from current context
	UIImage* scaledImage = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage];
	
	// Pop the current context from the stack
	UIGraphicsEndImageContext();
	
	// Return our new scaled image
	return scaledImage;
}

- (UIImage *) resampleWidth:(CGFloat) w {
    CGFloat h = self.size.height * (w / self.size.width);
    return [self scaleToSize:CGSizeMake(w, h)];
}

- (UIImage *) resampleHeight:(CGFloat) h {
    CGFloat w = self.size.width * (h / self.size.height);
    return [self scaleToSize:CGSizeMake(w, h)];
}

- (UIImage *) resampleCropCenter:(CGSize ) size {
    UIImage *img = nil;
    CGFloat fw = self.size.width /size.width;
    CGFloat fh = self.size.height / size.height;
    if (fw > fh) {
        CGFloat w = self.size.width * (size.height / self.size.height);
        img = [self resampleWidth:w];
    } else {
        CGFloat h = self.size.height * (size.width / self.size.width);
        img = [self resampleHeight:h];
    }
    if (img != nil) {
        CGFloat x = (img.size.width - size.width) /2;
        CGFloat y = (img.size.height - size.height) /2;
        return [img cropToRect:CGRectMake(x,y,size.width,size.height)];
    }
    
    return [self scaleToSize:size];
}

- (UIImage*)cropToRect:(CGRect)rect {
	//create a context to do our clipping in
	UIGraphicsBeginImageContext(rect.size);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	
	//create a rect with the size we want to crop the image to
	//the X and Y here are zero so we start at the beginning of our
	//newly created context
	CGRect clippedRect = CGRectMake(0, 0, rect.size.width, rect.size.height);
	CGContextClipToRect( currentContext, clippedRect);
	
	//create a rect equivalent to the full size of the image
	//offset the rect by the X and Y we want to start the crop
	//from in order to cut off anything before them
	CGRect drawRect = CGRectMake(rect.origin.x * -1,
								 rect.origin.y * -1,
								 self.size.width,
								 self.size.height);
	[self drawInRect:drawRect];
	
	
	//pull the image from our cropped context
	UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
	
	//pop the context to get back to the default
	UIGraphicsEndImageContext();
	
	//Note: this is autoreleased
	return cropped;
}

@end
