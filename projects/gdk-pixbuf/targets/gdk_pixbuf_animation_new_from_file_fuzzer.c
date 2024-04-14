#include <stdint.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    if (Size == 0)
    {
        return 0;
    }

    char *filename;
    GError *error = NULL;

    // Create a temporary file with the input data
    int fd = mkstemp("fuzz-input-XXXXXX");
    if (fd < 0)
    {
        return 0;
    }

    // Write the data to the temporary file
    ssize_t written = write(fd, Data, Size);
    if (written != Size)
    {
        close(fd);
        unlink("fuzz-input-XXXXXX");
        return 0;
    }

    // Get the filename of the temporary file
    filename = malloc(18);
    snprintf(filename, 18, "fuzz-input-XXXXXX");

    // Call the function to be fuzzed
    GdkPixbufAnimation *animation = gdk_pixbuf_animation_new_from_file(filename, &error);

    // Cleanup
    if (animation)
    {
        g_object_unref(animation);
    }

    if (error)
    {
        g_error_free(error);
    }

    close(fd);
    unlink(filename);
    free(filename);

    return 0;
}