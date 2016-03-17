#include <stdbool.h>
#define WEBP_FORCE_ALIGNED

#include "webpi/webp/decode.h"
#include <stdlib.h>

#include<emscripten.h>

static bool _hasAlpha;
static bool _hasPremultipliedAlpha;
static unsigned int _pixelFormat; // 0 = RGBA8888, 1 = RGB565, 2 = A8
static const char* _errorMessage;
static int _width;
static int _height;

static WebPBitstreamFeatures _features;

//static value media_cpp_loadBitmapFromWebP (value imageData, value nativeData, value flipRGB)

EMSCRIPTEN_KEEPALIVE
int initializeWebPDecoding (unsigned char *buf, int length)
{
    VP8StatusCode featuresResult = WebPGetFeatures((uint8_t*)buf, length, &_features);

    if (featuresResult != VP8_STATUS_OK)
    {
        //_errorMessage = "error: bad feature result";
        return 1;
    }

    if (_features.has_alpha)
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

    _width = _features.width;
    _height = _features.height;

    return 0;
}

EMSCRIPTEN_KEEPALIVE
int getFeaturesWidth ()
{
    return _width;
}

EMSCRIPTEN_KEEPALIVE
int getFeaturesHeight ()
{
    return _height;
}

EMSCRIPTEN_KEEPALIVE
unsigned int* decodeWebP (unsigned char *buf, int length)
{
    int width, height;
    int byteCount = 0;
    unsigned char* webp = buf;
    size_t webpsize = length;
    bool flip = false;

    byteCount = _width * _height * 4;


    unsigned char* image = WebPDecodeRGBA((uint8_t*)webp, webpsize, &width, &height);

    if (width != _width || height != _height)
    {
        //_errorMessage = "Invalid image features!";
        return 0;
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
    if (flip && (_pixelFormat == 1 || _pixelFormat == 0))
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
/*
    // Convert to RGB565
    if(_pixelFormat == 1)
    {
        byteCount = _width * _height * 2;
        void* tempData = (void*)malloc(byteCount);
        unsigned int *inPixel32 = (unsigned int*)image;
        unsigned short *outPixel16 = (unsigned short*)tempData;
        for(unsigned int i = 0; i != _width * _height; ++i, ++inPixel32)
            *outPixel16++ = (unsigned short)(((((*inPixel32 >> 0) & 0xFF) >> 3) << 11) |
                                            ((((*inPixel32 >> 8) & 0xFF) >> 2) << 5) |
                                            ((((*inPixel32 >> 16) & 0xFF) >> 3) << 0));
        free(image);
        image = (unsigned char*)tempData;
    }
    */


    return image;
    /*
    NativeData* ptrIn = ((NativeData*)val_data(imageData));
    NativeData* ptrOut = ((NativeData*)val_data(nativeData));
    bool flip = val_bool(flipRGB);

    WebPBitstreamFeatures features;
    int width, height;
    int byteCount = 0;
    unsigned char* webp = ptrIn->ptr;

    size_t webpsize = ptrIn->allocedLength;

    VP8StatusCode featuresResult = WebPGetFeatures((uint8_t*)webp, webpsize, &features);

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
    if (flip && (_pixelFormat == 1 || _pixelFormat == 0))
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

    ptrOut->ptr = (uint8_t*)image;
    ptrOut->allocedLength = byteCount;
    ptrOut->offsetLength = byteCount;

    return alloc_bool(true);
    */
}

/*
int  // Specifies that type of variable the function returns.
     // main() must return an integer
main ( int argc, char **argv ) {
        int width, height;
        int byteCount = 0;
        size_t webpsize;
        bool flip = true;

        FILE *fp;

        fp = fopen("2.webp","rb");  // r for read, b for binary

                fseek(fp, 0L, SEEK_END);
                webpsize = ftell(fp);
                fseek(fp, 0L, SEEK_SET);

        unsigned char * webp = (unsigned char*)malloc(webpsize);
        fread(webp,webpsize,1,fp);

        unsigned char* image = WebPDecodeRGBA((uint8_t*)webp, webpsize, &width, &height);



        printf("ASDASDASDA\n");
        int base = 4 * 80123;
        printf("%d\n", image[base]);
        printf("%d\n", image[base + 1] );
        printf("%d\n", image[base + 2] );
        printf("%d\n", image[base + 3] );
     // code
     return 0; // Indicates that everything went well.
}*/
