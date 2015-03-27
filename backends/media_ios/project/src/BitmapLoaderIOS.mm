/*
 * Copyright (c) 2003-2015 GameDuell GmbH, All Rights Reserved
 * This document is strictly confidential and sole property of GameDuell GmbH, Berlin, Germany
 */

#import "BitmapLoaderIOS.h"

static NSURL* hxstring_to_nsurl(value str)
{
	return [NSURL URLWithString:[NSString stringWithUTF8String:val_string(str)]];
}

@interface BitmapLoaderIOS ()
{
}

@end

@implementation BitmapLoaderIOS

+ (value) loadBitmap:(value)fileUrl outData:(NativeData*)outData
{
    _hasAlpha = false;
    _hasPremultipliedAlpha = false;
    _width = 0;
    _height = 0;
    _pixelFormat = 0;

    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    NSURL* url = hxstring_to_nsurl(fileUrl);
    UIImage *uiImage = [[UIImage alloc] initWithContentsOfFile:[url path]];

    if (!uiImage)
    {
       NSLog(@"BitmapLoaderIOS: The supplied UIImage was null.");
       [uiImage release];
       [pool drain];
       return alloc_bool(false);
    }

    // Get Core Graphics image reference

    CGImageRef image = uiImage.CGImage;

    _width = CGImageGetWidth(image);
    _height = CGImageGetHeight(image);

    // Check to see if the image contains alpha information by reading the alpha info from the image
    // supplied.  Set hasAlpha accordingly

    CGImageAlphaInfo info = CGImageGetAlphaInfo(image);

    _hasAlpha = ((info == kCGImageAlphaPremultipliedLast) ||
                 (info == kCGImageAlphaPremultipliedFirst) ||
                 (info == kCGImageAlphaLast) ||
                 (info == kCGImageAlphaFirst) ? YES : NO);


    _hasPremultipliedAlpha = ((info == kCGImageAlphaPremultipliedLast) ||
                              (info == kCGImageAlphaPremultipliedFirst) ? YES : NO);

    // Check to see what pixel format the image is using

    if(CGImageGetColorSpace(image))
    {
        if(_hasAlpha)
            _pixelFormat = 0; // RGBA8888;
        else
            _pixelFormat = 1; // RGB565;
    }
    else
    {  //NOTE: No colorspace means a mask image
        _pixelFormat = 2; // A8;
    }

    // Based on the pixel format we have read in from the image we are processing, allocate memory to hold
    // an image the size of the newly calculated power of 2 width and height.  Also create a bitmap context
    // using that allocated memory of the same size into which the image will be rendered

    CGColorSpaceRef colorSpace;
    CGContextRef context = nil;
    GLvoid* data = nil;
    int byteCount = 0;

    switch(_pixelFormat)
    {
        case 0: // RGBA8888
            colorSpace = CGColorSpaceCreateDeviceRGB();
            byteCount = _width * _height * 4;
            data = malloc(byteCount);
            context = CGBitmapContextCreate(data,
                                            _width,
                                            _height,
                                            8,
                                            4 * _width,
                                            colorSpace,
                                            kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);

            CGColorSpaceRelease(colorSpace);
            break;

        case 1: // RGB565
            colorSpace = CGColorSpaceCreateDeviceRGB();
            byteCount = _width * _height * 4;
            data = malloc(byteCount);
            context = CGBitmapContextCreate(data,
                                            _width,
                                            _height,
                                            8,
                                            4 * _width,
                                            colorSpace,
                                            kCGImageAlphaNoneSkipFirst | kCGBitmapByteOrder32Little);
            CGColorSpaceRelease(colorSpace);
            break;

        case 2: // A8
            byteCount = _width * _height;
            data = malloc(byteCount);
            context = CGBitmapContextCreate(data,
                                            _width,
                                            _height,
                                            8,
                                            _width,
                                            NULL,
                                            kCGImageAlphaOnly | kCGBitmapAlphaInfoMask);
            break;
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid pixel format"];
    }

    // Now we have the pixelformat info we need we clear the context we have just created and into which the
    // image will be rendered

    CGContextClearRect(context, CGRectMake(0, 0, _width, _height));

    // Now we are done with the setup, we can render the image which was passed in into the new context
    // we have created.  It will then be the data from this context which will be used to create
    // the OpenGL texture.

    CGContextDrawImage(context, CGRectMake(0, 0, _width, _height), image);

    // If the pixel format is RGB565 then sort out the image data.

    if(_pixelFormat == 1)
    {
        byteCount = _width * _height * 2;
        void* tempData = malloc(_width * _height * 2);
        unsigned int *inPixel32 = (unsigned int*)data;
        unsigned short *outPixel16 = (unsigned short*)tempData;
        for(unsigned int i = 0; i < _width * _height; ++i, ++inPixel32)
            *outPixel16++ = (unsigned short)(((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) |
                                            ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) |
                                            ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0));
        free(data);
        data = tempData;
    }

    CGContextRelease(context);

    outData->setupWithExistingPointer((uint8_t*)data, byteCount);

    [uiImage release];
    [pool drain];

    return alloc_bool(true);
}

+ (value) getWidth
{
    return alloc_int(_width);
}

+ (value) getHeight
{
    return alloc_int(_height);
}

+ (value) hasAlpha
{
    return alloc_bool(_hasAlpha);
}

+ (value) hasPremultipliedAlpha
{
    return alloc_bool(_hasPremultipliedAlpha);
}

+ (value) getPixelFormat
{
    return alloc_int(_pixelFormat);
}

@end
