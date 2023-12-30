#pragma once

#include <iostream>
#include <stdarg.h>

namespace lime { namespace spoopy {
    enum class LOG_TYPE {
        FORMATTED
    };

    /*
     * Basic logger class.
     *
     * Even though the `isFormatted` parameter is unused, it is still required to tell the compiler
     * which function to use, as the compiler cannot deduce the kind of variadic argument, meaning it has
     * a different use than what parameters are normally used for.
     */
    struct Log {


        // C++ String

        static inline void Info(const char* message) {
            printf("%s%s%s", "\033[1m\033[37m", "[Info] ", "\033[0m");
            printf("%s%s\n", "\033[0m", message);
        }

        static inline void Warn(const char* message) {
            printf("%s%s%s", "\033[1m\033[37m", "[WARN] ", "\033[0m");
            printf("%s%s%s\n", "\033[1m\033[33m", message, "\033[0m");
        }

        static inline void Error(const char* message) {
            printf("%s%s%s", "\033[1m\033[37m", "[ERROR] ", "\033[0m");
            printf("%s%s%s\n", "\033[1m\033[31m", message, "\033[0m");
        }


        // C String

        static inline void Success(const char* message) {
            printf("%s%s%s", "\033[1m\033[37m", "[SUCCESS] ", "\033[0m");
            printf("%s%s%s\n", "\033[1m\033[32m", message, "\033[0m");
        }

        static inline void Info(std::string message) {
            printf("%s%s%s", "\033[1m\033[37m", "[Info] ", "\033[0m");
            printf("%s%s\n", "\033[0m", message.c_str());
        }

        static inline void Warn(std::string message) {
            printf("%s%s%s", "\033[1m\033[37m", "[WARN] ", "\033[0m");
            printf("%s%s%s\n", "\033[1m\033[33m", message.c_str(), "\033[0m");
        }

        static inline void Error(std::string message) {
            printf("%s%s%s", "\033[1m\033[37m", "[ERROR] ", "\033[0m");
            printf("%s%s%s\n", "\033[1m\033[31m", message.c_str(), "\033[0m");
        }

        static inline void Success(std::string message) {
            printf("%s%s%s", "\033[1m\033[37m", "[SUCCESS] ", "\033[0m");
            printf("%s%s%s\n", "\033[1m\033[32m", message.c_str(), "\033[0m");
        }


        // Regular Arguments

        static inline void Success(const LOG_TYPE isFormatted, const char* format, ...) {
            printf("%s%s%s", "\033[1m\033[37m", "[SUCCESS] ", "\033[0m");
            printf("%s", "\033[1m\033[32m");

            va_list args;
            va_start(args, format);
            vprintf(format, args);
            va_end(args);

            printf("%s\n", "\033[0m");
        }

        static inline void Info(const LOG_TYPE isFormatted, const char* format, ...) {
            printf("%s%s%s", "\033[1m\033[37m", "[Info] ", "\033[0m");
            printf("%s", "\033[0m");

            va_list args;
            va_start(args, format);
            vprintf(format, args);
            va_end(args);

            printf("%s\n", "\033[0m");
        }

        static inline void Warn(const LOG_TYPE isFormatted, const char* format, ...) {
            printf("%s%s%s", "\033[1m\033[37m", "[WARN] ", "\033[0m");
            printf("%s", "\033[1m\033[33m");

            va_list args;
            va_start(args, format);
            vprintf(format, args);
            va_end(args);

            printf("%s\n", "\033[0m");
        }

        static inline void Error(const LOG_TYPE isFormatted, const char* format, ...) {
            printf("%s%s%s", "\033[1m\033[37m", "[ERROR] ", "\033[0m");
            printf("%s", "\033[1m\033[31m");

            va_list args;
            va_start(args, format);
            vprintf(format, args);
            va_end(args);

            printf("%s\n", "\033[0m");
        }
    };
}}

#define SPOOPY_LOG_INFO(...) ::lime::spoopy::Log::Info(__VA_ARGS__)
#define SPOOPY_LOG_WARN(...) ::lime::spoopy::Log::Warn(__VA_ARGS__)
#define SPOOPY_LOG_ERROR(...) ::lime::spoopy::Log::Error(__VA_ARGS__)
#define SPOOPY_LOG_SUCCESS(...) ::lime::spoopy::Log::Success(__VA_ARGS__)