#ifndef _LIBCPP_STRING_H
#include <string.h>
#endif

#ifndef _TIME_H_
#include <time.h>
#endif
#ifndef _LIBCPP_IOSTREAM
#include <iostream>
#endif
#ifndef _LIBCPP_CHRONO
#include <chrono>
#endif

#ifndef __LIBMEASURING__
#include "measuring.hpp"
#endif

#define  LOG_TAG    "measure"

#ifdef __ANDROID__
    #ifndef _ANDROID_LOG_H
    #include <android/log.h>
    #endif
    #define  platformLog(...)  __android_log_print(ANDROID_LOG_INFO,LOG_TAG,__VA_ARGS__)
#else
    #ifndef __OS_LOG_H__
    #include <os/log.h>
    #endif
    static os_log_t logCategory = os_log_create("test.PlatformChannelPerformance", LOG_TAG);
    #define platformLog(...) os_log(logCategory, __VA_ARGS__);
#endif

#define MAX_LOGS 10
#define MAX_LOG_LENGTH 64
#define BUFFER_SIZE (MAX_LOGS * MAX_LOG_LENGTH)

extern "C" {
    typedef std::chrono::high_resolution_clock Clock;
    typedef std::chrono::steady_clock::time_point TimePoint;
    typedef std::chrono::nanoseconds Nanoseconds;

    TimePoint cstart;
    TimePoint cend;

    char logBuffer[BUFFER_SIZE];
    size_t bufferPosition = 0;

    const void printLogs() {
        if (bufferPosition > 0) {
            platformLog("%s", logBuffer);
            bufferPosition = 0;
        }
    }

    const void _addLog(const char *format, ...) {
        if (bufferPosition >= BUFFER_SIZE - MAX_LOG_LENGTH) printLogs();
        
        if (bufferPosition < BUFFER_SIZE) {
            va_list args;
            va_start(args, format);
            int written = vsnprintf(logBuffer + bufferPosition, BUFFER_SIZE - bufferPosition, format, args);
            va_end(args);

            if (written >= 0) bufferPosition += written;
        }
    }


    const void logEvent(const char* name, uint64_t value) {
        _addLog("%s: %lld\n", name, value);
        printLogs();
    }

    const void startMeasuring(const char* name, uint64_t identifier) {
        cstart = Clock::now();
    }

    const void endMeasuring(const char* name, uint64_t identifier) {
        cend = Clock::now();
        auto duration = std::chrono::duration_cast<Nanoseconds>(cend-cstart).count();
        _addLog("%s: %lld\n", name, duration);
    }
}
