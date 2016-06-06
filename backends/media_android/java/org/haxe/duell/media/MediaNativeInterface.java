package org.haxe.duell.media;

public class MediaNativeInterface
{
    public static native void loadPngWithStaticArguments();
    public static native void loadJpgWithStaticArguments();
    public static native void loadWebPWithStaticArguments();

    public static native void finishAsyncLoading();
}
