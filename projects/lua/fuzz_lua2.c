#include "lprefix.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#include <signal.h>

#include "lua.h"

#include "lauxlib.h"
#include "lualib.h"

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    lua_State *L = luaL_newstate(); // create a new Lua state
    if (L == NULL)
    {
        return 0; // if creating the state fails, return 0
    }

    luaL_openlibs(L); // open the standard Lua libraries

    // create a null-terminated string from the input data
    char *buffer = malloc(Size + 1);
    if (buffer == NULL)
    {
        lua_close(L);
        return 0;
    }

    memcpy(buffer, Data, Size);
    buffer[Size] = '\0';

    // call the function to be fuzzed
    int result = luaL_loadbufferx(L, buffer, Size, "fuzzed_script", NULL);

    // clean up resources
    free(buffer);
    lua_close(L);

    // if luaL_loadbufferx succeeded, execute the loaded chunk
    if (result == 0)
    {
        lua_pcall(L, 0, LUA_MULTRET, 0);
    }

    return 0;
}