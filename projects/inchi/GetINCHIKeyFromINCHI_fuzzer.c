#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "inchi_api.h"

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    if (Size < 1)
    {
        return 0;
    }

    const char *szINCHISource = (const char *)Data;
    int xtra1 = Data[0] % 2;
    int xtra2 = Data[Size - 1] % 2;

    char szINCHIKey[27];
    char szXtra1[65];
    char szXtra2[65];

    GetINCHIKeyFromINCHI(szINCHISource, xtra1, xtra2, szINCHIKey, szXtra1, szXtra2); // bug: heap-buffer-overflow

    return 0;
}