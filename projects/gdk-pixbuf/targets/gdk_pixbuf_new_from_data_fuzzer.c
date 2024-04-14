#include <stdint.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    if (Size == 0)
    {
        return 0;
    }

    GdkColorspace colorspace = GDK_COLORSPACE_RGB;
    gboolean has_alpha = Data[0] % 2;
    int bits_per_sample = 8;
    int rowstride;
    int width;
    int height;

    // Calculate width and height based on the input size.
    int area = Size / (has_alpha ? 4 : 3);
    height = sqrt(area);
    width = area / height;

    // Calculate rowstride based on width and the number of channels.
    rowstride = width * (has_alpha ? 4 : 3);

    GdkPixbuf *pixbuf = gdk_pixbuf_new_from_data(Data, colorspace, has_alpha, bits_per_sample, width, height, rowstride, NULL, NULL);

    if (pixbuf)
    {
        g_object_unref(pixbuf);
    }

    return 0;
}