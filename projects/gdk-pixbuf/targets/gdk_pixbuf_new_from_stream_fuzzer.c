#include <stdint.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    GInputStream *stream;
    GdkPixbuf *pixbuf;
    GError *error = NULL;
    GCancellable *cancellable = g_cancellable_new();
    g_assert(Size > 0); // crash

    // Create a new memory input stream from the provided data
    stream = g_memory_input_stream_new_from_data(Data, Size, NULL);
    if (stream == NULL)
    {
        g_object_unref(cancellable);
        return 0;
    }

    // Call the target function with the memory input stream
    pixbuf = gdk_pixbuf_new_from_stream(stream, cancellable, &error);
    if (pixbuf != NULL)
    {
        // Cleanup the returned pixbuf
        g_object_unref(pixbuf);
    }
    else
    {
        // Cleanup the error if the function failed
        if (error != NULL)
        {
            g_error_free(error);
        }
    }

    // Cleanup the input stream and cancellable
    g_object_unref(stream);
    g_object_unref(cancellable);

    return 0;
}