#pragma once

#include <iostream>

namespace lime {
    class Log {
        public:
            static void Info(const char* message) {
                printf("%s", "[WARN] ");
                printf("%s%s\n", "\033[0m", message);
            }

            static void Warn(const char* message) {
                printf("%s", "[WARN] ");
                printf("%s%s%s\n", "\033[1m\033[33m", message, "\033[0m");
            }

            static void Error(const char* message) {
                printf("%s", "[ERROR] ");
                printf("%s%s%s\n", "\033[1m\033[31m", message, "\033[0m");
            }

            static void Success(const char* message) {
                printf("%s", "[SUCCESS] ");
                printf("%s%s%s\n", "\033[1m\033[32m", message, "\033[0m");
            }
    };
}

#define SPOOPY_LOG_INFO(...) ::lime::Log::Info(__VA_ARGS__)
#define SPOOPY_LOG_WARN(...) ::lime::Log::Warn(__VA_ARGS__)
#define SPOOPY_LOG_ERROR(...) ::lime::Log::Error(__VA_ARGS__)
#define SPOOPY_LOG_SUCCESS(...) ::lime::Log::Success(__VA_ARGS__)