const std = @import("std");
const Queue = @import("queue.zig").Queue;

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("All your {s} are belong to us.\n", .{"codebase"});

    // stdout is for the actual output of your application, for example if you
    // are implementing gzip, then only the compressed bytes should be sent to
    // stdout, not any debugging messages.
    const stdout_file = std.io.getStdOut().writer();
    var bw = std.io.bufferedWriter(stdout_file);
    const stdout = bw.writer();

    try stdout.print("Run `zig build test` to run the tests.\n", .{});

    try bw.flush(); // don't forget to flush!
}

test "Queue!!!" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    var arena = std.heap.ArenaAllocator.init(gpa.allocator());
    defer arena.deinit();

    var queue = Queue(i32){ .allocator = arena.allocator() };

    try queue.enqueue(32);
    try queue.enqueue(34);
    try queue.enqueue(50);
    queue.print();
    _ = queue.dequeue();
    queue.print();

    try std.testing.expect(queue.dequeue() == 34);
    queue.print();
}
