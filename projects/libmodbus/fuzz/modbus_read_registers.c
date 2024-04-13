#include <stdio.h>
#include <errno.h>
#include <stdlib.h>
#include <stdint.h>
#include <unistd.h>
#include <string.h>
#include <stddef.h>
#include <pthread.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/tcp.h>

#include <modbus.h>
#include "unit-test.h"

extern int LLVMFuzzerTestOneInput(const uint8_t *Data, size_t Size)
{
    if (Size < 4)
    {
        return 0;
    }

    modbus_t *ctx = modbus_new_rtu("/dev/ttyUSB0", 9600, 'N', 8, 1);
    if (ctx == NULL)
    {
        return 0;
    }

    int rc;
    uint16_t addr = (Data[0] << 8) | Data[1];
    uint16_t nb = (Data[2] << 8) | Data[3];

    if (nb > MODBUS_MAX_READ_REGISTERS)
    {
        nb = MODBUS_MAX_READ_REGISTERS;
    }

    uint16_t *dest = malloc(nb * sizeof(uint16_t));
    if (dest == NULL)
    {
        modbus_free(ctx);
        return 0;
    }

    rc = modbus_read_registers(ctx, addr, nb, dest);

    if (rc == -1)
    {
        fprintf(stderr, "Error reading registers: %s\n", modbus_strerror(errno));
    }
    else
    {
        for (int i = 0; i < rc; i++)
        {
            printf("reg[%d]=%d (0x%X)\n", i, dest[i], dest[i]);
        }
    }

    free(dest);
    modbus_free(ctx);

    return 0;
}