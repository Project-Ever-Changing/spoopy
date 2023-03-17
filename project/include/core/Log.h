#pragma once

#include <iostream>

namespace lime {
    class Log {
        public:
            template<typename... Args> static void Display(const char* label, Args... args) {
                std::cout << label;

                using output = int[];

                (void)output{0, (void(std::cout << std::forward<Args>(args)), 0)...};
                std::cout << "\n";
            }

            template<typename... Args> static void Info(Args... args) {
                Display("[INFO] ", args...);
            }

            template<typename... Args> static void Warn(Args... args) {
                Display("[WARN] ", args...);
            }

            template<typename... Args> static void Error(Args... args) {
                Display("[ERROR] ", args...);
            }

            template<typename... Args> static void Success(Args... args) {
                Display("[SUCCESS] ", args...);
            }
    };
}

#define SPOOPY_LOG_INFO(...) ::lime::Log::Info(__VA_ARGS__)
#define SPOOPY_LOG_WARN(...) ::lime::Log::Warn(__VA_ARGS__)
#define SPOOPY_LOG_ERROR(...) ::lime::Log::Error(__VA_ARGS__)
#define SPOOPY_LOG_SUCCESS(...) ::lime::Log::Success(__VA_ARGS__)