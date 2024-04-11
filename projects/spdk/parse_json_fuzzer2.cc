#include <stdlib.h>
#include "spdk/json.h"

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    struct spdk_json_val values[256];
    void *end;
    uint32_t flags = 0;

    if (Size < sizeof(uint32_t))
    {
        return 0;
    }

    // Use the first 4 bytes of the input data as flags
    memcpy(&flags, Data, sizeof(uint32_t));
    Data += sizeof(uint32_t);
    Size -= sizeof(uint32_t);

    spdk_json_parse((void *)Data, Size, values, sizeof(values) / sizeof(values[0]), &end, flags);

    return 0;
}