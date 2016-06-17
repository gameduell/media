/*
 * Copyright (c) 2003-2016, GameDuell GmbH
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * 1. Redistributions of source code must retain the above copyright notice,
 * this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "BitmapLoaderIOS.h"

@interface BitmapLoaderIOS ()
{
}

@end

@implementation BitmapLoaderIOS

+ (value) loadBitmap:(NativeData*)imageData outData:(NativeData*)outData flipRGB:(BOOL)flipRGB
{
    _hasAlpha = false;
    _hasPremultipliedAlpha = false;
    _width = 0;
    _height = 0;
    _pixelFormat = 0;

    NSData *uiImageData = [[NSData alloc] initWithBytesNoCopy:imageData->ptr length: imageData->allocedLength freeWhenDone: NO];
    UIImage *uiImage = [[UIImage alloc] initWithData:uiImageData];

    if (!uiImage)
    {
       _errorMessage = "BitmapLoaderIOS: The supplied UIImage was null.";
       uiImage = nil;
       uiImageData = nil;
       return alloc_bool(false);
    }
    else
    {
        _errorMessage = "No error";
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
                 (info == kCGImageAlphaFirst) ? true : false);

    _hasPremultipliedAlpha = true;

    // Check to see what pixel format the image is using

    if(CGImageGetColorSpace(image))
    {
        //TODO We use RGBA8888 for the all color images until we make support for RGB888 as there is no performance loss at all, just small memory impact.
        if(true || _hasAlpha)
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

    if (flipRGB)
    {
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
    }
    else
    {
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
                                                kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);

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
                                                kCGImageAlphaNoneSkipLast | kCGBitmapByteOrder32Big);
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

    outData->ptr = (uint8_t*)data;
    outData->allocedLength = byteCount;
    outData->offsetLength = byteCount;

    uiImage = nil;
    uiImageData = nil;

    return alloc_bool(true);
}

+ (value) loadWebPBitmap:(NativeData*)imageData outData:(NativeData*)outData flipRGB:(BOOL)flipRGB;
{
    _hasAlpha = false;
    _hasPremultipliedAlpha = false;
    _width = 0;
    _height = 0;
    _pixelFormat = 0;
    
    WebPBitstreamFeatures features;
    int width, height;
    int byteCount = 0;
    unsigned char* webp = imageData->ptr;

    size_t webpsize = imageData->allocedLength;
    
    VP8StatusCode featuresResult = WebPGetFeatures((uint8_t*)webp, webpsize, &features);

    NSLog(@"Test!");
    
    if (featuresResult != VP8_STATUS_OK)
    {
        _errorMessage = "error: bad feature result";
        return alloc_bool(false);
    }
    else
    {
        _errorMessage = "noerror";
    }

    if (features.has_alpha)
    {
        _hasAlpha = true;
        _hasPremultipliedAlpha = true;
        _pixelFormat = 0;
    }
    else
    {
        _hasAlpha = false;
        _hasPremultipliedAlpha = false;
        _pixelFormat = 1;
    }

    _width = features.width;
    _height = features.height;
    byteCount = _width * _height * 4;

    unsigned char* image = WebPDecodeRGBA((uint8_t*)webp, webpsize, &width, &height);

    if (width != _width || height != _height)
    {
        _errorMessage = "Invalid image features!";
        return alloc_bool(false);
    }

    // Premultiply alpha
    if (_hasAlpha)
    {
        unsigned char stride = 4;
        float r,g,b, aFraction;

        for(unsigned int i = 0; i != _width * _height; ++i)
        {
            aFraction = (float)image[i * stride + 3] / 255.0f;
            b = (float)image[i * stride + 2];
            g = (float)image[i * stride + 1];
            r = (float)image[i * stride + 0];

            image[i * stride + 0] = (unsigned char)(r * aFraction);
            image[i * stride + 1] = (unsigned char)(g * aFraction);
            image[i * stride + 2] = (unsigned char)(b * aFraction);
        }
    }

    // Flip RGB
    if (flipRGB && (_pixelFormat == 1 || _pixelFormat == 0))
    {
        unsigned char stride = 4;
        unsigned char r,b;

        for(unsigned int i = 0; i != _width * _height; ++i)
        {
            r = image[i * stride + 0];
            b = image[i * stride + 2];
            image[i * stride + 0] = b;
            image[i * stride + 2] = r;
        }
    }

    // Convert to RGB565
    if(_pixelFormat == 1)
    {
        byteCount = _width * _height * 2;
        void* tempData = malloc(byteCount);
        unsigned int *inPixel32 = (unsigned int*)image;
        unsigned short *outPixel16 = (unsigned short*)tempData;
        for(unsigned int i = 0; i != _width * _height; ++i, ++inPixel32)
            *outPixel16++ = (unsigned short)(((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) |
                                            ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) |
                                            ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0));
        free(image);
        image = (unsigned char*)tempData;
    }

    outData->ptr = (uint8_t*)image;
    outData->allocedLength = byteCount;
    outData->offsetLength = byteCount;
    
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

+ (value) getErrorMessage
{
    return alloc_string(_errorMessage);
}

@end
