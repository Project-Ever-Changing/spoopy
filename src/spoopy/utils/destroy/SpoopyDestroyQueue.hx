package spoopy.utils.destroy;

import spoopy.utils.destroy.SpoopyDestroyable;

#if !web
import sys.thread.Lock;
#end

/*
* At first, I planned to use the regular built-in `Array` class. However, I only needed a
* FILO (first in, last out) system for deallocating Vulkan handles when necessary, and
* an array would be overly complicated. I preferred a linked list since it’s much easier
* to maintain, keep organized, and basic.
*/

class SpoopyDestroyQueue<T:ISpoopyDestroyable> {
    private var head:Node<T>;
    private var tail:Node<T>;

    public function new() {
        head = null;
        tail = null;
    }

    public function enqueue(item:T):Void {
        var oldTail = tail;
        tail = {item: item, next: null};

        if(isEmpty()) {
            head = tail;
        } else {
            oldTail.next = tail;
        }
    }

    public function releaseItems():Void {
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

    public function dequeue():T {
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