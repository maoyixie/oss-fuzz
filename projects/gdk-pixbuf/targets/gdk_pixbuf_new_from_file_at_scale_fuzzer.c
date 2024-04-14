#include <stdint.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    if (Size == 0)
    {
        return 0;
    }

    // Create a temporary file
    char temp_filename[] = "/tmp/gdkfuzzer-XXXXXX";
    int fd = mkstemp(temp_filename);
    if (fd == -1)
    {
        perror("mkstemp");
        return 0;
    }

    // Write the input data to the temporary file
    ssize_t bytes_written = write(fd, Data, Size);
    close(fd);
    if (bytes_written != (ssize_t)Size)
    {
        perror("write");
        unlink(temp_filename);
        return 0;
    }

    // Set up the environment for fuzzing
    g_autoptr(GError) error = NULL;

    // Call the target function
    GdkPixbuf *pixbuf = gdk_pixbuf_new_from_file_at_scale(temp_filename, 100, 100, TRUE, &error);

    // Clean up
    if (pixbuf != NULL)
    {
        g_object_unref(pixbuf);
    }
    if (error != NULL)
    {
        g_error_free(error);
    }

    // Remove the temporary file
    unlink(temp_filename);

    return 0;
}