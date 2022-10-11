#ifndef SPOOPY_LOG_H
#define SPOOPY_LOG_H

#include <iostream>

namespace spoopy {
    class Log {
        public:
            template<typename... Args> static void Display(const char* label, Args... args) {
                printf(label, args..., "\n");
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
    };
}

#define SPOOPY_LOG_INFO(...) ::spoopy::Log::Info(__VA_ARGS__)
#define SPOOPY_LOG_WARN(...) ::spoopy::Log::Warn(__VA_ARGS__)
#define SPOOPY_LOG_ERROR(...) ::spoopy::Log::Error(__VA_ARGS__)
#endif