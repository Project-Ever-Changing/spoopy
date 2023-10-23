package spoopy.utils.destroy;

#if !web
import sys.thread.Lock;
#end

/*
* At first, I planned to use the regular built-in `Array` class. However, I needed a
* FIFO (first in, first out) system for deallocating Vulkan handles when necessary, and
* an array would be overly complicated. I preferred a linked list since it’s much easier
* to maintain and keep organized.
*/

class SpoopyDestroyQueue<T> {
    private var head:Node<T>;
    private var tail:Node<T>;

    // Consideration: Add a `size` or `length` variable to signify how large the queue is, but what's the point?

    public function enqueue(item:T):Void {
        #if !web
        var lock = new Lock(); // Just in case, since I'm planning to use this for multithreading reasons
        #end

        var oldTail = tail;
        tail = {item: item, next: null};

        if(isEmpty()) {
            head = tail;
        } else {
            oldTail.next = tail;
        }
    }

    private function dequeue():T { // There is no point for this to be public in this is auto deletion queue.
        if(isEmpty()) {
            throw "Queue underflow";
        }

        var item = head.item;
        head = head.next;

        if(isEmpty()) {
            tail = null;
        }

        return item;
    }

    public function isEmpty():Bool {
        return head == null;
    }
}

private typedef Node<T> = {
    private var item:T;
    private var next:Node<T>;
}