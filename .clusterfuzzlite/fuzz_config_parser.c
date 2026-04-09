/* Fuzz target for nginx-lua configuration validation patterns.
 *
 * Tests that configuration string handling (directive names, values,
 * lua_shared_dict sizes, listen addresses) does not cause crashes or
 * undefined behaviour when fed arbitrary input.
 */

#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

/* Simulates parsing an nginx directive name from raw input. */
static int parse_directive(const uint8_t *data, size_t size) {
    if (size == 0) return 0;
    /* Directive names: alphanumeric + underscore, no leading digit */
    if (data[0] >= '0' && data[0] <= '9') return -1;
    for (size_t i = 0; i < size; i++) {
        char c = (char)data[i];
        if (c == ';' || c == '{' || c == '}') return (int)i;
        if (c == '\0') return (int)i;
    }
    return (int)size;
}

/* Simulates parsing a size value like "10m", "256k". */
static long parse_size_value(const uint8_t *data, size_t size) {
    if (size == 0) return -1;
    char buf[64];
    size_t len = size < sizeof(buf) - 1 ? size : sizeof(buf) - 1;
    memcpy(buf, data, len);
    buf[len] = '\0';

    char *end = NULL;
    long val = strtol(buf, &end, 10);
    if (end == buf) return -1;
    if (*end == 'k' || *end == 'K') val *= 1024;
    else if (*end == 'm' || *end == 'M') val *= 1024 * 1024;
    else if (*end == 'g' || *end == 'G') val *= 1024 * 1024 * 1024;
    return val;
}

/* Simulates parsing a listen address like "80", "127.0.0.1:8080". */
static int parse_listen_address(const uint8_t *data, size_t size) {
    if (size == 0) return -1;
    char buf[256];
    size_t len = size < sizeof(buf) - 1 ? size : sizeof(buf) - 1;
    memcpy(buf, data, len);
    buf[len] = '\0';

    /* Check for host:port format */
    char *colon = strchr(buf, ':');
    if (colon) {
        *colon = '\0';
        char *end = NULL;
        long port = strtol(colon + 1, &end, 10);
        if (port < 0 || port > 65535) return -1;
        return 0;
    }
    /* Plain port number */
    char *end = NULL;
    long port = strtol(buf, &end, 10);
    if (end == buf) return -1;
    if (port < 0 || port > 65535) return -1;
    return 0;
}

int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size) {
    if (size < 2) return 0;

    /* Use first byte to select which parser to exercise */
    uint8_t selector = data[0] % 3;
    const uint8_t *payload = data + 1;
    size_t payload_size = size - 1;

    switch (selector) {
        case 0:
            parse_directive(payload, payload_size);
            break;
        case 1:
            parse_size_value(payload, payload_size);
            break;
        case 2:
            parse_listen_address(payload, payload_size);
            break;
    }
    return 0;
}
