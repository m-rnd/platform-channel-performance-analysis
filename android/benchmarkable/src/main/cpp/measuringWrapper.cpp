//
// Created by Markus Reinhold on 31.05.23.
//

#include <cstring>
#include <jni.h>
#ifndef __measuring__
#include "measuring.hpp"
#endif

extern "C" {

JNIEXPORT void
JNICALL
Java_com_example_platformchannelperformance_Measuring_startMeasuring(
JNIEnv * env,
jobject /* this */ ,
jstring name,
jlong identifier
) {
const char * utfString = env -> GetStringUTFChars(name, nullptr);
startMeasuring(utfString, identifier);
}

JNIEXPORT void
JNICALL
Java_com_example_platformchannelperformance_Measuring_endMeasuring(
JNIEnv * env,
jobject /* this */ ,
jstring name,
jlong identifier
) {
const char * utfString = env -> GetStringUTFChars(name, nullptr);
endMeasuring(utfString, identifier);
}

JNIEXPORT void
JNICALL
Java_com_example_platformchannelperformance_Measuring_printLogs(
JNIEnv * env,
jobject /* this */
) {
printLogs();
}
}