#include <stdint.h>

extern "C" __attribute__((visibility("default"))) __attribute__((used))
int64_t native_add(int64_t bal,int64_t wldr) {
    return bal - wldr;
}
