#pragma once

#include <core/Log.h>
#include <graphics/PixelFormat.h>
#include <spoopy.h>

#include <functional>

#define SPOOPY_MAX_HASH_CAPACITY 0x1ff


namespace std {
    template<> struct hash<VkFormat> {
        std::size_t operator()(const VkFormat& format) const {
            return std::hash<std::size_t>()(static_cast<std::size_t>(format));
        }
    };
}


template<typename T> inline void hash_combine(std::size_t &seed, const T &v) {
    std::hash<T> hasher;
    seed ^= hasher(v) + 0x9e3779b9 + (seed << 6) + (seed >> 2);
}


namespace lime { namespace spoopy {
    template<typename T> struct hashable {
        T value;
        virtual std::size_t GetHash(const uint16_t &start) const = 0;
    };

    template<typename T> class hashtable {
        public:
            hashtable() {
                for (int i=0; i<SPOOPY_MAX_HASH_CAPACITY; i++) {
                    m_data[i] = nullptr;
                }
            }

            ~hashtable() {
                for (int i=0; i<SPOOPY_MAX_HASH_CAPACITY; i++) {
                    if (m_data[i] != nullptr)delete m_data[i];
                }
            }

            bool Compare(hashable<T>* HASH) const {
                uint16_t start = 0;
                T* compare;

                do {
                    compare = m_data[HASH->GetHash(start) & SPOOPY_MAX_HASH_CAPACITY];
                    start++;
                }while(!(compare == &HASH->value || compare == nullptr)
                && start <= SPOOPY_MAX_HASH_CAPACITY); // Lazy way to avoid collisions

                return (compare != nullptr);
            }

            void InsertOrGet(hashable<T>* HASH)  {
                uint16_t start = 0;
                T v = HASH->value;

                while(start < SPOOPY_MAX_HASH_CAPACITY) {
                    std::size_t index = HASH->GetHash(start) & SPOOPY_MAX_HASH_CAPACITY;

                    if (m_data[index] == nullptr) {
                        m_data[index] = &v;
                        return;
                    }

                    if (v == *m_data[index]) {
                        return;
                    }

                    start++;
                }

                SPOOPY_LOG_WARN("spoopy_hashtable::Insert: Hash table is full!");
                return;
            }

            void Clear() {
                for (std::size_t i=0; i<SPOOPY_MAX_HASH_CAPACITY; i++) {
                    if (m_data[i] != nullptr)delete m_data[i];
                }
            }

        private:
            T* m_data[SPOOPY_MAX_HASH_CAPACITY + 1];
    };
}}