package org.haxe.duell.media;

import org.haxe.duell.DuellActivity;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

public final class MediaBitmapLoader {

    private static final ExecutorService EXECUTOR = Executors.newSingleThreadExecutor();

    private static Runnable onFinish = new Runnable() {
        @Override
        public void run() {
            MediaNativeInterface.finishAsyncLoading();
        }
    };

    private MediaBitmapLoader() {}

    public static void loadPngAsync() {
        EXECUTOR.submit(new Runnable() {
            @Override
            public void run() {
                MediaNativeInterface.loadPngWithStaticArguments();
                DuellActivity.getInstance().queueOnHaxeThread(onFinish);
            }
        });
    }

    public static void loadJpgAsync() {
        EXECUTOR.submit(new Runnable() {
            @Override
            public void run() {
                MediaNativeInterface.loadJpgWithStaticArguments();
                DuellActivity.getInstance().queueOnHaxeThread(onFinish);
            }
        });
    }

    public static void loadWebPAsync() {
        EXECUTOR.submit(new Runnable() {
            @Override
            public void run() {
                MediaNativeInterface.loadWebPWithStaticArguments();
                DuellActivity.getInstance().queueOnHaxeThread(onFinish);
            }
        });
    }
}
