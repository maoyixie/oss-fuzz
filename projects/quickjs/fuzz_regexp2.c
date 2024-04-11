#include "libregexp.h"
#include "quickjs.h"
#include "quickjs-libc.h"

#include <stdint.h>
#include <stdio.h>

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    // Variables for the lre_compile function
    int plen;
    char error_msg[256];
    int error_msg_size = sizeof(error_msg);
    int re_flags = 0;
    void *opaque = NULL;

    // Ensure that the input data is a valid string
    if (Size == 0 || Data[Size - 1] != '\0')
    {
        return 0;
    }

    // Call lre_compile with the given data and size
    uint8_t *compiled = lre_compile(&plen, error_msg, error_msg_size, (const char *)Data, Size, re_flags, opaque);

    // Check if lre_compile succeeded
    if (compiled != NULL)
    {
        // Perform any required operations on the compiled regexp, if needed
        // ...

        // Free the memory allocated by lre_compile
        free(compiled);
    }

    return 0;
}