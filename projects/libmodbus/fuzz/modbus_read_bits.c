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
    if (Size < sizeof(int) * 2)
    {
        return 0;
    }

    modbus_t *ctx = modbus_new_rtu("/dev/null", 115200, 'N', 8, 1);
    if (!ctx)
    {
        return 0;
    }

    modbus_set_slave(ctx, 1);
    modbus_set_response_timeout(ctx, 0, 1000 * 1000);

    int addr = ((int *)Data)[0] % 0x10000;
    int nb = ((int *)Data)[1] % 0x1000;
    Data += sizeof(int) * 2;
    Size -= sizeof(int) * 2;

    uint8_t *dest = (uint8_t *)malloc(nb * sizeof(uint8_t));
    if (!dest)
    {
        modbus_free(ctx);
        return 0;
    }

    // Inject fuzzed data to the modbus backend
    modbus_rtu_set_serial_mode(ctx, MODBUS_RTU_RS485);
    modbus_set_debug(ctx, 1);
    modbus_connect(ctx);

    ssize_t bytes_sent = write(modbus_get_socket(ctx), Data, Size);

    if (bytes_sent > 0)
    {
        modbus_read_bits(ctx, addr, nb, dest);
    }

    free(dest);
    modbus_close(ctx);
    modbus_free(ctx);
    return 0;
}