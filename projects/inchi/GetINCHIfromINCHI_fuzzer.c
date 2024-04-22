#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "inchi_api.h"

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    inchi_InputINCHI inpInChI;
    inchi_Output out;
    char *inchiString = NULL;

    if (Size == 0 || Data == NULL)
    {
        return 0;
    }

    // Allocate memory for the InChI string
    inchiString = (char *)malloc(Size + 1);
    if (inchiString == NULL)
    {
        return 0;
    }

    // Copy the input data to the InChI string and null-terminate it
    memcpy(inchiString, Data, Size);
    inchiString[Size] = '\0';

    // Set the input InChI string
    inpInChI.szInChI = inchiString;

    // Call the target function
    int result = GetINCHIfromINCHI(&inpInChI, &out); // bug: leak

    // Free allocated resources
    if (out.szInChI)
        FreeINCHI(&out);
    free(inchiString);

    return 0;
}