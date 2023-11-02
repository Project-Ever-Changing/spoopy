package spoopy.utils.destroy;

import spoopy.utils.destroy.SpoopyDestroyable;

#if !web
import sys.thread.Lock;
#end

/*
* At first, I planned to use the regular built-in `Array` class. However, I needed a
* FIFO (first in, first out) system for deallocating Vulkan handles when necessary, and
* an array would be overly complicated. I preferred a linked list since it’s much easier
* to maintain and keep organized.
*/

class SpoopyDestroyQueue<T:ISpoopyDestroyable> {
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

    public function ReleaseItems(deleteImmediately:Bool):Void {
        #if !web
        var lock = new Lock();
        #end

        var curr = head;

        while(!isEmpty() && curr != null) {
            curr.item.destroy();

            var next = curr.next;
            dequeue();
            curr = next;
        }
    }

    public function isEmpty():Bool {
        return head == null;
    }

    private function dequeue():T { // There is no point for this to be public since this is auto deletion queue.
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
}

private typedef Node<T:ISpoopyDestroyable> = {
    var item:T;
    var next:Node<T>;
}