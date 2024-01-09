#pragma once

/*
 * Warning: This is a very simple implementation of a linked list, meaning that there is no memory management such as
 * Garbage Collection.
 */

namespace lime { namespace spoopy {
    template<typename T> struct List {
        T* element;
        List<T>* next;

        List(T* element, List<T>* next = nullptr) {
            this->element = element;
            this->next = next;
        }
    };
}}