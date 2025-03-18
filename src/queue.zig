const std = @import("std");
const std_print = std.debug.print;

pub fn Queue(T: type) type {
    return struct {
        const Node = struct { value: T, next: ?*Node = null };
        const Self = @This();

        allocator: std.mem.Allocator,
        tail: ?*Node = null,
        head: ?*Node = null,
        length: usize = 0,

        pub fn enqueue(self: *Self, value: T) !void {
            const node = try self.allocator.create(Node);
            node.value = value;
            node.next = null;

            if (self.tail == null) {
                self.tail = node;
            } else if (self.tail.?.next == null) {
                self.tail.?.next = node;
                self.head = node;
            } else {
                self.head.?.next = node;
                self.head = node;
            }
            self.length += 1;
        }

        pub fn dequeue(self: *Self) ?T {
            if (self.tail) |tail| {
                defer self.allocator.destroy(tail);
                self.tail = tail.next;

                self.length -= 1;
                return tail.value;
            }
            return null;
        }

        pub fn print(self: *Self) void {
            var index: u8 = 0;
            var copy = self.*;
            while (copy.tail) |tail| : (copy.tail = tail.next) {
                index += 1;

                std_print("{d}o Elemento: {d}\n", .{ index, tail.value });
            }
        }
    };
}
