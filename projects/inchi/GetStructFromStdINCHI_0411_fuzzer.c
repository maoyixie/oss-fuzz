#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "inchi_api.h"

// Define the maximum value for size_t. We return if the fuzzing input is equal
// to kSizeMax because appending the null-terminator to the InChI buffer would
// cause wraparound, thereby initializing the buffer to size 0.
static const size_t kSizeMax = (size_t)-1;

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{

    if (size == kSizeMax)
        return 0;

    char *szINCHISource = malloc(sizeof(char) * (size + 1));
    memcpy(szINCHISource, data, size);
    szINCHISource[size] = '\0'; // InChI string must be null-terminated

    // Buffer lengths taken from InChI API reference, located at
    // https://www.inchi-trust.org/download/104/InChI_API_Reference.pdf, page 24
    char szINCHIKey[28], szXtra1[65], szXtra2[65];
    GetINCHIKeyFromINCHI(szINCHISource, 0, 0, szINCHIKey, szXtra1, szXtra2);

    inchi_InputINCHI inpInChI;
    inpInChI.szInChI = szINCHISource;
    inpInChI.szOptions = NULL;

    inchi_Output out;
    GetINCHIfromINCHI(&inpInChI, &out);

    inchi_OutputStruct outStruct;
    GetStructFromStdINCHI(&inpInChI, &outStruct);

    free(szINCHISource);
    FreeINCHI(&out);
    FreeStructFromINCHI(&outStruct);

    return 0;
}