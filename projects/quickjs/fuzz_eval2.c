#include "quickjs.h"
#include "quickjs-libc.h"

#include <stdint.h>
#include <stdio.h>
#include <string.h>

// extern JSValue JS_Eval(JSContext *ctx, const char *input, size_t input_len, const char *filename, int eval_flags);

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    if (Size == 0)
        return 0;

    // Initialize the JS runtime and context
    JSRuntime *rt = JS_NewRuntime();
    if (!rt)
        return 1;

    JSContext *ctx = JS_NewContext(rt);
    if (!ctx)
    {
        JS_FreeRuntime(rt);
        return 1;
    }

    // Null-terminate the input data
    char *input = (char *)malloc(Size + 1);
    if (!input)
    {
        JS_FreeContext(ctx);
        JS_FreeRuntime(rt);
        return 1;
    }
    memcpy(input, Data, Size);
    input[Size] = '\0';

    // Call the JS_Eval function with the fuzzed input
    JSValue result = JS_Eval(ctx, input, Size, "<fuzz>", JS_EVAL_TYPE_GLOBAL);

    // Handle possible exceptions
    if (JS_IsException(result))
    {
        JSValue exception = JS_GetException(ctx);
        // You may print the exception message or handle it in any other desired way
    }

    // Free resources
    JS_FreeValue(ctx, result);
    free(input);
    JS_FreeContext(ctx);
    JS_FreeRuntime(rt);

    return 0;
}