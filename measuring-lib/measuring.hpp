#ifndef __LIBMEASURING__
#define __LIBMEASURING__

#ifdef __cplusplus
extern "C" {
#endif

const void startMeasuring(const char* name, uint64_t identifier);
const void endMeasuring(const char* name, uint64_t identifier);
const void logEvent(const char* name, uint64_t value);
const void printLogs();

#ifdef __cplusplus
}
#endif

#endif /* defined(__LIBMEASURING__) */
