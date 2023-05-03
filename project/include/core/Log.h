#pragma once

#include <iostream>

namespace lime {
    class Log {
        public:
            static void Info(const char* message) {
                printf("%s%s%s", "\033[1m\033[37m", "[Info] ", "\033[0m");
                printf("%s%s\n", "\033[0m", message);
            }

            static void Warn(const char* message) {
                printf("%s%s%s", "\033[1m\033[37m", "[WARN] ", "\033[0m");
                printf("%s%s%s\n", "\033[1m\033[33m", message, "\033[0m");
            }

            static void Error(const char* message) {
                printf("%s%s%s", "\033[1m\033[37m", "[ERROR] ", "\033[0m");
                printf("%s%s%s\n", "\033[1m\033[31m", message, "\033[0m");
            }

            static void Success(const char* message) {
                printf("%s%s%s", "\033[1m\033[37m", "[SUCCESS] ", "\033[0m");
                printf("%s%s%s\n", "\033[1m\033[32m", message, "\033[0m");
            }

            static void Info(std::string message) {
                printf("%s%s%s", "\033[1m\033[37m", "[Info] ", "\033[0m");
                printf("%s%s\n", "\033[0m", message.c_str());
            }

            static void Warn(std::string message) {
                printf("%s%s%s", "\033[1m\033[37m", "[WARN] ", "\033[0m");
                printf("%s%s%s\n", "\033[1m\033[33m", message.c_str(), "\033[0m");
            }

            static void Error(std::string message) {
                printf("%s%s%s", "\033[1m\033[37m", "[ERROR] ", "\033[0m");
                printf("%s%s%s\n", "\033[1m\033[31m", message.c_str(), "\033[0m");
            }

            static void Success(std::string message) {
                printf("%s%s%s", "\033[1m\033[37m", "[SUCCESS] ", "\033[0m");
                printf("%s%s%s\n", "\033[1m\033[32m", message.c_str(), "\033[0m");
            }
    };
}

#define SPOOPY_LOG_INFO(...) ::lime::Log::Info(__VA_ARGS__)
#define SPOOPY_LOG_WARN(...) ::lime::Log::Warn(__VA_ARGS__)
#define SPOOPY_LOG_ERROR(...) ::lime::Log::Error(__VA_ARGS__)
#define SPOOPY_LOG_SUCCESS(...) ::lime::Log::Success(__VA_ARGS__)