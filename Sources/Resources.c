#ifdef __APPLE__
#include <CoreFoundation/CoreFoundation.h>

int getResource(const char* filename, const char* extension, char* buffer, int bufferSize)
{
    __auto_type mainBundle = CFBundleGetMainBundle();
    __auto_type URL = CFBundleCopyResourceURL(mainBundle, CFStringCreateWithCString(NULL, filename, kCFStringEncodingMacRoman), CFStringCreateWithCString(NULL, extension, kCFStringEncodingMacRoman), NULL);
    __auto_type path = CFURLCopyPath(URL);
    if (CFStringGetCString(path, buffer, bufferSize, kCFStringEncodingMacRoman))
        return 0;
    return -1;
}
#endif
