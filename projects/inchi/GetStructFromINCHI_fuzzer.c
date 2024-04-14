#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "inchi_api.h"

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    inchi_InputINCHI inpInChI;
    inchi_OutputStruct outStruct;
    char *inchiString = NULL;

    if (Size == 0)
    {
        return 0;
    }

    // Allocate memory for the InChI string and null-terminate it
    inchiString = (char *)malloc(Size + 1);
    if (inchiString == NULL)
    {
        return 0;
    }

    // Copy the fuzz data into the InChI string
    memcpy(inchiString, Data, Size);
    inchiString[Size] = '\0';

    // Set the InChI string for input
    inpInChI.szInChI = inchiString;

    // Call the target function
    int result = GetStructFromINCHI(&inpInChI, &outStruct);

    // Free allocated memory
    free(inchiString);
    FreeStructFromINCHI(&outStruct);

    // Return the result
    return 0;
}